<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

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
     * @return array
     */
    public static function not_close_orders()
    {
        return (get_object(R::getRow("
            SELECT 
                (SELECT COUNT(`orders`.`id`) FROM `orders` WHERE 
                    `orders`.`type` = 'delivery' AND 
                    `orders`.`courier` = `users`.`id` AND 
                    `orders`.`status` IN(0,1)
                ) AS `delivery`,
                (SELECT COUNT(*) FROM `orders` WHERE 
                    `orders`.`type` = 'self' AND 
                    `orders`.`courier` = `users`.`id` AND 
                    `orders`.`status` IN(0,1)
                ) AS `self`,
                (SELECT COUNT(*) FROM `orders` WHERE 
                    `orders`.`type` = 'sending' AND 
                    `orders`.`courier` = `users`.`id` AND 
                    `orders`.`status` IN(0,1)
                ) AS `sending`,
                (SELECT COUNT(*) FROM `orders` WHERE 
                    `orders`.`type` = 'shop' AND 
                    `orders`.`courier` = `users`.`id` AND 
                    `orders`.`status` = 0
                ) AS `shop`
            FROM
                `users`
            WHERE `users`.`id` = ?", [user()->id])));
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