<?php

use \Web\App\Router\StrongRouter;
use Web\App\Router\SimpleRouter;
use Web\App\Router\ApiRouter;
use Web\App\Router\ReflectionRouter;

define('START', microtime(1));
define('ROOT', __DIR__);

ini_set("display_errors", 1);
ini_set('session.save_path', ROOT . '/server/sessions/');
error_reporting(E_ALL);
session_start();

include_once './vendor/autoload.php';

include 'laravel.php';

new SimpleRouter();
new ReflectionRouter();

$parse = 'parse_' . strtolower($_SERVER['REQUEST_METHOD']);
$route = new StrongRouter();
include ROOT . '/routs/' . strtolower($_SERVER['REQUEST_METHOD']) . '.php';
new ApiRouter();

$route->$parse();


