<?php

namespace Web\App;

abstract class Cron
{
    /**
     * @var null|string
     */
    public $description;

    /**
     * @var null|string
     */
    public $error;

    /**
     * @var string
     */
    public $period;

    /**
     * @var string
     */
    public static $handDesc;

    /**
     * @var
     */
    private $response;

    /**
     * @var array
     */
    private $params = [];

    /**
     * Run Schedule
     */
    abstract public function run(): void;

    /**
     * @return void
     */
    private function errorHandler(): void
    {
        Log::error($this->error, 'cron_error');

        $this->response = $this->error;
    }

    /**
     * @return void
     */
    private function successHandler(): void
    {
        if (!is_null($this->description))
            Log::cron($this->period, $this->description);

        $this->response = $this->description;
    }

    /**
     * @param $params array
     * @return void
     */
    public function before(array $params): void
    {
        $this->params = $params;
    }

    /**
     * @return mixed
     */
    public function after()
    {
        is_null($this->error) ? $this->successHandler() : $this->errorHandler();

        return $this->response;
    }

    /**
     * @return int
     */
    public function getCode(): int
    {
        return is_null($this->error) ? 200 : 500;
    }

    /**
     * @return array
     */
    protected function getParams(): array
    {
        return $this->params;
    }
}