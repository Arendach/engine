<?php
/**
 * API
 */
$route->post('/api/search_village', 'APIController@search_village');
$route->post('/api/get_city', 'APIController@get_city');
$route->post('/api/search_streets', 'APIController@search_streets');
$route->post('/api/search_coupon', 'APIController@search_coupon');
$route->post('/log', 'LogController@write');
$route->post('/api/search_warehouses', 'APIController@search_warehouses');
$route->post('/api/clean', 'APIController@clean');

/**
 * Products
 */
$route->post('/products/upload_image', 'ProductController@upload_image');
$route->post('/products/update', 'ProductController@post_update');
$route->post('/products/new_upload_image', 'ProductController@new_upload_image');
$route->post('/delete_temp_file', 'ProductController@delete_temp_file');

/**
 * Автентифікація
 */
$route->post('/login', 'UserController@post_login', ['exception' => true]);
$route->post('/reset_password', 'UserController@post_reset_password', ['exception' => true]);


$route->post('/dialog/send_file', 'DialogController@action_send_file');
$route->post('/dialog/send_photo', 'DialogController@action_send_photo');