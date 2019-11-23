<?php

namespace Web\App;

class Log
{
    /**
     * @param $desc
     * @param string $type
     */
    public static function error($desc, $type = '')
    {
        $text = 'Дата: ' . date('Y-m-d H:i:s');
        $text .= PHP_EOL;
        $text .= 'Тип: ' . $type;
        $text .= PHP_EOL;
        $text .= 'Опис: ' . $desc;
        $text .= PHP_EOL . PHP_EOL;
        $file = fopen(LOGS_FOLDER . date('Y.m'), 'a');
        fwrite($file, $text);
        fclose($file);
    }

    /**
     * @param $data
     */
    public static function parse_ajax_log($data)
    {
        $post = get_object($data);
        if(isset($post->desc)) {
            $type = isset($post->type) ? $post->type : 'unknown_error';
            self::error($post->desc, $type);
        }
    }

}