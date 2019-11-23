<?php

use \Web\App\Router\StrongRouter;
use Web\App\Router\SimpleRouter;
use Web\App\Router\ApiRouter;

define('START',  microtime(1));

ini_set("display_errors", 1);
ini_set('session.save_path', $_SERVER['DOCUMENT_ROOT'] . '/server/sessions/');
error_reporting(E_ALL);
session_start();

define('ROOT', __DIR__);

$app = (object)[];

include_once './vendor/autoload.php';

$parse = 'parse_' . strtolower($_SERVER['REQUEST_METHOD']);
$route = new StrongRouter();
include ROOT . '/routs/' . strtolower($_SERVER['REQUEST_METHOD']) . '.php';
new SimpleRouter();
new ApiRouter();

$route->$parse();
