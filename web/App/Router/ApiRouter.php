<?php

namespace Web\App\Router;

class ApiRouter extends MainRouter
{
    private $controller;

    private $method;

    public function __construct()
    {
        parent::__construct();

        if ($this->valid_request_url()) {

            $namespace = $this->get_controller_namespace();


            $controller = $this->get_controller($namespace);
            if (is_object($controller) and $controller != false) {
                if ($this->request_method == 'post') {
                    $method_name = $this->get_action_name($controller);
                    if ($this->get_action_name($controller) != false) {
                        app_set('action', $method_name);

                        $this->call_handler($controller, $method_name, $_REQUEST);
                    }
                } /*elseif ($this->request_method == 'get') {
                    $method_name = $this->get_section_name($controller);
                    if ($method_name != false) {
                        if (isset($_GET['section'])) {
                            app_set('section', $_GET['section']);
                            unset($_GET['section']);
                        } else {
                            app_set('section', 'main');
                        }
                        $this->call_handler($controller, $method_name, $_GET);
                    }
                }*/
            }
        }
    }

    public function valid_request_url()
    {
        if (preg_match('@\/api\/([A-z_]+)\/([A-z_]+)@', $this->request_uri, $matches)) {
            $this->controller = $matches[1];
            $this->method = $matches[2];

            return true;
        }

        return false;
    }

    /**
     * @param $object
     * @param $method_name
     * @param $data
     */
    private function call_handler($object, $method_name, $data)
    {
        call_user_func([$object, $method_name], get_object($data));
        exit;
    }

    /**
     * @param $object
     * @return bool|string
     */
    private function get_action_name($object)
    {
        return method_exists($object, 'api_' . $this->method) ? 'api_' . $this->method : false;
    }

    /**
     * @return bool|object
     */
    private function get_controller($namespace)
    {
        return class_exists($namespace) ? new $namespace() : false;
    }

    /**
     * @return string
     */
    private function get_controller_namespace(): string
    {
        return "Web\\Controller\\" . s2c($this->controller) . 'Controller';
    }
}