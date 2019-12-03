<?php

namespace Web\Requests\Orders;

use Web\App\Request;
use Web\App\RequestValidator;
use Web\Eloquent\Order;

class UpdateWorkingRequest extends RequestValidator
{
    public function validate(Request $request): void
    {
        $order = Order::findOrFail($request->id);

        if ($request->isEmpty('date_delivery'))
            $this->error('date_delivery', 'Заповніть дату доставки!');

        if ($request->get('date_delivery') <= $order->date)
            $this->error('date_delivery', 'Дата доставки не може бути давнішою за дату зведення замовлення!');
    }

    public function authorize(): bool
    {
        return true;
    }
}