<?php

namespace Web\App;

abstract class RequestValidator extends Request
{
    /**
     * @var Response
     */
    protected $response;

    /**
     * @var array
     */
    protected $errors = [];

    /**
     * RequestValidator constructor.
     */
    public function __construct()
    {
        parent::__construct();

        $this->response = new Response();

        $this->boot();
    }

    /**
     * @return void
     */
    private function boot(): void
    {
        $this->checkAuthorize();

        $this->validate(container(Request::class));

        $this->checkErrors();
    }

    /**
     * @return void
     */
    private function checkAuthorize(): void
    {
        $authorize = $this->authorize();

        if (!$authorize)
            $this->response->abort(403);
    }

    /**
     * @throws \Exception
     * @return void
     */
    private function checkErrors(): void
    {
        if (!count($this->errors)) return;

        $this->response->jsonValidateErrors($this->errors);
    }

    /**
     * @return mixed
     */
    public function mutator()
    {
        return $this->toObject();
    }

    /**
     * @param Request $request
     * @return void
     */
    public function validate(Request $request): void
    {

    }

    /**
     * @param string $field
     * @param string $message
     * @return void
     */
    public function error(string $field, string $message): void
    {
        if (!isset($this->errors[$field]))
            $this->errors[$field] = [];

        $this->errors[$field][] = $message;
    }

    /**
     * @return bool
     */
    abstract public function authorize(): bool;
}