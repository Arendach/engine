<?php

namespace Web\App\Router;

class MiddlewareList
{
    /**
     * @var array
     */
    public $named = [
        'users_list_init' => \Web\Middleware\UsersListInit::class
    ];

    /**
     * @var array
     */
    public $autoload = [
        \Web\Middleware\Authentication::class,
        \Web\Middleware\AppInit::class,
        \Web\Middleware\UpdateOnline::class,
    ];
}