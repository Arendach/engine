<?php

namespace Web\Model;


use Web\App\Model;
use RedBeanPHP\R;

class Vacation extends Model
{
    const table = 'vacations';

    /**
     * @return array
     */
    public static function getThisYear()
    {
        $result = R::getAll('SELECT * FROM vacations WHERE YEAR(`date`) = ?', [date('Y')]);
        $temp = [];
        foreach ($result as $item){
            $temp[$item['date']][] = $item;
        }

        return $temp;
    }
}