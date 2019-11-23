<?php

namespace Web\Controller;

use Carbon\Carbon;
use Web\App\Controller;
use Web\Model\Reports;

class ReportsController extends Controller
{
    // Мої звіти
    // Користувач бачить тільки свої звіти
    public function section_my()
    {
        if (get('month') && get('year')) {
            $params = [
                'month' => get('month'),
                'year' => get('year'),
                'user' => user()->id];
        } else {
            $params = [
                'month' => date('m'),
                'year' => date('Y'),
                'user' => user()->id];
        }

        if ($params['year'] == date('Y') && $params['month'] == date('m')) {
            $createIfNotExists = true;
        } else {
            $createIfNotExists = false;
        }

        $data = [
            'title' => 'Мої звіти',
            'reports' => Reports::getReports($params),
            'report_item' => Reports::getReport($params['year'], $params['month'], $params['user'], $createIfNotExists),
            'user' => user()->id,
            'breadcrumbs' => [
                ['Менеджери', uri('user')],
                [user()->login, uri('reports', ['section' => 'user', 'id' => user()->id])],
                ['Звіти']
            ]
        ];

        $this->display_reports($data);
    }

    // Звіти менеджерів
    // Той в кого є ключ може бачити всі звіти
    // @access - reports
    public function section_view()
    {
        $params = [];
        $params['year'] = get('year') != false ? get('year') : date('Y');
        $params['month'] = get('month') != false ? get('month') : date('m');
        $params['user'] = get('user') != false ? get('user') : user()->id;

        //  Перевірка прав доступу
        $this->authorization($params['user']);

        $data = [
            'title' => 'Звіти менеджера ' . user($params['user'])->login . ' за ' . int_to_month($params['month']) . ' ' . $params['year'],
            'reports' => Reports::getReports($params),
            'report_item' => Reports::getReport($params['year'], $params['month'], $params['user'], true),
            'user' => $params['user'],
            'breadcrumbs' => [
                ['Менеджери', uri('user')],
                [user()->login, uri('reports', ['section' => 'user', 'id' => user($params['user'])->id])],
                ['Звіти']
            ]
        ];

        $this->display_reports($data);
    }

    // Звіти по місяцях
    // Той в кого є ключ може бачити всі звіти
    // @access - reports
    public function section_user()
    {
        //  Перевірка прав доступу
        $this->authorization(get('user') ? get('user') : user()->id);

        if (get('user') == user()->id)
            $breadcrumbs = [
                ['Мій профіль', uri('user', ['section' => 'profile'])],
                ['Мої звіти']
            ];
        else
            $breadcrumbs = [
                ['Менеджери', uri('user', ['section' => 'list'])],
                [user(get('user'))->login, uri('user', ['id' => get('user'), 'section' => 'view'])],
                ['Звіти']
            ];

        $data = [
            'title' => 'Мої звіти',
            'breadcrumbs' => $breadcrumbs
        ];

        $this->view->display('reports.user', $data);
    }

    // Створення звіту - Переміщення коштів
    public function section_moving()
    {
        $data = [
            'title' => 'Мої звіти :: Переміщення коштів',
            'breadcrumbs' => [
                ['Мої звіти', uri('reports', ['section' => 'my'])],
                ['Переміщення коштів']
            ]
        ];

        $this->view->display('reports.create.moving', $data);
    }

    // Створення звіту - Резервний фонд
    public function section_reserve_funds()
    {
        $report = Reports::getReport(date('Y'), date('m'), user()->id);

        $data = [
            'title' => 'Мої звіти :: Резервний фонд',
            'max_down' => user()->reserve_funds,
            'max_up' => $report->start_month + $report->just_now,
            'breadcrumbs' => [
                ['Мої звіти', uri('reports', ['section' => 'my'])],
                ['Резервний фонд']
            ]
        ];

        $this->view->display('reports.reserve_funds', $data);
    }

    // Створення звіту - Видатки
    public function section_expenditures()
    {
        $data = [
            'title' => 'Мої звіти :: Видатки',
            'breadcrumbs' => [
                ['Мої звіти', uri('reports', ['section' => 'my'])],
                ['Видатки']
            ]
        ];

        $this->view->display('reports.create.expenditures', $data);
    }

    // Створення звіту - Витрати на доставку
    public function section_shipping_costs()
    {
        $data = [
            'title' => 'Мої звіти :: Витрати на доставку',
            'breadcrumbs' => [
                ['Мої звіти', uri('reports', ['section' => 'my'])],
                ['Витрати на доставку']
            ]
        ];

        $this->view->display('reports.create.shipping_costs', $data);
    }

    // Створення звіту - Прибуток
    public function section_profits()
    {
        $data = [
            'title' => 'Мої звіти :: Прибутки',
            'breadcrumbs' => [
                ['Мої звіти', uri('reports', ['section' => 'my'])],
                ['Прибутки (коректування)']
            ]
        ];

        $this->view->display('reports.create.profits', $data);
    }

    // Оновити резервний фонд
    public function action_reserve_funds_update($post)
    {
        $report = Reports::getReport(date('Y'), date('m'), user()->id);

        if ($post->act == 'put') {
            $in_hand = $report->start_month + $report->just_now;

            if ($post->sum > $in_hand)
                response(400, 'Ви не можете поставити в резервний фонд більше ніж ' . $in_hand . ' грн!');

            if ($post->sum <= 0)
                response(400, 'Ви не можете поставити в резервний фонд суму меншу чи рівну нулю!');
        } else {
            if ($post->sum > user()->reserve_funds)
                response(400, "Ви не можете забрати з резервного фонду більше ніж " . user()->reserve_funds . " грн!");

            if ($post->sum <= 0)
                response(400, 'Ви не можете забрати з резервного фонду суму меншу чи рівну нулю!');
        }

        Reports::reserve_funds_update($post->sum, $post->act);

        $response = [
            'message' => DATA_SUCCESS_CREATED,
            'action' => 'redirect',
            'uri' => uri('reports', ['section' => 'my'])
        ];

        response(200, $response);
    }

