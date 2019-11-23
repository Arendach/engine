<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

class Statistic extends Model
{
    const table = 'statistic';

    public function getOrdersStatistic($start, $finish, $display)
    {
        // $where
        $where = "orders.date BETWEEN STR_TO_DATE('$start 00:00:00', '%Y-%m-%d %H:%i:%s') AND STR_TO_DATE('$finish 00:00:00', '%Y-%m-%d %H:%i:%s')\n";
        if (get('type')) $where .= " AND `orders`.`type` = '" . get('type') . "' \n";
        if (get('status')) $where .= " AND `orders`.`status` = '" . get('status') . "' \n";

        // $groupBy
        if ($display == 'year') $groupBy = "GROUP BY YEAR(orders.date)";
        elseif ($display == 'month') $groupBy = "GROUP BY MONTH(orders.date)";
        elseif ($display == 'week') $groupBy = "GROUP BY WEEK(orders.date)";
        elseif ($display == 'day') $groupBy = "GROUP BY DAY(orders.date)";
        else                         $groupBy = "";

        // $sql
        $sql = "
            SELECT 
                MIN(orders.date) as start,
                MAX(orders.date) as finish,
                SUM(orders.delivery_cost) AS delivery_cost,
                SUM(orders.discount) as discount,
                SUM(pto.amount * pto.price) - SUM(orders.discount) + SUM(orders.delivery_cost) as full_sum,
                SUM(pto.amount * p.procurement_costs) as procurement_costs,
                COUNT(distinct orders.id) as count
            FROM 
                orders 
            LEFT JOIN product_to_order as pto ON (pto.order_id = orders.id)
            LEFT JOIN products as p ON (p.id = pto.product_id)
            WHERE 
                $where 
            $groupBy
            ORDER BY orders.id DESC
            ";

        // result
        return R::getAll($sql);
    }

    public static function getManagersCosts($year, $month)
    {
        $beans = R::findAll('report_items', '`year` = ? AND `month` = ?', [$year, $month]);

        $sum = 0;
        foreach ($beans as $bean) $sum += $bean->start_month + $bean->just_now;

        return $sum;
    }

    public static function getPurchases()
    {
        $result = R::getRow('SELECT SUM(`sum` - `prepayment`) as `sum` FROM `purchases` WHERE `status` IN(0,1)');

        return $result['sum'];
    }

    public static function getReserve()
    {
        $result = R::getRow('SELECT SUM(`reserve_funds`) as `sum` FROM `users`');

        return $result['sum'];
    }

    public static function getProducts()
    {
        $beans = R::findAll('storage');

        $temp = [];
        foreach ($beans as $bean) {
            $res = R::getRow('SELECT SUM(`procurement_costs` * `count_on_storage`) as `sum` FROM `products` WHERE `storage` = ?', [$bean->id]);

            $temp[$bean->id] = $res['sum'];
        }

        return $temp;
    }

}