<?php

namespace Web\Model;

use RedBeanPHP\R;
use Web\App\Paginator;
use Web\App\Model;
use Web\Tools\Categories;

class Coupon extends Model
{
    const table = 'coupons';

    /**
     * @param $id
     * @return array
     */
    public static function get_accumulation($id)
    {
        return R::findAll('coupon_accumulation', '`coupon_id` = ?', [$id]);
    }

    /**
     * @param $id
     * @param bool $table
     */
    public static function delete($id, $table = false)
    {
        if (my_count($id) > 0) {
            foreach ($id as $item) {
                R::exec('DELETE FROM `coupons` WHERE `id` = ?', [$item]);
                R::exec('DELETE FROM `coupon_accumulation` WHERE `coupon_id` = ?', [$item]);
            }
        } else {
            R::exec('DELETE FROM `coupons` WHERE `id` = ?', [$id]);
            R::exec('DELETE FROM `coupon_accumulation` WHERE `coupon_id` = ?', [$id]);
        }
        response(200, 'Всі дані збережено!');
    }


    /**
     * @return bool|string
     */
    public static function getCategories()
    {
        return Categories::get();
    }

    /**
     * @param $data
     * @param $id
     */
    public static function update_cumulative($data, $id)
    {
        R::exec('DELETE FROM `coupon_accumulation` WHERE `coupon_id` = ?', [$id]);
        $bean = R::load('coupons', $id);
        $arr = ['code', 'discount'];
        foreach ($arr as $item)
            $bean->$item = $data->$item;
        R::store($bean);

        $arr = ['sum', 'operator', 'discount', 'type'];
        foreach ($data->cumulative as $item) {
            $bean = R::xdispense('coupon_accumulation');
            foreach ($arr as $v)
                $bean->$v = $item->$v;
            $bean->coupon_id = $id;
            R::store($bean);
        }

        response(200, 'Дані успішно оновлено!');
    }

    /**
     * @param $post
     * @param $cod
     */
    public static function insert_to_bd($post, $cod)
    {
        $c = '';
        for ($i2 = 0; $i2 < 6 - strlen($cod); $i2++) $c .= '0';
        $code = $c . $cod;
        $bean = R::dispense('coupons');
        $bean->type = $post->type_coupon;
        $bean->discount = $post->discount;
        $bean->code = $code;

        $id = R::store($bean);

        foreach (get_object($post->cumulative) as $item) {
            $bean = R::xdispense('coupon_accumulation');
            $bean->sum = $item->sum;
            $bean->operator = $item->operator;
            $bean->discount = $item->discount;
            $bean->type = $item->type;
            $bean->coupon_id = $id;
            R::store($bean);
        }
    }

    /**
     * @param $post
     */
    public static function insert_cumulative($post)
    {
        if (preg_match('/^([0-9]+)-([0-9]+)$/', $post->code, $matches)) {
            $with = $matches[1];
            $to = $matches[2];
            for ($i = $with; $i <= $to; $i++) {
                static::insert_to_bd($post, $i);
            }
        } else {
            static::insert_to_bd($post, $post->code);
        }

        response(200, 'Всі дані збережено!');
    }

    /**
     * @param $post
     * @param bool $table
     */
    public static function insert($post,$table = false)
    {
        if (preg_match('/^([0-9]+)-([0-9]+)$/', $post->code, $matches)) {
            $with = $matches[1];
            $to = $matches[2];
            for ($i = $with; $i <= $to; $i++) {
                static::to_db($post, $i);
            }
        } else {
            static::to_db($post, $post->code);
        }
        response(200, 'Всі дані збережено!');

    }

    /**
     * @param $post
     * @param $cod
     */
    public static function to_db($post, $cod)
    {
        $c = '';
        for ($i2 = 0; $i2 < 6 - strlen($cod); $i2++) $c .= '0';
        $code = $c . $cod;
        $bean = R::dispense('coupons');

        $bean->type = $post->type_coupon;
        $bean->discount = $post->discount;
        $bean->code = $code;

        R::store($bean);
    }

    /**
     * @param $str
     * @return array
     */
    public static function search_coupon($str)
    {
        return R::findAll('coupons', 'WHERE `code` LIKE \'' . $str . '%\' LIMIT 5');
    }

    /**
     * @return array
     */
    public static  function getItems()
    {
        Paginator::items(200);
        $start_query = (get('page') - 1) * 200;

        return [
            'data' => get_object(R::getAll("SELECT * FROM coupons LIMIT $start_query, 200")),
            'paginate' => Paginator::simple('coupons')
        ];
    }
}