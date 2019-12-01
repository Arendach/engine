<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;
use Web\Eloquent\Order;

class Index extends Model
{
    /**
     * @return false|int|string
     */
    public static function work_schedule()
    {
        $schedules = R::count('work_schedule_day', '`user` = ? AND MONTH(`date`) = ? AND YEAR(`date`) = ?', [
            user()->id,
            date('m'),
            date('Y'),
        ]);

        return date('d') - $schedules;
    }

    /**
     * @return array
     */
    public static function work_schedules_month()
    {
        $year = date('m') == 1 ? date('Y') - 1 : date('Y');
        $month = date('m' == 1) ? 12 : date('m') - 1;

        $schedules = R::count('work_schedule_day', '`user` = ? AND MONTH(`date`) = ? AND YEAR(`date`) = ?', [
            user()->id,
            $month,
            $year
        ]);

        return [
            'work_schedules_month' => day_in_month($month, $year) - $schedules,
            'year' => $year,
            'month' => $month
        ];
    }

    /**
     * @return array
     */
    public static function moving_money()
    {
        return R::findAll('reports', '`data` = ?', [user()->id . ':0']);
    }

    /**
     * @return object
     */
    public static function not_close_orders()
    {
        return (object)[
            'delivery' => Order::where('type', 'delivery')->where('courier_id', user()->id)->whereIn('status', [0,1])->count(),
            'self' => Order::where('type', 'self')->where('courier_id', user()->id)->whereIn('status', [0,1])->count(),
            'sending' => Order::where('type', 'sending')->where('courier_id', user()->id)->whereIn('status', [0,1])->count(),
        ];
    }

    /**
     * @return array
     */
    public static function not_moving_money()
    {
        return (R::findAll('reports', '`user` = ? AND `type` = ? AND `data` LIKE ?', [
            user()->id,
            'moving',
            '%:0'
        ]));
    }

    /**
     * @return object
     */
    public static function liable_orders()
    {
        $from = date('Y-m-d', time() - 60 * 60 * 24 * 90);
        $to = date('Y-m-d', time() + 60 * 60 * 24 * 365);

        return (object)[
            'self' => R::count('orders', "`type` = 'self' AND `liable` = ? AND DATE(`date`) BETWEEN ? AND ?", [user()->id, $from, $to]),
            'delivery' => R::count('orders', "`type` = 'delivery' AND `liable` = ? AND DATE(`date`) BETWEEN ? AND ?", [user()->id, $from, $to])
        ];
    }
}