<?php

namespace Web\App;

use RedBeanPHP\R;

class Model
{
    const table = 'parent';
    const parent = 'parent';

    /**
     * @param $id
     * @param bool $table
     * @return \RedBeanPHP\OODBBean
     */
    public static function getOne($id, $table = false)
    {
        if (!$table)
            $table = static::table;

        return R::load($table, $id);
    }

    /**
     * @param bool $table
     * @return array
     */
    public static function getAll($table = false)
    {
        if (!$table)
            $table = static::table;

        return R::findAll($table);
    }

    /**
     * @param $data
     * @param $id
     * @param bool $table
     */
    public static function update($data, $id, $table = false)
    {
        try {
            if ($table === false)
                $table = static::table;
            $bean = R::load($table, $id);
            foreach ($data as $k => $v)
                $bean->$k = to_bd($v);
            R::store($bean);
        } catch (\Exception $err) {
            Log::error($err, 'update_error');
            response(500, 'Неможливо оновити елемент!');
        }
    }

    /**
     * @param $parameters
     * @param bool $table
     */
    public static function delete($parameters, $table = false)
    {
        try {
            if (!$table)
                $table = static::table;

            if (validator($parameters, 'array')) {
                foreach ($parameters as $id)
                    R::exec("DELETE FROM " . $table . " WHERE `id` = ?", [$id]);
            } elseif (validator($parameters, 'int')) {
                R::exec("DELETE FROM " . $table . " WHERE `id` = ?", [$parameters]);
            } else {
                response(400, 'Неправильні вхідні параметри!');
                exit;
            }
        } catch (\Exception $err) {
            Log::error('table: ' . $table . ', id or ids: ' . json_encode($parameters), 'delete_error');
            response(500, 'Помилка! Дані не видалено!');
        }
    }

    /**
     * @param $parameters
     * @param bool $table
     * @param bool $parent
     */
    public static function delete_parent($parameters, $table = false, $parent = false)
    {
        try {
            if (!$parent)
                $parent = self::parent;

            if (!$table)
                $table = static::table;

            if (validator($parameters, 'array')) {
                foreach ($parameters as $id) {
                    R::exec("DELETE FROM `$table` WHERE `id` = ?", [$id]);
                    R::exec("DELETE FROM `$table` WHERE `$parent` = ?", [$id]);
                }
            } elseif (validator($parameters, 'int')) {
                R::exec("DELETE FROM `$table` WHERE `id` = ?", [$parameters]);
                R::exec("DELETE FROM `$table` WHERE `$parent` = ? ", [$parameters]);
            } else {
                response(400, 'Неправильні вхідні параметри!');
                exit;
            }
        } catch (Exception $err) {
            Log::error('Помилка! Неможливо видалити елемент!', 'delete_error');
            response(500, 'Невідома помилка!');
        }
    }

    /**
     * @param $data
     * @param bool $table
     */
    public static function insert($data, $table = false)
    {
        try {
            if (!$table)
                $table = static::table;

            $bean = R::xdispense($table);
            foreach ($data as $k => $v)
                $bean->$k = to_bd($v);

            return R::store($bean);
        } catch (\Exception $err) {
            response(500, 'Неможливо записати інформацію в базу даних!');
        }
    }

    /**
     * @param $table
     * @param string $sql
     * @param array $binds
     * @return int
     */
    public static function count($table, $sql = '', $binds = [])
    {
        return R::count($table, $sql, $binds);
    }

    /**
     * @param $id
     * @param bool $table
     * @return bool
     */
    public static function exists($id, $table = false)
    {
        if ($table != false) {
            return (boolean)R::count($table, '`id` = ?', [$id]);
        } else {
            return (boolean)R::count(self::table, '`id` = ?', [$id]);
        }
    }

    /**
     * @param $ids
     * @param bool|string $table
     * @return array
     */
    public static function findByIDS($ids, $table = false)
    {
        $table = !$table ? self::table : $table;
        return R::loadAll($table, $ids);
    }

    /**
     * @param $sql
     * @param array $binds
     * @return bool
     */
    public static function exec($sql, $binds = [])
    {
        return R::exec($sql, $binds) ? true : false;
    }

    /**
     * @return array
     */
    public static function getSettings()
    {
        $items = R::getAll('SELECT * FROM `settings`');
        $assoc_array = [];
        foreach ($items as $item) {
            $assoc_array[$item['name']] = $item['value'];
        }
        return $assoc_array;
    }

    /**
     * @param bool $table
     * @param string $sql
     * @param array $binds
     * @return array
     */
    public static function findAll($table = false, $sql = '', $binds = [])
    {
        $table = !$table ? self::table : $table;

        return R::findAll($table, $sql, $binds);
    }

    /**
     * @param string $table
     * @return array
     */
    public static function first($table = '')
    {
        $table = $table == '' ? self::table : $table;

        return R::find($table);
    }

    /**
     * @param string $table
     * @return array
     */
    public static function last($table = '')
    {
        $table = $table == '' ? self::table : $table;

        return R::find($table, 'ORDER BY id DESC');
    }

    /**
     * @param $table
     * @param string $sort
     * @param string $order
     * @param null $items
     * @return array
     */
    public static function getWithPaginate($table, $sort = 'DESC', $order = 'id', $items = null)
    {
        if (is_null($items)) $items = ITEMS;

        $p = (new NewPaginate($table))
            ->setOrderBy($order, $sort)
            ->setItems($items)
            ->get();

        return R::findAll($table, $p->query_string);
    }
}

?>