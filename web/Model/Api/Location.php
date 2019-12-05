<?php

namespace Web\Model\Api;

use RedBeanPHP\R;

class Location
{
    public static function search_village($name)
    {
        $result = R::getAll('
            SELECT 
                `located_village`.`village`,
                `located_area`.`area` AS `area`,
                `located_region`.`region` AS `region`
            FROM 
                `located_village`
            LEFT JOIN `located_area` ON(`located_area`.`id` = `located_village`.`area`)
            LEFT JOIN `located_region` ON(`located_region`.`id` = `located_village`.`region`)
            WHERE 
                `located_village`.`village` LIKE ? 
            GROUP BY 
                `located_village`.`id`
            LIMIT 100',
            [$name . '%']);

        if (my_count($result) > 0) {
            $str = '';
            foreach ($result as $item)
                $str .= '<option value="' . $item['village'] . '">' . $item['village'] . ' ( ' . $item['area'] . ' р-н, ' . $item['region'] . ' обл. ) </option>';
            return $str;
        } else {
            return false;
        }
    }

    /**
     * @param $street
     * @param $city
     * @return array
     */
    public static function searchStreets($street, $city)
    {
        $streets = R::findAll('streets', "`city` = ? AND `name` LIKE ? LIMIT 10", [$city, '%' . $street . '%']);

        $result = [];
        foreach ($streets as $street)
           $result[] =  "$street->street_type $street->name ($street->district)";

        return $result;
    }
}