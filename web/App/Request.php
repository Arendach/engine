<?php

namespace Web\App;

use stdClass;

class Request
{
    /**
     * @var string
     */
    public $method;

    /**
     * @var array
     */
    protected $query;

    /**
     * @var array
     */
    private $cookie;

    /**
     * @var string
     */
    public $uri;

    /**
     * @var string
     */
    public $host;

    /**
     * @var string
     */
    public $scheme;

    /**
     * @var string
     */
    public $url;

    /**
     * @var string
     */
    public $full_url;

    /**
     * Request constructor.
     */
    public function __construct()
    {
        $this->method = strtolower($_SERVER['REQUEST_METHOD']);
        $this->setQuery();
        $this->queryConverter();
        $this->setCookie();
        $this->setUri();
        $this->setScheme();
        $this->setHost();
        $this->setUrl();
        $this->setFullUrl();
    }

    /**
     * @return bool
     */
    public function isGet(): bool
    {
        return $this->method == 'get';
    }

    /**
     * @return bool
     */
    public function isPost(): bool
    {
        return $this->method == 'post';
    }

    /**
     * @param string $key
     * @return mixed
     */
    public function get(string $key, $default = null)
    {
        if (!isset($this->query[$key])) return $default;

        return $this->query[$key];
    }

    /**
     * @param string $key
     * @return bool
     */
    public function has(string $key): bool
    {
        return isset($this->query[$key]);
    }

    /**
     * @param string $key
     * @return bool
     */
    public function isEmpty(string $key): bool
    {
        if (!$this->has($key)) return false;

        if (is_null($this->get($key))) return false;

        if ($this->get($key) == '') return false;

        return true;
    }

    /**
     * @param array $keys
     * @return array
     */
    public function only(array $keys): array
    {
        $result = [];
        foreach ($keys as $key)
            $result[$key] = $this->get($key);

        return $result;
    }

    /**
     * @param array $keys
     * @return array
     */
    public function except(array $keys): array
    {
        $result = [];
        foreach ($this->query as $key => $item)
            if (!in_array($key, $keys))
                $result[$key] = $item;

        return $result;
    }

    /**
     * @return array
     */
    public function toArray(): array
    {
        return (array)$this->query;
    }

    /**
     * @return stdClass
     */
    public function toObject(): stdClass
    {
        return (object)$this->query;
    }

    /**
     * @return string
     */
    public function toJson(): string
    {
        return json_encode($this->query);
    }

    /**
     * @param string $key
     * @return mixed|null
     */
    public function getCookie(string $key)
    {
        if (isset($this->cookie[$key])) return null;

        return $this->cookie[$key];
    }

    /**
     * @param string $key
     * @param string $type
     * @return mixed
     */
    public function getFromType(string $key, string $type)
    {
        return Type::to($type, $this->get($key));
    }

    /**
     * @return string
     */
    public function getUri(): string
    {
        return $this->uri;
    }

    /**
     * @return void
     */
    private function setQuery(): void
    {
        if ($this->isGet())
            $this->query = $_GET;
        elseif ($this->isPost())
            $this->query = $_POST;
        else
            $this->query = [];
    }

    /**
     * @return void
     */
    private function queryConverter(): void
    {
        foreach ($this->query as $key => $value) {
            if (!is_string($value)) continue;

            if (preg_match('@^[0-9]+$@', $value))
                $this->query[$key] = (int)$value;

            elseif (preg_match('@^[0-9]+\.[0-9]+$@', $value))
                $this->query[$key] = (float)$value;
        }
    }

    /**
     * @return void
     */
    private function setCookie(): void
    {
        $this->cookie = $_COOKIE;
    }

    /**
     * @return void
     */
    private function setUri(): void
    {
        [$uri] = explode('?', $_SERVER['REQUEST_URI']);
        $this->uri = trim($uri, '/');
    }

    /**
     * @return void
     */
    private function setScheme(): void
    {
        $this->scheme = $_SERVER['REQUEST_SCHEME'];
    }

    /**
     * @return void
     */
    private function setHost(): void
    {
        $this->host = $_SERVER['HTTP_HOST'];
    }

    /**
     * @return void
     */
    private function setUrl(): void
    {
        $this->url = $this->scheme . '://' . $this->host . '/' . $this->uri;
    }

    /**
     * @return void
     */
    private function setFullUrl(): void
    {
        $this->full_url = $this->scheme . '://' . $this->host . '/' . $this->uri . '?' . $_SERVER['QUERY_STRING'];
    }

    /**
     * @param $name
     * @return mixed
     * @throws \Exception
     */
    public function __get($name)
    {
        if (isset($this->query[$name])) {
            return $this->query[$name];
        }

        throw new \Exception();
    }
}