<?php

namespace Web\Middleware;

use Web\App\Middleware;

class Access extends Middleware
{
    public function handle($key)
    {
        if (cannot($key)) {
            if ($_SERVER['REQUEST_METHOD'] == 'GET') {
                $this->display_403();
            } else {
                $this->response_access_denied();
            }
        }
    }
}