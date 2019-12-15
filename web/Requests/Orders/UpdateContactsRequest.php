<?php

namespace Web\Requests\Orders;

use Web\App\Request;
use Web\App\RequestValidator;

class UpdateContactsRequest extends RequestValidator
{
    public function validate(Request $request): void
    {
        $phone_pattern = '/[0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}/';

        if ($this->isEmpty('fio'))
            $this->error('fio', 'Заповніть імя!');

        if ($this->isEmpty('phone'))
            $this->error('phone', 'Заповніть телефон!');

        if (!preg_match($phone_pattern, $this->get('phone')))
            $this->error('phone', 'Заповніть телефон у правильному форматі!');

        if ($this->isNotEmpty('phone2') && !preg_match($phone_pattern, $this->get('phone2')))
            $this->error('phone2', 'Заповніть телефон у правильному форматі!');

        if ($this->isNotEmpty('email') && !filter_var($this->get('email'), FILTER_VALIDATE_EMAIL))
            $this->error('email', 'Заповніть E-Mail у правильному форматі!');

    }

    public function authorize(): bool
    {
        return true;
    }
}