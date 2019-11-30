<?php

namespace Web\App\Router;

use Web\App\Request;
use ReflectionMethod;
use Web\App\Response;

class ReflectionRouter
{
    /**
     * @var Request
     */
    private $request;

    /**
     * @var string
     */
    private $controller;

    /**
     * @var string
     */
    private $method;

    /**
     * @var Response
     */
    private $response;

    public function __construct()
    {
        $this->request = container(Request::class);
        $this->response = container(Response::class);

        $this->boot();
    }

    /**
     * @throws \ReflectionException
     */
    private function boot(): void
    {
        if (!$this->patternCheck()) return;

        $this->setHandler();

        // Обєкт рефлектора
        $reflector = new ReflectionMethod($this->controller, $this->method);

        // Параметри запроса
        $parameters = $this->getParameters($reflector);

        // список парметр => тип
        $list_types = $this->getListTypes($reflector);

        $default_values = $this->getDefaultValues($reflector);

        $this->setDefaultValues($default_values, $parameters);

        // якщо параметри не правильного типу то пропускаємо роут
        if (!$this->isValidParameters($list_types, $parameters))
            return;

        // визиваємо
        $result = $reflector->invokeArgs(new $this->controller, $parameters);

        // відповідь
        $this->response->apply($result);
    }

    /**
     * @param ReflectionMethod $reflector
     * @return array
     */
    private function getParameters(ReflectionMethod $reflector): array
    {
        $reflectorParameters = $reflector->getParameters();

        $parameters = [];
        foreach ($reflectorParameters as $i => $parameter) {
            $type = $parameter->getType();
            $name = $parameter->getName();

            if (is_null($type)) {
                $parameters[$name] = $this->getRequestItem($name);
            } else {
                $type_name = $type->getName();

                if (in_array($type_name, ['int', 'float', 'string', 'array', 'bool'])) {
                    $parameters[$name] = $this->getRequestItem($name);
                } else {
                    $parameters[$name] = container($type_name, $this->getRequestItem($name));
                }
            }
        }

        return $parameters;
    }

    /**
     * @param ReflectionMethod $reflector
     * @return array
     */
    private function getDefaultValues(ReflectionMethod $reflector): array
    {
        $values = [];

        foreach ($reflector->getParameters() as $parameter)
            if ($parameter->isDefaultValueAvailable())
                $values[$parameter->getName()] = $parameter->getDefaultValue();

        return $values;
    }

    /**
     * @param $values
     * @param $parameters
     * @return void
     */
    private function setDefaultValues($values, &$parameters): void
    {
        foreach ($values as $key => $value) {
            if (!array_key_exists($key, $parameters)) continue;

            if (is_null($parameters[$key]))
                $parameters[$key] = $value;
        }
    }

    /**
     * @param ReflectionMethod $reflector
     * @return array
     */
    private function getListTypes(ReflectionMethod $reflector): array
    {
        $reflectorParameters = $reflector->getParameters();

        $list = [];
        foreach ($reflectorParameters as $i => $parameter) {
            $type = $parameter->getType();
            $name = $parameter->getName();

            if (is_null($type)) {
                $list[$name] = 'null';
            } else {
                $type_name = $type->getName();
                if (in_array($type_name, ['string', 'float', 'int', 'array', 'bool']))
                    $list[$name] = $type->getName();
            }
        }

        return $list;
    }

    /**
     * @param string $key
     * @return mixed
     */
    private function getRequestItem(string $key)
    {
        return $this->request->get($key);
    }

    /**
     * @param array $list
     * @param array $parameters
     * @return bool
     */
    private function isValidParameters(array $list, array &$parameters): bool
    {
        foreach ($list as $it => $type) {
            // якщо параметра немає в масиві
            if (!isset($parameters[$it])) return false;

            // параметр будь якого типу
            if ($type == 'null') continue;

            // якщо метод очікує строку
            $this->toString($type, $parameters[$it]);

            // якщо метод очікує число флоат
            $this->toFloat($type, $parameters[$it]);

            // якщо метод очікує число
            $this->toInteger($type, $parameters[$it]);

            // якщо метод очікує boolean
            $this->toBoolean($type, $parameters[$it]);

            // якщо тип дабл а параметр флоат то пропускаємо
            if (gettype($parameters[$it]) == 'double' && $type == 'float') continue;

            // якщо тип integer а параметр int то пропускаємо
            if (gettype($parameters[$it]) == 'integer' && $type == 'int') continue;

            // якщо тип integer а параметр int то пропускаємо
            if (gettype($parameters[$it]) == 'boolean' && $type == 'bool') continue;

            // якщо тмилкаип не співпадає то по
            if (gettype($parameters[$it]) != $type) return false;
        }

        return true;
    }

    /**
     * Перетворення чисел в строку
     * @param $type
     * @param $param
     */
    private function toString($type, &$param): void
    {
        if ($type != 'string') return;

        if (is_integer($param) || is_float($param))
            $param = (string)$param;
    }

    /**
     * @param $type
     * @param $param
     */
    private function toFloat($type, &$param): void
    {
        if ($type != 'float') return;

        if (is_integer($param) || is_float($param) || is_numeric($param))
            $param = (float)$param;
    }

    /**
     * @param $type
     * @param $param
     */
    private function toInteger($type, &$param): void
    {
        if ($type != 'int') return;

        if (is_integer($param) || is_float($param) || is_numeric($param))
            $param = (int)$param;
    }

    /**
     * @param $type
     * @param $param
     * @return void
     */
    private function toBoolean($type, &$param): void
    {
        if ($type != 'bool') return;

        if ($param === 1 || $param === '1' || $param === 'true')
            $param = true;

        if ($param === 0 || $param === '0' || $param === 'false')
            $param = false;
    }

    /**
     * @return bool
     */
    private function patternCheck(): bool
    {
        $pattern = '@^[A-z0-9\_]+\/[A-z0-9\_]+$@';

        return preg_match($pattern, $this->request->uri);
    }

    /**
     * @return void
     */
    private function setHandler(): void
    {
        [$controller, $method] = explode('/', $this->request->uri);

        $this->controller = $this->getControllerNamespace($controller);
        $this->method = $this->getMethodName($method);
    }

    /**
     * @param string $controller
     * @return string
     */
    private function getControllerNamespace(string $controller): string
    {
        $controller = s2c($controller);
        $controller = ucfirst($controller);
        $namespace = "\\Web\\Controller\\{$controller}Controller";

        return $namespace;
    }

    /**
     * @param string $method
     * @return string
     */
    private function getMethodName(string $method): string
    {
        $method = s2c($method);
        $prefix = $this->request->isPost() ? 'action' : 'section';
        $method = $prefix . $method;

        return $method;
    }

}