<?php

namespace RedBeanPHP;

class R extends Facade{}

R::setup(DB_DSN, DB_USER, DB_PASSWORD, true);

R::ext('xdispense', function ($type) {
    return R::getRedBean()->dispense($type);
});

R::exec("SET sql_mode = ''");