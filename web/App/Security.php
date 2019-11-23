<?php

namespace Web\App;

class Security
{
    /**
     * @param int $length
     * @return string
     */
    public static function generateCode($length = 6)
    {
        $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPRQSTUVWXYZ0123456789";
        $code = "";
        $chars_length = strlen($chars) - 1;
        while (strlen($code) < $length)
            $code .= $chars[mt_rand(0, $chars_length)];
        return $code;
    }


    /**
     * @param $str
     * @return string
     */
    public static function p_hash($str)
    {
        return md5(md5($str));
    }

    /**
     * @return string
     */
    public static function hash()
    {
        return self::p_hash(self::generateCode());
    }
}