<?php

namespace Web\Controller;

use Web\Model\Statistic;
use Web\App\Controller;

class StatisticController extends Controller
{
    public $access = 'statistic';

    /**
     * @var Statistic
     */
    public $model;

    /**
     * @var string
     */
    public $start;

    /**
     * @var
     */
    public $parse_start;

    /**
     * @var false|string
     */
    public $finish;

    /**
     * @var
     */
    public $parse_finish;

    /**
     * Controller constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $this->model = new Statistic();

        $this->start = get('date_with') ? get('date_with') : START_LIFE;
        $this->finish = get('date_to') ? get('date_to') : date('Y-m-d');

        if ($this->start < START_LIFE) {
            $p = date_parse(START_LIFE);
            $this->start = $p['year'] . '-' . $p['month'] . '-' . $p['day'];
        }

        if ($this->finish > date("Y-m-d"))
            $this->finish = date('Y-m-d');

        $this->parse_start = date_parse($this->start);
        $this->parse_finish = date_parse($this->finish);
    }

    public $main_section = 'section_orders';

    /**
     * MAIN section
     */
//    public function section_main()
//    {
//
//    }

    public function section_orders()
    {
        $displays = ['year', 'month', 'week', 'day'];
        $display = in_array(get('display'), $displays) ? get('display') : false;
        $items = $this->model->getOrdersStatistic($this->start, $this->finish, $display);

        $data = [
            'scripts' => [
                'statistic/main.js'
            ],
            'title' => 'Статистика',
            'data' => $items,
            'to_js' => [
                'Statuses' => [
                    'delivery' => get_order_statuses('delivery'),
                    'sending' => get_order_statuses('sending'),
                    'shop' => get_order_statuses('shop'),
                    'self' => get_order_statuses('self'),
                ]
            ],
            'breadcrumbs' => [['Статистика']]
        ];


        $this->view->display('statistic.orders', $data);
    }

    public function section_stat()
    {
        $year = get('year') ? get('year') : date('Y');
        $month = get('month') ? get('month') : date('m');

        $data = [
            'managers_costs' => Statistic::getManagersCosts($year, $month),
            'purchases' => Statistic::getPurchases(),
            'reserve_funds' => Statistic::getReserve(),
            'products' => Statistic::getProducts()
        ];

        dd($data);
    }
}