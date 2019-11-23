<?php

namespace Web\App;

class Exception extends \Couchbase\Exception
{
    public function __construct($var)
    {
        echo $var;
    }
}