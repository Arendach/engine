<?php

namespace Web\Requests\Orders;

use Web\App\Request;
use Web\App\RequestValidator;
use Web\Eloquent\Order;

class UpdateWorkingRequest extends RequestValidator
{
    public function validate(Request $request): void
    {
        abort(401);

        $order = Order::findOrFail($request->id);

        if ($request->isEmpty('date_delivery'))
            $this->error('date_delivery', 'Заповніть дату доставки!');

        if (strtotime($request->get('date_delivery')) < $order->created_at->timestamp)
            $this->error('date_delivery', 'Дата доставки не може бути давнішою за дату зведення замовлення!');

        if ($request->isNotEmpty('time_with') && !preg_match('/[0-9\:]{1,5}/', $request->get('time_with')))
            $this->error('time_with', 'Формат хх:хх');

        if ($this->isNotEmpty('time_to') && !preg_match('/[0-9:]{1,5}/', $this->get('time_to')))
            $this->error('time_to', 'Формат хх:хх');

    }

    public function authorize(): bool
    {
        return true;
    }
}