<?php

namespace Web\App\Router;

use Web\App\Entity;

abstract class MainRouter extends Entity
{
    /**
     * @var string
     */
    public $request_method;

    /**
     * @var string
     */
    public $request_uri;

    /**
     * @var \Web\App\Router\MiddlewareList
     */
    public $middleware_list;

    /**
     * MainRouter constructor.
     */
    public function __construct()
    {
        $this->request_method = strtolower($_SERVER['REQUEST_METHOD']);
        $this->request_uri = strtolower($_SERVER['REQUEST_URI']);
        $this->middleware_list = new MiddlewareList();
    }

    /**
     * @param bool $exception
     * Middleware Init
     */
    protected function middleware_autoload_init($exception = false)
    {
        if ($exception == false) {
            foreach ($this->middleware_list->autoload as $item) {
                if (class_exists($item)) {
                    $object = new $item();
                    if (method_exists($object, 'handle')) {
                        $object->handle();
                    }
                }
            }
        }
    }

    /**
     * Middleware Init
     * @param $key
     */
    protected function middleware_named_init($key)
    {
        if (isset($this->middleware_list->named[$key])) {
            if (class_exists($this->middleware_list->named[$key])) {
                $object = new $this->middleware_list->named[$key];
                if (method_exists($object, 'handle')) {
                    $object->handle();
                }
            }
        }
    }

    /**
     * @param $keys
     */
    protected function access_check_by_keys($keys)
    {
        $access = true;
        if (is_string($keys)) {
            if (cannot($keys)) $access = false;
        } elseif (is_array($keys)) {
            foreach ($keys as $key) {
                if (cannot($key)) $access = false;
            }
        }

        if (!$access) {
            if ($this->request_method == 'post') {
                response(403, 'У вас немає доступу для даної дії!');
            } elseif ($this->request_method == 'get') {
                $this->display_403();
            }
        }
    }

    /**
     * @param $controller
     */
    protected function controller_not_exists($controller)
    {
        if ($this->request_method == 'get') {
            $this->display_500("Контроллер $controller не знайдений!");
        } elseif ($this->request_method == 'post') {
            response(500, "Контроллер $controller не знайдений!");
        }
        exit;
    }

    /**
     * @param $controller
     * @param $method
     */
    protected function method_not_exists($controller, $method)
    {
        if ($this->request_method == 'get') {
            $this->display_500("Метод $method контроллера $controller не знайдений!");
        } else {
            response(500, "Метод $method контроллера $controller не знайдений!");
        }
        exit;
    }
}