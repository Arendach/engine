<?php

namespace Web\Middleware;

use Web\App\Middleware;

class Logout extends Middleware
{
    public function handle()
    {
        $_SESSION = [];
        session_destroy();
        setcookie ('login', "", time() - 3600);
        setcookie ('password', "", time() - 3600);
        $this->redirect(uri('/'));
        exit;
    }
}