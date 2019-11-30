<?php

namespace Web\App;

class Response
{
    public function apply($response)
    {
        dd($response);
    }

    public function abort(int $code): void
    {
        http_status($code);

        if (is_file(t_file('pages.error_' . $code)))
            include t_file('pages.error_' . $code);
        else
            echo 'error ' . $code;

        exit;
    }

    public function jsonValidateErrors(array $errors)
    {
        throw new \Exception(json_encode($errors), 400);
    }
}