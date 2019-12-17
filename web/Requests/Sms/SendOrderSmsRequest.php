<?php

namespace Web\Requests\Sms;

use Web\App\Request;
use Web\App\RequestValidator;

class SendOrderSmsRequest extends RequestValidator
{
    public function validate(Request $request): void
    {
        if ($request->isEmpty('text'))
            $this->error('text', 'Заповніть текст повідомлення!');

        if ($request->notMatch('phone', '@^\+38[0-9]{10}$@'))
            $this->error('phone', 'Заповніть телефон у вірному форматі!');

        if ($request->isEmpty('order_id'))
            $this->error('order_id', 'Не переданий ідентифікатор замовлення!');
    }

    protected function message(): string
    {
        return 'Не вдалось відправити повідомлення!';
    }

    public function authorize(): bool
    {
        return true;
    }
}