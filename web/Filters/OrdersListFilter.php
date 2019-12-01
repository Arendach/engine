<?php

namespace Web\Filters;

use Web\App\Filter;

class OrdersListFilter extends Filter
{
    public function id(int $value): void
    {
        $this->builder->where('id', $value);
    }

    public function fio(string $value): void
    {
        $this->builder->where('fio', 'like', "%$value%");
    }

    public function pay_id($value): void
    {
        $this->builder->where('pay_id', $value);
    }

    public function site($value): void
    {
        $this->builder->where('site', $value);
    }

    public function order_professional_id($value): void
    {
        $this->builder->where('order_professional_id', $value);
    }

    public function hint_id($value): void
    {
        $this->builder->where('hint_id', $value);
    }

    public function phone($value): void
    {
        $this->builder->where('phone', $value);
    }

    public function phone2($value): void
    {
        $this->builder->where('phone2', $value);

    }

    public function date($value): void
    {
        $this->builder->whereDate('date_delivery', $value);
    }

    public function courier_id($value): void
    {
        $this->builder->where('courier_id', $value);
    }

    public function time_with($value): void
    {
        $value = time_to_string($value);

        $this->builder->where('time_to', '>=', $value);
    }

    public function time_to($value): void
    {
        $value = time_to_string($value);

        $this->builder->where('time_to', '<=', $value);
    }

    public function region($value): void
    {
        $this->builder->where('street', 'like', "%$value%");
    }

    public function warehouse($value): void
    {
        $this->builder->where('warehouse', $value);
    }

    public function street($value): void
    {
        $this->builder->where('street', 'like', "%$value%");
    }

    public function full_sum($value): void
    {
        $this->builder->where('full_sum', 'like', "%$value%");
    }

    public function liable($value): void
    {
        $this->builder->where('liable', $value);
    }

    public function from($value): void
    {
        if ($this->request->has('to'))
            $this->builder->whereBetween('DATE(date)', [$this->request->from, $this->request->to]);
    }

    public function status($value): void
    {
        if ($value == 'open') $this->builder->whereIn('status', [0, 1]);
        elseif ($value == 'close') $this->builder->whereIn('status', [2, 3, 4]);
        else $this->builder->where('status', $value);
    }

    public function default_status(): void
    {
        $this->builder->whereIn('status', [0, 1, 4]);
    }

    public function default_type(): void
    {
        $this->builder->where('type', 'delivery');
    }

    public function default_order_by()
    {
        $this->builder->orderByDesc('id');
    }
}