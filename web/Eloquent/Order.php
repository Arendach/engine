<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $table = 'orders';

    protected $dates = ['created_at', 'date_delivery'];

    public function hint()
    {
        return $this->belongsTo(OrderHint::class);
    }

    public function logistic()
    {
        return $this->belongsTo(Logistic::class);
    }

    public function pay()
    {
        return $this->belongsTo(Pay::class);
    }

    public function author()
    {
        return $this->belongsTo(User::class);
    }

    public function liable()
    {
        return $this->belongsTo(User::class);
    }

    public function courier()
    {
        return $this->belongsTo(User::class);
    }

    public function professional()
    {
        return $this->belongsTo(OrderProfessional::class, 'order_professional_id', 'id');
    }

    public function bonuses()
    {
        return $this->hasMany(Bonus::class, 'data')
            ->with('user');
    }

    public function sms_messages()
    {
        return $this->hasMany(SmsMessage::class);
    }

    public function getTypeNameAttribute()
    {
        if ($this->type == 'sending') return 'Відправка';
        elseif ($this->type == 'delivery')return 'Доставка';
        elseif ($this->type == 'self')return 'Самовивіз';
        else return '';
    }

    /**
     * @param Builder $builder
     * @param $filters
     * @return Builder
     */
    public function scopeFilter(Builder $builder, $filters): Builder
    {
        return $filters->apply($builder);
    }
}