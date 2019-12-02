<?php

namespace Web\Requests\Orders;


use Web\App\Request;
use Web\App\RequestValidator;
use Web\Eloquent\Order;

class UpdateStatusRequest extends RequestValidator
{
    public function authorize(): bool
    {
        return true;
    }

    public function validate(Request $request): void
    {
        $order = Order::findOrFail($request->id);

        if (($order->type == 'delivery' || $order->type == 'self') && $order->courier_id == 0)
            $this->error('status', 'Для того щоб змінити статус виберіть курєра!');
    }
}