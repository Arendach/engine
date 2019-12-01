<?php

namespace Web\App;

use Countable;
use Web\App\Interfaces\Converter;

class Collection implements Countable, Converter
{
    /**
     * @var array
     */
    private $data = [];

    /**
     * @var array
     */
    private $paginate = [];

    /**
     * @return int
     */
    public function count(): int
    {
        return count($this->data);
    }

    public function convert($data)
    {
        $this->data = $data;
    }

    public function test()
    {
        return $this->data[0]['name'];
    }

    /**
     * Collection constructor.
     * @param array $data
     */
    public function __construct(array $data = [])
    {
        $this->data = $data;
    }

    /**
     * @param $name
     * @return mixed|null
     */
    public function __get($name)
    {
        return $this->data[$name] ?? null;
    }

    /**
     * @param string $name
     * @param $value
     */
    public function __set(string $name, $value)
    {
        $this->data[$name] = $value;
    }

    /**
     * @return array
     */
    public function all(): array
    {
        return $this->data;
    }

    /**
     * @param string $key
     * @return null|mixed
     */
    public function get(string $key)
    {
        return $this->query[$key] ?? null;
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
        foreach ($this->data as $key => $item)
            if (!in_array($key, $keys))
                $result[$key] = $item;

        return $result;
    }

    public function setPaginate(array $data): void
    {
        $this->paginate = $data;
    }

    public function getPaginate(): array
    {
        return $this->paginate;
    }
}