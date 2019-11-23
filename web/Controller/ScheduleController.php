<?php

namespace Web\Controller;

use RedBeanPHP\R;
use Web\App\Controller;
use Web\Model\Reports;
use Web\Model\Schedule;

class ScheduleController extends Controller
{
    public function section_main()
    {
        $user_id = get('user') ? get('user') : user()->id;

        $user = user($user_id);

        if (cannot('schedule') && $user->id != user()->id)
            $this->display_403();

        if ($user->id == user()->id) {
            $title = 'Мій профіль :: Мої графіки роботи';

            $breadcrumbs = [
                ['Мій профіль', uri('user', ['section' => 'profile'])],
                ['Мої графіки роботи']
            ];

        } else {
            $title = "Менеджери :: Графіки роботи {$user->login}";

            $breadcrumbs = [
                ['Менеджери', uri('user')],
                [$user->login, uri('user', ['section' => 'view', 'id' => $user->id])],
                ['Графіки роботи']
            ];
        }

        $data = [
            'title' => $title,
            'schedules' => Schedule::getScheduleMonthByUser($user->id),
            'breadcrumbs' => $breadcrumbs
        ];

        $this->view->display('schedule.main', $data);
    }

    public function section_view()
    {
        $user_id = get('user') ? get('user') : user()->id;
        $user = user($user_id);

        if (user()->id != $user->id && cannot('schedule')) $this->display_403();

        $year = get('year') ? get('year') : date('Y');
        $month = get('month') ? get('month') : date('m');

        if ($user_id == user()->id) {
            $title = 'Мій профіль :: Мій графік роботи';

            $breadcrumbs = [
                ['Мій профіль', uri('user', ['section' => 'profile'])],
                ['Графіки роботи', uri('schedule')],
                [int_to_month($month) . ' ' . $year]
            ];
        } else {
            $title = 'Менеджери :: Графік роботи ' . $user->login;

            $breadcrumbs = [
                ['Менеджери', uri('user')],
                [$user->login, uri('user', ['section' => 'view', 'id' => $user->id])],
                ['Графіки роботи', uri('schedule', ['user' => $user->id])],
                [int_to_month($month) . ' ' . $year]
            ];
        }

        $items = get_object(Schedule::getUserWorkSchedule($year, $month, $user_id));

        $new = []; // пункти графіку

        $working = 0; // робочих днів (фактичних)
        $holidays = 0; // вихідних днів (фактичних)
        $hospital = 0; // лікарняних
        $vacation = 0; // у відпустці

        foreach ($items->schedules as $item) {
            $new[date_parse($item->date)['day']] = $item;

            if ($item->type == 0) $holidays++;
            elseif ($item->type == 1) $working++;
            elseif ($item->type == 2) $vacation++;
            else $hospital++;
        }

        $price_month = $this->calculate_price_month($items);

        // Зарплата = Ставка за місяць + бонуси за додаткові дні + бонуси + бонуси за перевиконання годин - штрафи
        $salary = $price_month + $items->bonus + $items->for_car - $items->fine;


        $bonus = $this->getBonuses($items->schedules, $items->coefficient, $year, $month, $items->price_month);

        unset($items->schedules);

        $data = [
            'title' => $title,
            'data' => $items,
            'components' => ['modal', 'jquery'],
            'scripts' => ['work_schedule/user.js'],
            'schedules' => $new,
            'bonus' => $bonus,
            'salary' => $salary,
            'bonuses' => Schedule::get_bonuses($year, $month, $user_id),
            'breadcrumbs' => $breadcrumbs,
            'payouts' => Schedule::getPayouts($year, $month, $user_id),
            'payouts_sum' => Schedule::getPayoutsSum($year, $month, $user_id),
            'working' => $working,
            'holidays' => $holidays,
            'vacation' => $vacation,
            'hospital' => $hospital,
            'price_month' => $price_month
        ];

        $this->view->display('schedule.view', $data);
    }

