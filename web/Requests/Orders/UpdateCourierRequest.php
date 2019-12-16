<?php

namespace Web\Requests\Orders;


use Web\App\Request;
use Web\App\RequestValidator;
use Web\Eloquent\Order;

class UpdateCourierRequest extends RequestValidator
{
    public function validate(Request $request): void
    {
        $order = Order::findOrFail($request->get('id'));

        if ($order->status != 0 && $request->is('courier_id', 0))
            $this->error('courier_id', 'Неможливо змінити курєра!');
    }

    public function message():string
    {
        return 'Не вдалось змінити курєра!';
    }

    public function authorize(): bool
    {
        return true;
    }
}