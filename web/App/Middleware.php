<?php

namespace Web\App;

class Middleware extends Entity
{
    /**
     * @param bool $params
     */
    public function redirect_access_denied($params = false)
    {
        if ($params == false) {
            $this->redirect('', 'access_denied');
        } else {
            $p = '';
            foreach ($params as $item)
                $p .= 'access[]=' . $item . '&';
            $this->redirect('', 'access_denied');
        }
    }

    /**
     * @param bool $params
     */
    public function response_access_denied($params = false)
    {
        response(403, 'У вас немає доступу для даної дії');
    }

    /**
     * @param $url
     * @param bool $config_location
     */
    public function redirect($url, $config_location = false)
    {
        if ($config_location === false)
            header("Location: " . $url);
        else
            header("Location: " . Config::location($config_location) . '?' . $url);
    }
}