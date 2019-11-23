<?php

namespace Web\Middleware;

use Web\Model\OrderSettings;
use Web\App\Model;
use Web\App\User;

class AppInit
{
    public function handle()
    {
        app_set('settings',  Model::getSettings());

        app_set('course', OrderSettings::getCourse());

        if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['section']))
        app_set('section', $_GET['section']);

        if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['action']))
        app_set('action', $_POST['action']);

        $u = new User();
        app_set('me', $u->init());
    }
}