    // Форма підтвердження передачі коштів
    public function action_close_moving_form($post)
    {
        $data = [
            'title' => 'Отримання коштів',
            'report' => Reports::getOne($post->id)
        ];

        $this->view->display('reports.forms.close_moving_form', $data);
    }

    // Підтвердження передачі коштів
    public function action_success_moving($post)
    {
        if (!isset($post->name_operation) || empty($post->name_operation))
            response(400, 'Введіть назву операції!');

        Reports::successMoving($post);

        response(200, 'Кошти вдало переміщені!');
    }

    // Створення передачі коштів
    public function action_create_moving($post)
    {
        if (!isset($post->user) || empty($post->user))
            response(400, 'Виберіть менеджера!');

        $this->check($post);

        Reports::createMoving($post);

        $login = user($post->user)->login;

        $response = [
            'message' => "Кошти буде передано, як тільки $login підтвердить передачу!",
            'action' => 'redirect',
            'uri' => uri('reports', ['section' => 'my'])
        ];

        response(200, $response);
    }

    // Видатки
    public function action_create_expenditures($post)
    {
        $this->check($post);

        $array = ['taxes', 'investment', 'mobile', 'rent', 'social', 'other', 'advert'];
        $data = [];

        foreach ($array as $item) {
            if (!isset($post->$item) || empty($post->$item)) {
                $data[$item] = 0;
            } else {
                $data[$item] = $post->$item;
            }
        }

        Reports::createExpenditures($post, $data);

        $response = [
            'message' => 'Видатки вдало збережені!',
            'action' => 'redirect',
            'uri' => uri('reports', ['section' => 'my'])
        ];

        response(200, $response);
    }

    // Витрати на доставку
    public function action_create_shipping_costs($post)
    {
        $this->check($post);

        $array = ['gasoline', 'journey', 'transport_company', 'packing_materials', 'for_auto', 'salary_courier', 'supplies'];
        $data = [];

        foreach ($array as $item) {
            if (!isset($post->$item) || empty($post->$item)) {
                $data[$item] = 0;
            } else {
                $data[$item] = $post->$item;
            }
        }

        $response = [
            'message' => 'Витрати на доставку вдало збережені!',
            'action' => 'redirect',
            'uri' => uri('reports', ['section' => 'my'])
        ];

        Reports::createShippingCosts($post, $data);

        response(200, $response);
    }

    // Прибутки
    public function action_create_profits($post)
    {
        $this->check($post);

        Reports::createProfits($post);

        $response = [
            'message' => 'Прибутки вдало збережені!',
            'action' => 'redirect',
            'uri' => uri('reports', ['section' => 'my'])
        ];

        response(200, $response);
    }


    // Превю
    public function action_preview($post)
    {
        $data = ['report' => Reports::getOne($post->id)];
        $this->view->display("reports.preview.{$data['report']->type}", $data);
    }


    // Відображення звіту
    private function display_reports($data)
    {
        $data['components'] = ['modal'];

        $this->view->display('reports.display', $data);
    }

    // Валідація форми
    private function check($post)
    {
        if (!isset($post->sum) || empty($post->sum))
            response(400, 'Сума не може бути пустою!');

        if (!isset($post->name_operation) || empty($post->name_operation))
            response(400, 'Введіть назву операції!');
    }

    // Форма оновлення коментара
    public function action_update_form($post)
    {
        $data = [
            'title' => 'Редагування звіту',
            'report' => Reports::getOne($post->id, 'reports')
        ];

        $this->view->display('reports.update.index', $data);
    }

    // Оновлення коментара
    public function action_update_comment($post)
    {
        Reports::update(['comment' => $post->comment], $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function section_statistics()
    {
        $reports = Reports::findAll('reports', "type IN('shipping_costs','expenditures') AND `user` = ? ORDER BY id DESC", [get('user')]);

        $group_reports = [];

        foreach ($reports as $report) {
            $date = Carbon::parse($report->date);

            if (!isset($group_reports[$date->year]))
                $group_reports[$date->year] = [];

            if (!isset($group_reports[$date->year][$date->month]))
                $group_reports[$date->year][$date->month] = [];

            $data = explode("\n", $report->data);

            foreach ($data as $item) {
                $ex = explode(":", $item);

                if (!isset($group_reports[$date->year][$date->month][$report->type][$ex[0]]))
                    $group_reports[$date->year][$date->month][$report->type][$ex[0]] = 0;

                $group_reports[$date->year][$date->month][$report->type][$ex[0]] += is_numeric($ex[1]) ? $ex[1] : 0;
            }
        }

        $data = [
            'title' => 'Статистика по звітах',
            'data' => $group_reports,
            'breadcrumbs' => [
                ['Звіти', uri('reports', ['section' => 'view', 'user' => get('user')])],
                ['Статистика по звітах']
            ]
        ];

        $this->view->display('reports.statistics', $data);
    }


    private function authorization($user_id)
    {
        if (!(user()->id == $user_id || can('reports')))
            $this->display_403();
    }
}