    public function section_users()
    {
        $data = [
            'title' => 'Менеджери :: Звіти',
            'users' => Schedule::getDistinctUsers(),
            'breadcrumbs' => [
                ['Менеджери', uri('user')],
                ['Графіки роботи']
            ]
        ];

        $this->view->display('schedule.users', $data);
    }

    public function action_update_day_form($post)
    {
        $data = [
            'wsd' => Schedule::getOne($post->id, 'work_schedule_day'),
            'title' => 'Редагувати графік'
        ];

        $this->view->display('schedule.forms.update_day', $data);
    }

    public function action_create_day_form($post)
    {
        $data = [
            'title' => 'Заповнити графік',
            'year' => $post->year,
            'month' => $post->month,
            'user' => $post->user,
            'day' => $post->day
        ];

        $this->view->display('schedule.forms.create_day', $data);
    }

    public function action_update_head_form($post)
    {
        $data = Schedule::findMonth($post);
        $this->view->display('schedule.forms.update_head', ['data' => $data, 'title' => 'Редагувати дані']);
    }

    public function action_update_head($post)
    {
        Schedule::update($post, $post->id, 'work_schedule_month');

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_update_bonuses_form($post)
    {
        $data = Schedule::findMonth($post);
        $this->view->display('schedule.forms.update_bonuses', ['data' => $data, 'title' => 'Редагувати бонуси']);
    }

    public function action_update_bonuses($post)
    {
        Schedule::update($post, $post->id, 'work_schedule_month');

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_update_day($post)
    {
        if (!isset($post->turn_up)) $post->turn_up = 9;
        if (!isset($post->went_away)) $post->went_away = 17;
        if (!isset($post->dinner_break)) $post->dinner_break = 0;
        if (!isset($post->work_day)) $post->work_day = 8;

        Schedule::update($post, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_create_day($post)
    {
        if (!isset($post->turn_up)) $post->turn_up = 9;
        if (!isset($post->went_away)) $post->went_away = 17;
        if (!isset($post->dinner_break)) $post->dinner_break = 0;
        if (!isset($post->work_day)) $post->work_day = 8;

        $date = $post->year . '-' . month_valid($post->month) . '-' . month_valid($post->day);
        unset($post->year, $post->month, $post->day);

        if (R::count('work_schedule_day', 'DATE(`date`) = ? AND `user` = ?', [$date, $post->user]))
            response(400, 'Цей день вже є в графіку роботи!');

        $post->date = $date;
        Schedule::insert($post);

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_create_payout_form($post)
    {
        $data = [
            'title' => 'Нова виплата',
            'year' => $post->year,
            'month' => $post->month,
            'user' => $post->user,
            'max_payout' => $this->maxPayout($post->year, $post->month, $post->user)
        ];

        $this->view->display('schedule.forms.create_payout', $data);
    }

    public function action_update_payout_form($post)
    {
        $payout = Schedule::getOne($post->id, 'payouts');

        $data = [
            'title' => 'Редагування виплати',
            'payout' => Schedule::getOne($post->id, 'payouts'),
            'max_payout' => $this->maxPayout($payout->year, $payout->month, $payout->user)
        ];

        $this->view->display('schedule.forms.update_payout', $data);
    }

    public function action_create_payout($post)
    {
        if ($post->sum == 0) response(400, 'Сума не може бути нулем!');

        $post->date_payout = date('Y-m-d H:i:s');
        $post->author = user()->id;

        $payout_id = Schedule::insert($post, 'payouts');

        Reports::createPayout($post->sum, $payout_id, $post->user);

        response(200, 'Виплата вдало прийнята!');
    }

    public function action_update_payout($post)
    {
        if ($post->sum == 0) response(400, 'Сума не може бути нулем!');

        Schedule::update($post, $post->id, 'payouts');

        Reports::updatePayout($post->sum, $post->id);

        response(200, 'Виплату вдало відредаговано!');
    }

    public function action_delete_payout($post)
    {
        Reports::deletePayout($post->id);

        Schedule::delete($post->id, 'payouts');

        response(200, 'Виплата вдало видалена!');
    }

    public function action_create_bonus_form($post)
    {
        $post->title = 'Новий бонус';

        $this->view->display('schedule.forms.create_bonus', $post);
    }

    public function action_create_bonus($post)
    {
        Schedule::createBonus($post);

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_bonus_form($post)
    {
        $data = [
            'bonus' => Schedule::getOne($post->id, 'bonuses'),
            'title' => 'Редагування бонуса',
            'post' => $post
        ];

        $this->view->display('schedule.forms.update_bonus', $data);
    }

    public function action_update_bonus($post)
    {
        Schedule::updateBonus($post);

        response(200, DATA_SUCCESS_UPDATED);
    }

    // Бонуси за перепрацювання
    public function getBonuses($items, $coefficient, $year, $month, $price_month)
    {
        $over_full_hours = 0; // Кількість перепрацьованих годин
        $bonus_per_hour = 0; // бонус за перевиконання

        foreach ($items as $item) {
            // кількість перепрацьованих годин
            $b = ($item->went_away - $item->dinner_break - $item->turn_up) - $item->work_day;

            if ($b > 0) {
                $over_full_hours += $b * $coefficient;
                $bonus_per_hour += ($price_month / count_working_days($year, $month) / 8) * $b * $coefficient;
            }
        }

        return round($bonus_per_hour, 2);
    }

    public function maxPayout($year, $month, $user_id)
    {
        $items = get_object(Schedule::getUserWorkSchedule($year, $month, $user_id));

        $new = [];
        foreach ($items->schedules as $item) $new[date_parse($item->date)['day']] = $item;

        // Зарплата = Ставка за місяць + бонуси за додаткові дні + бонуси + бонуси за перевиконання годин - штрафи
        $salary = $this->calculate_price_month($items) + $items->bonus + $items->for_car - $items->fine;

        unset($items->schedules);

        $payouts_sum = Schedule::getPayoutsSum($year, $month, $user_id);

        return [
            'salary' => $salary,
            'payouts_sum' => $payouts_sum,
            'max' => $salary - $payouts_sum
        ];
    }

    private function calculate_price_month($items): float
    {
        $hour_price = $items->price_month / count_working_days($items->year, $items->month) / 8;

        $working_hours = 0; // робочих годин (фактичних)
        $up_working_hours = 0; // перепрацьовані години
        $hospital_hours = 0; // на лікарняному

        foreach ($items->schedules as $item) {

            // пропрацьовано годин цього дня
            $worked = $item->went_away - $item->turn_up - $item->dinner_break;

            if ($item->type == 1 || $item->type == 2) $working_hours += $worked;
            elseif ($item->type == 3) $hospital_hours += $worked;


            // підрахунок перепрацьованих годин
            if ($worked - $item->work_day > 0) $up_working_hours += $worked - $item->work_day;
        }


        
        $h = $hour_price;
        $hh = $hospital_hours;

        if ($hh <= 24)
            $matrix = [$hh * $h];
        elseif ($hh > 24 && $hh <= 56)
            $matrix = [24 * $h, ($hh - 24) * $h * 0.8];
        elseif ($hh > 56 && $hh <= 120)
            $matrix = [24 * $h, 32 * $h * 0.8, ($hh - 56) * $h * 0.5];
        elseif ($hh > 120 && $hh <= 184)
            $matrix = [24 * $h, 32 * $h * 0.8, 64 * $h * 0.5, ($hh - 120) * $h * 0.3 ];
        else
            $matrix = [24 * $h, 32 * $h * 0.8, 64 * $h * 0.5, 64 * $h * 0.3, 0];

        $hospital_price = array_sum($matrix);



        // перерахування ставки
        $price_month = ($working_hours * $hour_price)
            - ($up_working_hours * $hour_price)
            + ($up_working_hours * $items->coefficient * $hour_price)
            + $hospital_price;

        $price_month = round($price_month, 2);

        $this->view->share('working_hours', $working_hours);
        $this->view->share('up_working_hours', $up_working_hours);
        $this->view->share('hour_price', $hour_price);
        $this->view->share('hospital_hours', $hospital_hours);

        return $price_month;

    }
}