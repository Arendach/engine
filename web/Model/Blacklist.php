<?php

namespace Web\Model;

use RedBeanPHP\R;
use Web\App\Model;
use Web\App\NewPaginate;

class Blacklist extends Model
{
    public const table = 'blacklist';

    public static function getItems()
    {
        $p = (new NewPaginate('blacklist'))->get();

        return R::findAll('blacklist', $p->query_string);
    }
}