<?php

namespace Web\Model;
use RedBeanPHP\R;
use Web\App\Model;

class Manufacturers extends Model{

	const table = 'manufacturers';

    /**
     * Вернути всіх виробників
     */

	public static function all(){
		return get_object(R::getAll("
		    SELECT 
		        `manufacturers`.*,
		        `groupe_manufacturers`.`name` AS `group_name`
		    FROM 
		        `manufacturers`
		    LEFT JOIN `groupe_manufacturers` ON(`groupe_manufacturers`.`id` = `manufacturers`.`groupe`)
		    ORDER BY 
		        `manufacturers`.`id`
		    "));
	}

    /**
     * Вернути виробнків пр ІД для роздруковки
     */

	public static function printManufacturer($arr)
    {
        $ids = implode(',', (array)$arr);
        $res =  R::getAll("
            SELECT
                `manufacturers`.*,
                `groupe_manufacturers`.`name` AS `group_name`
            FROM
                `manufacturers`
                LEFT JOIN `groupe_manufacturers` ON(`groupe_manufacturers`.`id` = `manufacturers`.`groupe`)
            WHERE
                `manufacturers`.`id` IN($ids)
            ");
        return($res);
    }
}

?>