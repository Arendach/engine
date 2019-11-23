<?php

namespace Web\App;

abstract class Controller extends Entity
{
    /**
     * @var View
     */
    public $view;

    /**
     * @var bool
     */
    public $exception = false;

    /**
     * @var
     */
    public $main_section = 'section_main';

    /**
     * @var
     */
    public $main_action = 'action_main';

    /**
     * @var bool|string|array
     */
    public $middleware = false;

    /**
     * @var array
     */
    public $allowed_methods = [];

    /**
     * @var bool|array|string
     */
    public $access = false;

    /**
     * Controller constructor.
     */
    public function __construct()
    {
        $this->view = new View;
    }

    /**
     * @return string
     */
    public function url()
    {
        return (SITE . $_SERVER['REQUEST_URI']);
    }

    /**
     * @return string
     */
    public function full_url()
    {
        $request = parse_url($_SERVER['REQUEST_URI']);
        return $request['scheme'] . $request['host'] . $request['path'];
    }

    public function not_found()
    {
        http_status(404);
        exit;
    }

    public function access_denied()
    {
        http_status('403');
        exit;
    }

    /**
     * GET Request handle
     */
    public function get_handle($param = '')
    {
        $method_name = 'section_' . get('section');
        if (method_exists($this, $method_name)) {
            $this->$method_name($param);
        } else {
            if ($this->main_section != null) {
                $method_name = $this->main_section;
                $this->$method_name($param);
            } else {
                $this->display_404();
            }
        }
    }

    /**
     * POST Request handle
     * @param $post
     */
    public function post_handle($post)
    {
        $method_name = 'action_' . $post->action;
        unset($post->action);
        if (method_exists($this, $method_name))
            $this->$method_name($post);
        else
            if ($this->main_action != null) {
                $method_name = $this->main_action;
                $this->$method_name($post);
            } else {
                response(400, 'Невідомий екшн!!!');
            }
    }

    /**
     * @param array $keys
     */
    public function required(array $keys, $message = false)
    {
        foreach ($keys as $key) {
            if ($_SERVER['REQUEST_METHOD'] == 'GET') {
                if (!get($key))
                    $this->display_404();
            } else {
                if (!post($key)){
                    $message = !$message ? 'Заповніть всі поля позначені зірочкою!' : $message;
                    response(400, $message);
                }
            }
        }
    }
}

?>