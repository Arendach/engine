<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

class Category extends Model
{
    const table = 'categories';
    const parent = 'parent';

    /**
     * @return array
     */
    public static function getMain()
    {
        return R::findAll('categories', '`parent` = \'0\'');
    }

    /**
     * @param $id
     * @param bool $table
     * @return array
     */
    public static function getOne($id, $table = false)
    {
        return R::getRow('
            SELECT 
                `categories`.*,
                `c`.`name` AS `parent_name`
            FROM 
                `categories`
            LEFT JOIN `categories` AS `c` ON (`c`.`id` = `categories`.`parent`) 
            WHERE 
                `categories`.`id` = ' . $id);
    }

    /**
     * @param $id
     */
    public static function deleteOne($id)
    {
        try {
            R::exec('DELETE FROM `categories` WHERE `id` = ' . $id);
            R::exec('DELETE FROM `categories` WHERE `parent` = ' . $id);
            response(200, 'Виконано! Категорію вдало видалено!');
        } catch (\Exception $err) {
            response(500, 'Помилка! Категорію не видалено!');
        }
    }

    /**
     * @return bool|string
     */
    public static function getCategories()
    {
        $rs = R::findAll('categories');

        if (my_count($rs) == 0)
            return false;

        foreach ($rs as $row) {
            if (empty($arr_cat[$row['parent']])) {
                $arr_cat[$row['parent']] = array();
            }
            $arr_cat[$row['parent']][] = $row;
        }
        $str = Category::getStings(Category::create_tree($arr_cat, ['id' => 'id', 'name' => 'name', 'service_code' => 'service_code'], 0), '');

        return $str;
    }

    /**
     * @param $arr
     * @param array $fields
     * @param int $parent_id
     * @param int $level
     * @return string
     */
    public static function create_tree($arr, $fields = [], $parent_id = 0, $level = 0)
    {
        if (empty($arr[$parent_id])) return '';
        $level++;
        for ($i = 0; $i < count($arr[$parent_id]); $i++) {
            foreach ($fields as $k => $v) $strs[$i][$k] = $arr[$parent_id][$i][$v];
            $strs[$i]['level'] = $level;
            $strs[$i]['childrens'] = Category::create_tree($arr, $fields, $arr[$parent_id][$i]['id'], $level);
        }
        return $strs;
    }

    /**
     * @param $arr
     * @param $str
     * @param string $parent
     * @return string
     */
    public static function getStings($arr, $str, $parent = '')
    {
        if (is_array($arr)) {
            foreach ($arr as $category) {
                $str .= '<tr>
	                  <td>' . $parent . $category['name'] . '</td>
	                  <td>' . $category['service_code'] . '</td>
	                  <td style="width: 69px;"> 
                      <button class="btn btn-primary btn-xs" data-action="update_form" data-uri="' . uri('category') . '" data-post="' . params(['id' => $category['id']]) . '" data-type="get_form" title="Редагувати"><span class="glyphicon glyphicon-pencil"></span></button>
                      <button class="btn btn-danger btn-xs" data-type="delete" data-action="delete" data-uri="'.uri('category').'" data-id="' . $category['id'] . '" title="Видалити"><span class="glyphicon glyphicon-remove"></span></button></td>
                  
	                </tr>';
                if (isset($category['childrens']) and is_array($category['childrens']))
                    $str = Category::getStings($category['childrens'], $str, $parent . "	&ensp;	&ensp;");
            }
            return $str;
        } else {
            return '';
        }
    }

}

?>