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
        echo json_encode($message, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit;
    }

    public function jsonValidateErrors(array $errors)
    {
        http_status(400);
        header('Content-Type: application/json');

        echo json_encode([
            'success' => false,
            'title' => 'Помилка',
            'message' => 'Дані не пройшли провірку',
            'errors' => $errors
        ]);

        exit;
        //throw new \Exception(json_encode($errors, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT), 400);
    }
}