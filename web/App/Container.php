<?php

namespace Web\App;

class Container
{
    private static $objects = [];

    /**
     * @var array
     */
    private static $data = [];

    /**
     * @param string $key
     * @param $value
     */
    public static function set(string $key, $value)
    {
        static::$data[$key] = $value;
    }

    /**
     * @param string $key
     * @param null $default
     * @return mixed|null
     */
    public static function get(string $key, $default = null)
    {
        return isset(static::$data[$key]) ? static::$data[$key] : $default;
    }

    /**
     * @return array
     */
    public static function getContainer(): array
    {
        return static::$data;
    }

    /**
     * @param string $abstract
     * @return mixed
     */
    public function getClassObject(string $abstract)
    {
        if (!isset(static::$objects[$abstract]))
            static::$objects[$abstract] = new $abstract;

        return static::$objects[$abstract];
    }
}