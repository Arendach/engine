<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

class Notification extends Model
{
    const table = 'notification';

    public static function getNotification()
    {
        return R::findAll('notification', '`user` = ? AND `see` = 0', [user()->id]);
    }
}