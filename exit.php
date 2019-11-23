<?php

include_once './vendor/autoload.php';

use RedBeanPHP\R;

R::exec('DELETE FROM `users_session` WHERE `session` = ?', [$_COOKIE['session']]);

setcookie('session', '', time() - 1);
header("Location: /");
exit;
?>