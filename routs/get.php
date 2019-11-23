<?php

$route->get('/', ['as' => 'index', 'uses' => 'IndexController@index']);

$route->get('/reset_password', ['as' => 'reset', 'uses' => 'UserController@get_reset_password'], ['exception' => true]);