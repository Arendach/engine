<?php

namespace Web\Middleware;

use Web\App\Middleware;
use Web\App\User;

class UserInit extends Middleware
{
    public function handle()
    {
        $u = new User();
        $GLOBALS['user_info_init'] = $u->init();
    }
}