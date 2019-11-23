<?php

namespace Web\App;

class TemplateComponents
{
    /**
     * Путь к css файлам компонента по умолчанию
     */
    const css_path = ASSET_PATH . 'css/components/';

    /**
     * Путь к javascript файлам компонента по умолчанию
     */
    const js_path = ASSET_PATH . 'js/components/';

    /**
     * @Component sweet_alert
     * Красиві алерти
     */
    public function sweet_alert()
    {
        return [
            'js' => $this->js('sweet_alert', ['sweet_alert', 'handlers']),
            'css' => $this->css('sweet_alert', ['style', 'facebook'])
        ];
    }

    /**
     * @Component sweet_alert
     * Красиві алерти
     */
    public function inputmask()
    {
        return [
            'js' => $this->js('inputmask', ['inputmask', 'jquery.inputmask'])
        ];
    }

    /**
     * @Component modal
     * Модальне вікно
     */
    public function modal()
    {
        return [
            'js' => $this->js('modal', ['modal']),
            'css' => $this->css('modal', ['modal'])
        ];
    }

    /**
     * @Component jquery
     *  jQuery-плагіни
     */
    public function jquery()
    {
        return [
            'js' => $this->js('jquery', ['widget', 'fileupload', 'iframe-transport', 'knob']),
        ];
    }

    /**
     * @Component bootstrap
     * bootstrap.css, bootstrap-theme.css, bootstrap.js
     */
    public function bootstrap()
    {
        return [
            'css' => $this->css('bootstrap', ['bootstrap', 'bootstrap-theme', 'buttons']),
            'js' => $this->js('bootstrap', 'bootstrap.min')
        ];
    }

    /**
     * @Component font_awesome
     * Шрифтові іконки font_awesome
     */
    public function font_awesome()
    {
        return [
            'css' => static::css('font_awesome', 'font-awesome')
        ];
    }

    /**
     * @Component summer_note
     * Блокнот summer_note, мова українська
     */
    public function summer_note()
    {
        return [
            'js' => $this->js('summer_note', ['summer_note', 'ua']),
            'css' => $this->css('summer_note', ['summer_note'])
        ];
    }

    /**
     * @Component color_picker
     */
    public function color_picker()
    {
        return [
            'js' => $this->js('color_picker', ['color_picker']),
            'css' => $this->css('color_picker', ['color_picker'])
        ];
    }

    /**
     * @Component ajax_upload
     * Асинхронне вивантаження файлів на сервер
     */
    public function ajax_upload()
    {
        return [
            'js' => $this->js('ajax_upload', ['ajax_upload'])
        ];
    }

    /**
     * @Component ajax_upload
     * Асинхронне вивантаження файлів на сервер
     */
    public function breadcrumbs()
    {
        return [
            'css' => $this->css('breadcrumbs', ['breadcrumbs']),
            'js' => $this->js('breadcrumbs', ['breadcrumbs'])
        ];
    }

    /**
     * @return array
     */
    public function calendar()
    {
        return [
            'css' => $this->css('calendar', ['style'])
        ];
    }

    /**
     * Функция формирует строку пути или массив путей к css файлам компонента
     */
    private function css($component, $files)
    {
        if (my_count($files) > 0) {
            $paths = [];
            foreach ($files as $file)
                $paths[] = self::css_path . $component . '/' . $file . '.css' . parameters(['v' => VERSION]);
            $result = $paths;
        } else {
            $result = self::css_path . $component . '/' . $files . '.css' . parameters(['v' => VERSION]);
        }

        return $this->link_to_css($result);
    }

    /**
     * Функция формирует строку пути или массив путей к javascript файлам компонента
     */
    private function js($component, $files)
    {
        if (my_count($files) > 0) {
            $paths = [];
            foreach ($files as $file)
                $paths[] = self::js_path . $component . '/' . $file . '.js' . parameters(['v' => VERSION]);
            $result = $paths;
        } else {
            $result = self::js_path . $component . '/' . $files . '.js' . parameters(['v' => VERSION]);
        }
        return $this->link_to_js($result);
    }

    /**
     * Функція повертає html-код css файлів || <link rel="stylesheet" href="$url">
     */
    private function link_to_css($array)
    {
        $result = '';
        if (my_count($array) > 0) {
            foreach ($array as $item)
                $result .= "<link rel=\"stylesheet\" href=\"{$item}\">" . PHP_EOL;
        } elseif (is_string($array)) {
            $result = "<link rel=\"stylesheet\" href=\"{$array}\">" . PHP_EOL;
        } else {
            $result = '';
        }
        return $result;
    }

    /**
     * Функція повертає html-код js файлів || <script type="text/javascript" src="$url">
     */
    private function link_to_js($array)
    {
        $result = '';
        if (my_count($array) > 0) {
            foreach ($array as $item)
                $result .= "<script type=\"text/javascript\" src=\"{$item}\"></script>" . PHP_EOL;
        } elseif (is_string($array)) {
            $result = "<script type=\"text/javascript\" src=\"{$array}\"></script>" . PHP_EOL;
        } else {
            $result = '';
        }
        return $result;
    }
}
