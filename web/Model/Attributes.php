<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

class Attributes extends Model
{
    const table = 'attributes';

    public static function search($name){
        return R::find(self::table, 'name LIKE :name', ['name' => '%'.$name.'%']);
    }
}