<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

class OrderSettings extends Model
{
    public static function update_currency($post)
    {
        foreach ($post as $id => $currency) {
            $bean = R::load('course', $id);
            $bean->currency = $currency;
            R::store($bean);
        }

        response(200, 'Дані вдало оновлені!');
    }

    public static function getCourse()
    {
        $result = R::findOne('course', '`code` = ?', [setting('currency')]);
        return $result['currency'];
    }
}
