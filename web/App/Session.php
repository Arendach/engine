<?php

namespace Web\App;

class Session
{
    /**
     * @var bool
     */
    private static $single = false;

    /**
     * @return bool
     */
    public static function start()
    {
        if(!headers_sent() && !session_id() && self::$single === false){
            if(session_start()){
                session_regenerate_id();
                self::$single = true;
                return true; 
            }
        }
        return false; 
    }

    /**
     * @param $key
     * @param $value
     */
    public static function set($key, $value)
    {
        $_SESSION[$key] = $value; 
    }

    /**
     * @param $key
     * @return bool
     */
    public static function has($key)
    {
        return (bool)(isset($_SESSION[$key])) ? $_SESSION[$key] : false; 
    }

    /**
     * @param $key
     * @return bool
     */
    public static function get($key)
    {
        return (isset($_SESSION[$key])) ? $_SESSION[$key] : false; 
    }

    /**
     * @param $key
     * @return bool
     */
    public static function del($key)
    {
        if(isset($_SESSION[$key])){
            unset($_SESSION[$key]);
            return false; 
        }
    }

    /**
     * session_destroy()
     */
    public static function destroy()
    {
        if( self::$single === true || isset($_SESSION)){
            session_destroy();
        }   
    }

    /**
     * @param $key
     * @param $value
     * @param int $int
     */
    public static function setCookie($key, $value, $int = 0){
        setcookie($key, $value, time() + $int);
    }

    /**
     * @param $key
     * @return bool
     */
    public static function hasCookie($key){
        return (bool)(isset($_COOKIE[$key])) ? $_COOKIE[$key] : false; 
    }

    /**
     * @param $key
     * @return bool
     */
    public static function getCookie($key){
        return (isset($_COOKIE[$key])) ? $_COOKIE[$key] : false; 
    }

    /**
     * @param $key
     * @return bool
     */
    public static function unsetCookie($key){
        if(isset($_COOKIE[$key])){
            unset($_COOKIE[$key]);
            return false; 
        }
    }

}