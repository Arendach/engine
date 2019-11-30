<?php

namespace Web\App;

use ReflectionMethod;
use ReflectionClass;
use Web\App\Interfaces\Converter;

class Container
{
    /**
     * @var array
     */
    private static $objects = [];

    /**
     * @var array
     */
    private static $singleton = [];

    /**
     * @var array
     */
    private static $data = [];

    /**
     * @param string $key
     * @param $value
     */
    public static function set(string $key, $value)
    {
        static::$data[$key] = $value;
    }

    /**
     * @param string $key
     * @param null $default
     * @return mixed|null
     */
    public static function get(string $key, $default = null)
    {
        return isset(static::$data[$key]) ? static::$data[$key] : $default;
    }

    /**
     * @return array
     */
    public static function getContainer(): array
    {
        return static::$data;
    }

    /**
     * @param string $abstract
     * @return mixed
     */
    public function getClassObject(string $abstract, $parameter = null)
    {
        $parameters = $this->getConstructParameters($abstract);

        $parameters = $this->setParameters($parameters);

        $object = $this->classObject($abstract, $parameters);

        $this->converter($object, $parameter);

        return $object;
    }

    /**
     * @param $object
     * @param $data
     */
    private function converter($object, $data)
    {
        if ($object instanceof Converter){
            $object->convert($data);
        }
    }

    /**
     * @param string $abstract
     * @param array $parameters
     * @return mixed
     */
    private function classObject(string $abstract, array $parameters)
    {
        if (!in_array($abstract, static::$objects))
            return $this->magicMakeObject($abstract, $parameters);

        if (!isset(static::$objects[$abstract]))
            static::$objects[$abstract] = $this->magicMakeObject($abstract, $parameters);

        return static::$objects[$abstract];
    }

    /**
     * @param $abstract
     * @return array
     * @throws \ReflectionException
     */
    private function getConstructParameters($abstract): array
    {
        $parameters = [];

        $reflectorClass = new ReflectionClass($abstract);

        if ($abstract != 'Web\App\Collection') return [];

        if ($reflectorClass->hasMethod('__construct')) {
            $reflectorMethod = new ReflectionMethod($abstract, '__construct');
            $constructorParameters = $reflectorMethod->getParameters();

            foreach ($constructorParameters as $parameter) {
                $parameterType = $parameter->getType();
                $parameterName = $parameter->getName();

                $parameters[$parameterName] = is_null($parameterType) ? null : $parameterType->getName();
            }
        }

        return $parameters;
    }

    /**
     * @param $abstract
     * @param array $parameters
     * @return mixed
     */
    private function magicMakeObject($abstract, array $parameters)
    {
        $object = null;
        $parametersString = '';
        foreach ($parameters as $key => $parameter) {
            $parametersString .= "\$parameters['$key'],";
        }

        $parametersString = trim($parametersString, ',');

        $classString = " \$object =  new $abstract($parametersString); ";

        eval($classString);

        return $object;
    }

    /**
     * @param array $parameters
     * @return array
     */
    private function setParameters(array $parameters): array
    {
        $types = [
            'bool',
            'array',
            'string',
            'int',
            'float'
        ];

        $result = [];
        foreach ($parameters as $parameter => $parameterType) {
            if (in_array($parameterType, $types)) continue;

            $result[$parameter] = container($parameterType);
        }

        return $result;
    }

    /**
     * @param string $abstract
     */
    public function singleton(string $abstract)
    {
        if (!in_array($abstract, static::$singleton[]))
            static::$singleton[] = $abstract;
    }

    public function call()
    {

    }
}