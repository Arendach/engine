<?php

use Whoops\Handler\PrettyPageHandler;
use Whoops\Handler\JsonResponseHandler;
use Whoops\Run as Whoops;
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\View\Factory;
use Illuminate\View\FileViewFinder;
use Illuminate\Pagination\Paginator;
use Illuminate\View\Engines\PhpEngine;
use Illuminate\View\Engines\EngineResolver;
use Illuminate\Filesystem\Filesystem;
use Illuminate\Events\Dispatcher;
use Illuminate\Container\Container;
use DebugBar\StandardDebugBar;

(new Whoops)->pushHandler($_SERVER['REQUEST_METHOD'] == 'GET' ? new PrettyPageHandler : new JsonResponseHandler)->register();

$events = new Dispatcher(new Container);

$pathsToTemplates = [__DIR__ . '/web/template'];
$filesystem = new Filesystem;
$viewResolver = new EngineResolver;
$viewResolver->register('php', function () {
    return new PhpEngine;
});

$viewFinder = new FileViewFinder($filesystem, $pathsToTemplates);
$viewFactory = new Factory($viewResolver, $viewFinder, $events);

Paginator::viewFactoryResolver(function () use ($viewFactory) {
    return $viewFactory;
});
// Set up a current path resolver so the paginator can generate proper links
Paginator::currentPathResolver(function () {
    return isset($_SERVER['REQUEST_URI']) ? strtok($_SERVER['REQUEST_URI'], '?') : '/';
});
// Set up a current page resolver
Paginator::currentPageResolver(function ($pageName = 'page') {
    $page = isset($_REQUEST[$pageName]) ? $_REQUEST[$pageName] : 1;
    return $page;
});

Paginator::defaultView('parts.paginator');

$capsule = new Capsule;
$capsule->addConnection([
    'driver'    => 'mysql',
    'host'      => DB_HOST,
    'database'  => DB_NAME,
    'username'  => DB_USER,
    'password'  => DB_PASSWORD,
    'charset'   => 'utf8',
    'collation' => 'utf8_unicode_ci',
    'prefix'    => '',
]);
$capsule->setEventDispatcher($events);
$capsule->setAsGlobal();
$capsule->bootEloquent();

$debugbar = new StandardDebugBar();
$debugbarRenderer = $debugbar->getJavascriptRenderer();

app('bar', $debugbarRenderer);