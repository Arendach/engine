<?php

namespace Web\Middleware;

use Web\App\Model;

class UsersListInit
{
    public function handle()
    {
        $users = Model::finfAll('users', 'archive = 0');

        $new = [];

        foreach ($users as $user) {
            $new[$user->id] = $user;
        }

        $GLOBALS['app']->users = $new;
    }
}