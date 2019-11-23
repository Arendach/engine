<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

class Schedule extends Model
{
    const table = 'work_schedule_day';

//    public static function getAllUsersDistinct()
//    {
//        return R::getAll('
//            SELECT DISTINCT
//                `work_schedule_month`.`user` AS `id`,
//                `users`.`login`
//            FROM
//                `work_schedule_month`
//            LEFT JOIN `users` ON(`users`.`id` = `work_schedule_month`.`user`)
//            WHERE
//                `work_schedule_month`.`year` = ?
//            AND
//                `work_schedule_month`.`month` = ?
//            ',
//            [
//                get('year'),
//                get('month')
//            ]);
//    }

    public static function getUserWorkSchedule($year, $month, $user)
    {
        $data = R::getRow('
            SELECT
                `work_schedule_month`.*,
                `users`.`login`,
                `users`.`id` AS `user_id`
            FROM 
                `work_schedule_month`
            LEFT JOIN `users` ON(`users`.`id` = :user_id)
            WHERE 
                `work_schedule_month`.`year` = :year_id
            AND
                `work_schedule_month`.`month` = :month_id
            AND 
                `work_schedule_month`.`user` = :user_id
            LIMIT 1
            ',
            [
                ':year_id' => $year,
                ':month_id' => $month,
                ':user_id' => $user
            ]);

        if (empty($data)) {
            $data = static::check_date($year, $month, $user);
        }

        $data['schedules'] = R::getAll('
            SELECT 
                *
            FROM 
                `work_schedule_day`
            WHERE
                `user` = ?
            AND
                MONTH(`date`) = ?
            AND
                YEAR(`date`) = ?
            ',
            [
                $data['user_id'],
                $data['month'],
                $data['year']
            ]);

        return ($data);
    }

    public static function check_date($year, $month, $user)
    {
        if ($year == date('Y') && $month == date('m')) {
            $result = R::load('work_schedule_month', self::create_schedule($year, $month, $user));
            $result->login = user()->login;
            return $result;
        } else {
            redirect(route('404'));
        }
    }

    public static function create_schedule($year, $month, $user)
    {
        $bean = R::xdispense('work_schedule_month');
        $bean->price_month = user()->rate;
        $bean->for_car = 0;
        $bean->bonus = 0;
        $bean->user = $user;
        $bean->year = $year;
        $bean->month = $month;
        $bean->date = date('Y-m-d h:i:s');
        $bean->fine = 0;
        $bean->coefficient = 1;

        return R::store($bean);
    }

    public static function findMonth($data)
    {
        return R::findOne('work_schedule_month', '`user` = ? AND `month` = ? AND `year` = ?', [
            $data->user,
            $data->month,
            $data->year
        ]);
    }

    public static function get_bonuses($year, $month, $user)
    {
        $sql = 'YEAR(`date`) = ? AND MONTH(`date`) = ? AND `user_id` = ?';
        $binds = [$year, $month, $user];
        return R::findAll('bonuses', $sql, $binds);
    }

    public static function getScheduleMonthByUser($user)
    {
        $result = R::findAll('work_schedule_month', '`user` = ? ORDER BY `year` DESC', [$user]);

        $temp = [];

        foreach ($result as $item) {
            $temp[$item->year][$item->month] = $item;
        }

        return $temp;
    }

    public static function getPayouts($year, $month, $user)
    {
        return R::findAll('payouts', '`year` = ? AND `month` = ? AND `user` = ?', [
            $year, $month, $user
        ]);
    }

    public static function getPayoutsSum($year, $month, $user_id)
    {
        $sql = "SELECT SUM(`sum`) as `sum` FROM `payouts` WHERE `year` = ? AND `month` = ? AND `user` = ?";
        $result = R::getRow($sql, [$year, $month, $user_id]);
        return $result['sum'];
    }

    public static function getDistinctUsers()
    {
        return R::getAll('SELECT DISTINCT
                `work_schedule_month`.`user` AS `id`,
                `users`.`login`
            FROM
                `work_schedule_month`
            LEFT JOIN `users` ON(`users`.`id` = `work_schedule_month`.`user`)');
    }

    public static function createBonus($post)
    {
        $bean = R::findOne('work_schedule_month', '`year` = ? AND `month` = ? AND `user` = ?', [
            $post->year,
            $post->month,
            $post->user
        ]);

        $bean->bonus += $post->sum;

        R::store($bean);

        $bean = R::dispense('bonuses');

        $bean->data = '';
        $bean->type = 'bonus';
        $bean->sum = $post->sum;
        $bean->user_id = $post->user;
        
        $bean->date = 
            (date('Y') == $post->year && date('m') == $post->month) 
            ? date('Y-m-d H:i:s')
            : date('Y-m-t', strtotime($post->year . '-' . month_valid($post->month) . '-01')) . ' 23:59:59';
        
        $bean->source = 'other';

        R::store($bean);
    }

    public static function updateBonus($post)
    {
        $item = R::load('bonuses', $post->id);
        $bean = R::findOne('work_schedule_month', '`year` = ? AND `month` = ? AND `user` = ?', [
            $post->year,
            $post->month,
            $post->user
        ]);

        $bean->bonus = ($bean->bonus - $item->sum) + $post->sum;
        $item->sum = $post->sum;

        R::store($bean);
        R::store($item);
    }
}
