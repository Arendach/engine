<?php

namespace Web\Requests\Orders;

use Web\App\Request;
use Web\App\RequestValidator;

class CreateDeliveryRequest extends RequestValidator
{
    public function validate(Request $request): void
    {
        if ($request->isEmpty('name'))
            $this->error('name', 'Заповніть імя!');

        if ($request->isEmpty('phone'))
            $this->error('phone', 'Заповніть телефон!');

        if ($request->isEmpty('city'))
            $this->error('city', 'Заповніть місто!');

        if ($request->isEmpty('products'))
            $this->error('products', 'Виберіть хоча-б один товар!');
        dd($this->errors);
    }

    public function authorize(): bool
    {
        return true;
    }

}