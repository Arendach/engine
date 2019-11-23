<?php

namespace Web\Model;

use RedBeanPHP\R;
use Web\App\Model AS Model;

class Storage extends Model
{
    const table = 'storage';

    public static function getIds()
    {
        $ids = R::findAll('ids_storage');


        $temp = [];
        foreach ($ids as $id)
            if (!isset($temp[trim($id->level1)][$id->level2]))
                $temp[trim($id->level1)][] = $id->level2;

        return $temp;
    }

    public static function getIdsToEdit()
    {
        $ids = R::findAll('ids_storage');


        $temp = [];
        foreach ($ids as $id)
            if (!isset($temp[trim($id->level1)][$id->level2]))
                $temp[trim($id->level1)][] = ['value' => $id->level2, 'id' => $id->id];

        return object($temp);
    }
}
