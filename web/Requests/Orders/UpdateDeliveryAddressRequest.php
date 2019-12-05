<?php

namespace Web\Requests\Orders;

use Web\App\Request;
use Web\App\RequestValidator;

class UpdateDeliveryAddressRequest extends RequestValidator
{
    public function validate(Request $request): void
    {
        if ($request->isEmpty('city'))
            $this->error('city', 'Введіть назву міста!');

    }

    public function authorize(): bool
    {
        return true;
    }
}