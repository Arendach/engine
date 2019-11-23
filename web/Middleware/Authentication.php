<?php

namespace Web\Middleware;

use Web\App\Middleware;
use RedBeanPHP\R;

class Authentication extends Middleware
{
    /**
     * Обробник посередника
     * Провірка куків і оновлення сесії
     */
    public function handle()
    {
        if (isset($_COOKIE['session'])) {
            if (!R::count('users_session', '`session` = ?', [$_COOKIE['session']])) {
                $this->login_form();
            } else {
                $bean = R::findOne('users_session', '`session` = ?', [$_COOKIE['session']]);
                $bean->created = date('Y-m-d H:i:s');
                R::store($bean);

                setcookie('session', $_COOKIE['session'], time() + AUTH_TIME);
            }
        } else {
            $this->login_form();
        }
    }

    /**
     * Ящо користувач не авторизований
     */
    private function login_form()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'GET') {
            $this->display_login();
        } else {
            $this->response_not_authorized();
        }
    }
}