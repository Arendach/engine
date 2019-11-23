<?php

namespace Web\Middleware;

use Web\App\Middleware;
use Web\App\User;

class UpdateOnline extends Middleware
{
    public function handle()
    {
        $user = new User();
        $user->update_online();
    }
}