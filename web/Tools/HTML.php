<?php

namespace Web\Tools;

class HTML
{

    /**
     * @param $key
     * @return string
     */
    public static function order_by($key)
    {
        if (get('order_field') == $key) {
            return get('order_by') == 'desc' ? 'asc' : 'desc';
        } else {
            return 'asc';
        }
    }

    /**
     * @param $key
     * @return string
     */
    public static function order_by_sym($key)
    {
        if (get('order_field') == $key) {
            $c = get("order_by") == "desc" ? "down" : "up";
            return "<span class=\"fa fa-caret-$c\"></span>";
        }
        return '';
    }


    /**
     * @param $url
     * @param $desc
     * @param bool|array $parameters
     * @return string
     */
    public static function link($url, $desc, $parameters = false)
    {
        if (!$parameters) {
            return "<a href='$url'>$desc</a>";
        } else {
            return "<a href='" . $url . parameters($parameters) . "'>$desc</a>";
        }
    }
}