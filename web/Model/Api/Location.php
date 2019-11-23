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
     * @param $city
     * @param $street
     * @return bool|string
     */
    public static function search_streets($street, $city)
    {
        $streets = R::findAll('streets', "`city` = ? AND `name` LIKE ? LIMIT 5", [$city, '%' . $street . '%']);
        if (my_count($streets) > 0) {
            $str = '';
            foreach ($streets as $k => $street)
                $str .= '<option>' . $street->street_type . ' ' . $street->name . ' (' . $street->district . ')</option>';
            return $str;
        } else {
            return false;
        }
    }
}