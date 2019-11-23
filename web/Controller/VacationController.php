<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Model\Vacation;
use RedBeanPHP\R;
use DateTime;
use DateInterval;
use DatePeriod;

class VacationController extends Controller
{
    public $access = 'vacation';
    public $max_days = 24;

    public function section_main()
    {
        $data = [
            'components' => ['calendar', 'modal'],
            'scripts' => ['vacation.js'],
            'vacations' => Vacation::getThisYear(),
            'users' => Vacation::findAll('users', 'archive = 0'),
            'breadcrumbs' => [['Планувальник відпусток']]
        ];

        $this->view->display('vacation.main', $data);
    }

    public function action_get_add_form()
    {
        $vacations = Vacation::getThisYear();

        $data = [
            'closed' => Vacation::getThisYear(),
            'errors' => [],
            'title' => 'Бронювання відпустки'
        ];

        $count = 0;
        foreach ($vacations as $vacation) {
            foreach ($vacation as $item) {
                if ($item['user'] == user()->id) $count++;
            }
        }

        // dd($vacations);

        if ($count >= $this->max_days) {
            $data['errors'][] = 'Ви не можете більше брати відпустку цього року!';
        }

        $this->view->display('vacation.add_form', $data);
    }

    public function action_check_vacation($post)
    {
        $cd = $post->count_days - 1;
        $to = (new DateTime($post->with))->add(new DateInterval('P' . $cd . 'D'));
        $count = R::count('vacations', '`user` = ? AND YEAR(`date`) = ?', [user()->id, date('Y')]);

        if (date_parse($post->with)['year'] != date('Y'))
            $this->response(400, "Ви можете бронювати відпустку тільки цього року!");

        if (!is_numeric($post->count_days))
            $this->response(400, "В полі кількість днів ведіть число!");

        if (R::count('vacations', 'DATE(`date`) BETWEEN DATE(?) AND DATE(?)', [$post->with, $to->format('Y-m-d')]) > $cd + 1)
            $this->response(400, "В вибраний період відпустку вже заброньовано іншими користувачами!");

        if ($count >= $this->max_days)
            $this->response(400, "Ви вже використали всі дні для відпустки!");
        elseif ($count + $post->count_days > $this->max_days)
            $this->response(400, "Ви можете забронювати відпустку максимум на " . ($this->max_days - $count) . " дні(в)!");

        $date = 'з ' . date_for_humans($post->with) . ' по ' . date_for_humans($to->format('Y-m-d'));

        $this->response(200, 'В період ' . $date . ' можна бронювати відпустку!');
    }

    public function action_save_vacations($post)
    {
        $cd = $post->count_days;
        $start = new DateTime($post->with);
        $interval = new DateInterval('P1D');
        $end = new DateTime($start->add(new DateInterval('P' . $cd . 'D'))->format('Y-m-d'));

        $period = new DatePeriod(new DateTime($post->with), $interval, $end);

        foreach ($period as $date) {
            $bean = R::dispense('vacations');
            $bean->user = user()->id;
            $bean->date = $date->format('Y-m-d');
            R::store($bean);
        }

        response(200, 'Відпустку вдало заброньовано!');
    }

    public function action_delete_day($post)
    {
        Vacation::delete($post->id);

        response(200, DATA_SUCCESS_DELETED);
    }

    private function response($status, $text)
    {
        $type = $status == 200 ? 'success' : 'danger';
        header('Content-Type: application/json');
        response($status, "<span class='text-$type'>$text</span>");
    }
}