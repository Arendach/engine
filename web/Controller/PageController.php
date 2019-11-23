<?php

namespace Web\Controller;

use Web\App\Controller;

class PageController extends Controller
{
    public function error_404()
    {
        http_status('404');
        $this->view->display('/pages/error_404');
    }

    public function error_500(){
        http_status(500);
        $this->view->display('/pages/error_500');
    }
}