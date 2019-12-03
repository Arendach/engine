<?php

namespace Web\Requests\Orders;

use Web\App\Request;
use Web\App\RequestValidator;

class UpdateContactsRequest extends RequestValidator
{
    public function validate(Request $request): void
    {
        if ($this->isEmpty('fio'))
            $this->error('fio', 'Заповніть імя!');

        if ($this->isEmpty('phone'))
            $this->error('phone', 'Заповніть телефон!');
    }

    public function authorize(): bool
    {
        return true;
    }
}