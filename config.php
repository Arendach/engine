<?php

/**
 * Connect to DataBase
 */
define('DB_DSN', 'mysql:host=localhost;dbname=user2327_baza;');
define('DB_USER', 'root');
define('DB_PASSWORD', '');
define('DB_HOST', 'localhost');
define('DB_NAME', 'user2327_baza');

/**
 * Template constants
 */
define('TEMPLATE_PATH', __DIR__ . '/web/template/');
define('SITE', $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['HTTP_HOST']);
define('MIN_PATH', SITE . '/public/min/');
define('ASSET_PATH', SITE . '/public/');
define('LOGS_FOLDER', __DIR__ . '/server/logs/');

// технічні роботи
define('UPDATE', false);

/**
 * Other
 */
define('START_LIFE', '2017-09-01 19:00:00');
define('DEBUG', true);
define('VERSION', '2.0.1');

if (isset($_GET['items']) && is_numeric($_GET['items']))
    define('ITEMS', $_GET['items']);
else
    define('ITEMS', 25);

define('AUTH_TIME', 3600);

define('SMS_API_KEY', 'ed9e034a348a3d1282bba036a0d324ade81720f6');
define('NEW_POST_KEY', '6817184ef3bfa2d67d1c266299fc10ff');

date_default_timezone_set('Europe/Kiev');

define('DATA_SUCCESS_CREATED', 'Дані успішно збережені!');
define('DATA_SUCCESS_UPDATED', 'Дані успішно оновлені!');
define('DATA_SUCCESS_DELETED', 'Дані успішно видалені!');