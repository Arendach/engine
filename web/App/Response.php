<?php

namespace Web\App;

class Response
{
    public function apply($response)
    {
        if (is_string($response))
            echo $response;
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

    public function json($message, $status = 200)
    {
        http_status($status);
        header('Content-Type: application/json');
        echo json_encode($message);
        exit;
    }

    public function jsonValidateErrors(array $errors)
    {
        throw new \Exception(json_encode($errors), 400);
    }
}