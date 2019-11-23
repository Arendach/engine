<?php

namespace Web\App\Router;

class SimpleRouter extends MainRouter
{
    /**
     * SimpleRouter constructor.
     */
    public function __construct()
    {
        parent::__construct();

        $namespace = $this->get_controller_namespace();

        if ($namespace != false) {
            $controller = $this->get_controller($namespace);
            if (is_object($controller) and $controller != false) {
                if ($this->request_method == 'post') {
                    $method_name = $this->get_action_name($controller);
                    if ($method_name != false) {
                        if (isset($_POST['action'])) {
                            app_set('action', $_POST['action']);
                            unset($_POST['action']);
                        } else {
                            app_set('action', 'main');
                        }
                        $this->call_handler($controller, $method_name, $_POST);
                    }
                } elseif ($this->request_method == 'get') {
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
                }
            }
        }
    }

    /**
     * @param $object
     * @param $method_name
     * @param $data
     */
    private function call_handler($object, $method_name, $data)
    {
        $this->middleware_init($object);
        $this->access_check_init($object, $method_name);

        call_user_func([$object, $method_name], get_object($data));
        exit;
    }

    /**
     * @param $object
     * @param $method_name
     * @return bool
     */
    public function access_check_init($object, $method_name): bool
    {
        if (in_array($method_name, $object->allowed_methods)) return true;

        if ($object->exception) return true;

        if ($object->access != false && is_array($object->access) || is_string($object->access)) {
            $this->access_check_by_keys($object->access);
        }

        return false;
    }

    /**
     * @param $object
     */
    private function middleware_init($object)
    {
        $this->middleware_autoload_init($object->exception);

        if ($object->middleware != false && is_string($object->middleware)) {
            $this->middleware_named_init($object->middleware);
        } elseif ($object->middleware != false && is_array($object->middleware)) {
            foreach ($object->middleware as $item) {
                $this->middleware_named_init($item);
            }
        }
    }

    /**
     * @param $object
     * @return bool|string
     */
    private function get_action_name($object)
    {
        if (post('action')) {
            return method_exists($object, 'action_' . post('action')) ? 'action_' . post('action') : false;
        } else {
            return method_exists($object, $object->main_action) ? $object->main_action : false;
        }
    }

    /**
     * @param $object
     * @return bool|string
     */
    private function get_section_name($object)
    {
        if (get('section')) {
            return method_exists($object, 'section_' . get('section')) ? 'section_' . get('section') : false;
        } else {
            return method_exists($object, $object->main_section) ? $object->main_section : false;
        }
    }

    /**
     * @return bool|object
     */
    private function get_controller($namespace)
    {
        if (class_exists($namespace)) {
            return new $namespace();
        } else {
            return false;
        }
    }

    /**
     * @return bool|string
     */
    private function get_controller_namespace()
    {
        if (preg_match('/^\/([\w]+)/', $this->request_uri, $matches)) {
            $controller = s2c($matches[1]);
            app_set('controller', $controller);
            return "Web\\Controller\\" . $controller . 'Controller';
        } else {
            return false;
        }
    }
}