<?php

namespace Web\App;


class Request
{
    /**
     * @var
     */
    public $method;

    /**
     * @var
     */
    private $type;

    /**
     * @var
     */
    private $request;

    /**
     * @var
     */
    private $_get;

    /**
     * @var
     */
    private $_post;

    /**
     * Request constructor.
     */
    public function __construct()
    {
        $this->method = $_SERVER['REQUEST_METHOD'];
    }

    /**
     * @param $args
     */
    public function setup($args)
    {
        $this->type = $args['type'];
        $this->request = $args['request'];
        parse_str($args['query'], $output);
        $this->_get = $output;
        $this->_post = $args['data'];
    }

    /**
     * @param null $name
     * @return bool
     */
    public function get($name = null)
    {
        if ($name === null) {
            return isset($_GET) ? $_GET : false;
        } else {
            return isset($_GET[$name]) ? $_GET[$name] : false;
        }
    }

    /**
     * @param null $name
     * @return bool
     */
    public function post($name = null)
    {
        if ($name === null) {
            return isset($_POST) ? $_POST : false;
        } else {
            return isset($_POST[$name]) ? $_POST[$name] : false;
        }
    }

    /**
     * @param $url
     * @param array $data
     * @return bool|string
     */
    public function sendTo($url, $data = [])
    {

        $vars = "";
        foreach ($data as $key => $value) {
            $vars .= "&{$key}={$value}";
        }

        $vars = substr($vars, 1);

        return file_get_contents("{$url}?{$vars}");
    }
}