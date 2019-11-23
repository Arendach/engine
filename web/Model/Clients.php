<?php

namespace Web\Model;

use RedBeanPHP\R;
use Web\App\Model;
use Web\App\NewPaginate;

class Clients extends Model
{
    const table = 'clients';

    /**
     * @return array
     */
    public static function getClients()
    {
        $fields = ['name', 'email', 'phone', 'address', 'group'];

        $sql = 'clients.id > 0';
        foreach ($fields as $field) if (get($field)) $sql .= " AND clients.$field LIKE '%" . get($field) . "%'";


        $p = (new NewPaginate('clients', $sql))
            ->setGroupBy('clients.id')
            ->setOrderBy('clients.id', 'DESC')
            ->get();

        return R::getAll("SELECT 
                `clients`.*,
                `clients_group`.`name` AS `group_name` 
            FROM 
                `clients` 
            LEFT JOIN `clients_group` ON(`clients_group`.`id` = `clients`.`group`) 
            {$p->query_string}");
    }

    /**
     * @param $id
     * @return object
     */
    public static function getClient($id)
    {
        return (object)R::getRow('
            SELECT 
                `clients`.*,
                 `clients_group`.`name` AS `group_name` 
            FROM 
                `clients` 
            LEFT JOIN `clients_group` ON(`clients_group`.`id` = `clients`.`group`) 
            WHERE 
                `clients`.`id` = ?', [$id]);
    }

    /**
     * @param $id
     * @return array
     */
    public static function getOrders($id)
    {
        return R::getAll('
            SELECT
                `client_orders`.`id` AS `cl_id`,
                `client_orders`.`order_id` AS `cl_id_order`,
                `client_orders`.`client_id` AS `cl_id_client`,
                `orders`.*,
                SUM(`pto`.`amount` *  `pto`.`price`) + `orders`.`delivery_cost` - `orders`.`discount` AS `full_sum`            
            FROM
                `client_orders`
            LEFT JOIN `orders` ON(`orders`.`id` = `client_orders`.`order_id`)
            LEFT JOIN `product_to_order` AS `pto` ON(`pto`.`order_id` = `client_orders`.`order_id`) 
            WHERE 
                `client_orders`.`client_id` = ? 
                GROUP BY `client_orders`.`id`
            ORDER BY 
                `client_orders`.`id` DESC', [$id]);
    }

    /**
     * @param $post
     */
    public static function order_remove($post)
    {
        $sql = 'DELETE FROM `client_orders` WHERE `order_id` = ? AND `client_id` = ?';
        R::exec($sql, [$post->order, $post->client]);
        response(200, 'Замовлення вдало видалено!');
    }

    /**
     * @param $data
     * @return array
     */
    public static function search_order($data)
    {
        $sql = '';
        $and = ' AND ';

        if (isset($data->id)) {
            $part = '`id` LIKE \'' . $data->id . '%\'';
            $sql .= $sql == '' ? $part : $and . $part;
        }

        if (isset($data->name)) {
            $part = '`fio` LIKE \'' . $data->name . '%\'';
            $sql .= $sql == '' ? $part : $and . $part;
        }
        if (isset($data->phone)) {
            $part = '`phone` LIKE \'' . $data->phone . '%\'';
            $sql .= $sql == '' ? $part : $and . $part;
        }
        if (isset($data->date)) {
            $part = 'DATE(`date`) = \'' . $data->date . '\'';
            $sql .= $sql == '' ? $part : $and . $part;
        }

        $sql .= ' LIMIT 10';

        return R::findAll('orders', $sql);
    }

    /**
     * @param $id
     * @return array
     */
    public static function getOrdersByClient($id)
    {
        return R::getAll('SELECT `order_id` FROM `client_orders` WHERE `client_id` = ?', [$id]);
    }

    public static function save_orders($data)
    {
        foreach ($data->orders as $k => $v) {
            $c = R::xdispense('client_orders');
            $c->client_id = $data->client;
            $c->order_id = $v;
            R::store($c);
        }
    }

    /**
     * @param $name
     * @return array
     */
    public static function search_clients($name)
    {
        return R::findAll('clients', '`name` LIKE ?', ["%$name%"]);
    }

    public static function getRecommendedOrders($client_id)
    {
        $client = Clients::getOne($client_id);
        $added = R::findAll('client_orders', '`client_id` = ?', [$client_id]);

        $temp = [];
        foreach ($added as $item) $temp[] = $item->order_id;

        $not = implode(',', $temp);
        $not = $not == '' ? '' : "AND `id` NOT IN($not)";

        return R::findAll('orders', "`phone` = ? $not ORDER BY `id` DESC LIMIT 10", [$client->phone]);
    }

    public static function delete($parameters, $table = false)
    {
        R::exec("DELETE FROM `client_orders` WHERE `client_id` = ?", [$parameters]);

        parent::delete($parameters, $table);
    }

    public static function bonuses()
    {
        $date = time() - 60 * 60 * 24 * 20;

        $orders = R::findAll('orders', 'YEAR(date) = ? AND MONTH(date) = ? AND status = 4', [date('Y', $date), date('m', $date)]);

        $temp = [];
        foreach ($orders as $order) {
            if (R::count('client_orders', 'order_id = ?', [$order->id])) {
                $client_id = (R::findOne('client_orders', 'order_id = ?', [$order->id]))->client_id;
                $client = R::load('clients', $client_id);
                if ($client->manager != 0) {
                    $temp[$order->id] = new \stdClass();
                    $temp[$order->id]->full_sum = $order->full_sum;
                    $temp[$order->id]->delivery_cost = $order->delivery_cost;
                    $temp[$order->id]->discount = $order->discount;
                    $temp[$order->id]->client_id = $client->id;
                    $temp[$order->id]->percentage = $client->percentage;
                    $temp[$order->id]->manager = $client->manager;
                }
            }
        }

        if (count($temp) > 0) {
            foreach ($temp as $id => $item) {
                if(R::count('bonuses', 'data = ? AND source = ?', [$id, 'event']))
                    continue;
                
                $sum = ($item->full_sum + $item->delivery_cost - $item->discount) / 100 * $item->percentage;

                if ($sum == 0) continue;

                $bean = R::dispense('bonuses');

                $bean->data = $id;
                $bean->type = 'bonus';
                $bean->sum = $sum;
                $bean->user_id = $item->manager;
                $bean->date = date('Y-m-d H:i:s');
                $bean->source = 'event';

                R::store($bean);

                if (!R::count('work_schedule_month', 'user = ? AND month = ? AND year = ?', [$item->manager, date('m'), date('Y')])){
                    Schedule::create_schedule(date('Y'), date('m'), $item->manager);
                }

                $wsm = R::findOne('work_schedule_month', 'user = ? AND month = ? AND year = ?', [$item->manager, date('m'), date('Y')]);
                $wsm->bonus += $sum;
                R::store($wsm);
            }
        }
    }
}