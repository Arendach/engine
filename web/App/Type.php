<?php

namespace Web\App;

class Type
{
    /**
     * @param $type
     * @param $param
     * @return array|bool|float|int|\stdClass|string
     */
    public static function to($type, $param)
    {
        if ($type == 'int' || $type == 'integer')
            return static::toInteger($param);
        elseif ($type == 'bool' || $type == 'boolean')
            return static::toBoolean($param);
        elseif ($type == 'array')
            return static::toArray($param);
        elseif ($type == 'string')
            return static::toString($param);
        elseif ($type == 'float')
            return static::toFloat($param);
        elseif ($type == 'object')
            return static::toObject($param);

        return $param;
    }

    /**
     * @param $param
     * @return int
     */
    public static function toInteger($param): int
    {
        if (is_integer($param)) return $param;

        if (is_integer($param) || is_float($param) || is_numeric($param))
            return (int)$param;

        return 0;
    }

    /**
     * @param $param
     * @return array
     */
    public static function toArray($param): array
    {
        if (is_array($param)) return $param;

        if (is_object($param)) return (array)$param;

        return [];
    }

    /**
     * @param $param
     * @return float
     */
    public static function toFloat($param): float
    {
        if (is_integer($param) || is_float($param) || is_numeric($param))
            return (float)$param;

        return 0;
    }

    /**
     * @param $param
     * @return bool
     */
    public static function toBoolean($param): bool
    {
        if (is_bool($param)) return $param;

        if ($param === 1 || $param === '1' || $param === 'true')
            return true;

        if ($param === 0 || $param === '0' || $param === 'false')
            return false;

        return false;
    }

    /**
     * @param $param
     * @return string
     */
    public static function toString($param): string
    {
        if (is_string($param)) return $param;

        if (is_integer($param) || is_float($param))
            return (string)$param;

        return '';
    }

    /**
     * @param $param
     * @return \stdClass
     */
    public static function toObject($param): \stdClass
    {
        if (is_object($param)) return $param;

        if (is_array($param)) return (object)$param;

        return new \stdClass();
    }

}