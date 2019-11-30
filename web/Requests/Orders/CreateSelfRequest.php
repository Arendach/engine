<?php

namespace Web\Requests\Orders;

use Web\App\Request;
use Web\App\RequestValidator;

class CreateSelfRequest extends RequestValidator
{
    public function validate(Request $request): void
    {
        if (empty($request->fio))
            $this->error('name', 'Заповніть імя!');

        if (empty($request->phone))
            $this->error('phone', 'Заповніть телефон!');

        if (!isset($post->products))
            $this->error('name', 'Виберіть хоча-б один товар!');
    }

    public function authorize(): bool
    {
        return can('orders');
    }
}