<?php

$route->get('/', ['as' => 'index', 'uses' => 'IndexController@index']);

$route->get('/login', ['as' => 'login', 'uses' => 'UserController@sectionLogin'], ['exception' => true]);

$route->get('/reset_password', ['as' => 'reset', 'uses' => 'UserController@get_reset_password'], ['exception' => true]);