<?php

namespace Web\App\Router;

class StrongRouter extends MainRouter
{
    /**
     * @var array
     */
    private $post = [];

    /**
     * @var array
     */
    private $get = [];

    /**
     * @var array
     */
    public $named = [];

    /**
     * @param $rout
     * @param $controller
     * @param array $param
     */
    public function get($rout, $controller, $param = [])
    {
        if (is_array($controller)) {
            if (!isset($controller['uses'])) {
                $message = 'Клас обробник роута не обявлений!';
                $this->display_500($message);
            }

            if (isset($controller['as']))
                $this->named[$controller['as']] = $rout;
            $controller = $controller['uses'];
        }

        if (preg_match_all("~\{[A-Za-z0-9]+\}~", $rout, $matches)) {
            $c = count($matches[0]);
            $pattern = '';
            for ($i = 1; $i <= $c; $i++) {
                $pattern .= '([A-Za-z0-9]+)/';
            }
        } else {
            $pattern = '';
        }

        $pattern = rtrim($pattern, '/');

        $exp = "~^" . explode("{", $rout)[0] . "{$pattern}$~";
        $this->get[$exp]['controller'] = $controller;
        $this->get[$exp]['param'] = $param;
    }

    /**
     * @param $rout
     * @param $controller
     * @param array $param
     */
    public function post($rout, $controller, $param = [])
    {
        $this->post[$rout]['controller'] = $controller;
        $this->post[$rout]['param'] = $param;
    }

    /**
     * Parse GET Request
     */
    public function parse_get()
    {
        if ($this->request_uri != '/') $this->request_uri = rtrim($this->request_uri, '/');

        $request = explode('?', $this->request_uri);

        $found = false;

        foreach ($this->get as $pattern => $params) {

            if (preg_match($pattern, $request[0], $match)) {
                $parameters = $params['param'];

                // Middleware Init
                $this->middleware_autoload_init(isset($parameters['exception']) && $parameters['exception'] == true ? true : false);
                $this->middleware_init(isset($parameters['middleware']) ? $parameters['middleware'] : []);

                // Access Check
                if (isset($parameters['access'])) $this->access_check_by_keys($parameters['access']);

                array_shift($match);

                $match = isset($match[0]) ? $match[0] : '';
                $this->control_handler($params['controller'], $match);
                // exit;
            }

        }

        // if (!$found) $this->route_not_found($this->request_uri);
    }

    /**
     * Parse POST Request
     */
    public function parse_post()
    {
        if (isset($this->post[$this->request_uri])) {
            $route = $this->post[$this->request_uri];
            $parameters = $route['param'];

            // Middleware Init
            $this->middleware_autoload_init(isset($parameters['exception']) && $parameters['exception'] == true ? true : false);
            $this->middleware_init(isset($parameters['middleware']) ? $parameters['middleware'] : []);

            // Access Check
            if (isset($parameters['access'])) $this->access_check_by_keys($parameters['access']);

            $this->control_handler($route['controller'], (object)$_POST);
            exit;
        } else {
            $this->route_not_found($this->request_uri);
        }
    }

    /**
     * @param $middleware
     */
    private function middleware_init($middleware)
    {
        if (is_array($middleware))
            foreach ($middleware as $item) $this->middleware_named_init($item);
        elseif (is_string($middleware))
            $this->middleware_named_init($middleware);
    }

    /**
     * @param $controller
     * @param $arguments
     */
    private function control_handler($controller, $arguments)
    {
        list($class, $method) = explode('@', $controller);

        $object = $this->get_controller($class);

        if (is_object($object)) {
            if (method_exists($object, $method)) {
                // Nice
                $this->call_handler($object, $method, $arguments);
            } else {
                $this->method_not_exists($class, $method);
            }
        } else {
            $this->controller_not_exists($class);
        }
    }

    /**
     * @param $object
     * @param $method
     * @param $arguments
     */
    private function call_handler($object, $method, $arguments)
    {
        call_user_func([$object, $method], $arguments);
    }

    /**
     * @param $class
     * @return bool|object
     */
    private function get_controller($class)
    {
        $controller = "Web\\Controller\\" . $class;
        if (class_exists($controller)) {
            return new $controller();
        } else {
            return false;
        }
    }

    /**
     * @param $route
     */
    private function route_not_found($route)
    {
        if ($this->request_method == 'get') {
            $this->display_404();
        } else {
            response('404', "Помилка! Роут \"$route\" не знайдений!");
        }
        exit;
    }

}