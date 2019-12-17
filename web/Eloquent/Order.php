<?php

namespace Web\Eloquent;

use AjCastro\EagerLoadPivotRelations\EagerLoadPivotTrait;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use EagerLoadPivotTrait;

    protected $table = 'orders';

    protected $dates = ['created_at', 'date_delivery', 'updated_at', 'deleted_at'];

    public $timestamps = true;

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

    public function files()
    {
        return $this->hasMany(OrderFile::class);
    }

    public function products()
    {
        return $this->belongsToMany(Product::class, OrderProduct::class)
            ->withPivot('amount', 'price', 'storage_id', 'id', 'attributes');
    }

    public function history()
    {
        return $this->hasMany(OrderHistory::class, 'id_order', 'id')
            ->orderByDesc('id');
    }

    public function getTypeNameAttribute()
    {
        if ($this->type == 'sending') return 'Відправка';
        elseif ($this->type == 'delivery') return 'Доставка';
        elseif ($this->type == 'self') return 'Самовивіз';
        else return '';
    }

    public function getStatusNameAttribute()
    {
        return assets('order_statuses')[$this->status]['text'] ?? 'Невідомий';
    }

    public function getStatusColorAttribute()
    {
        return assets('order_statuses')[$this->status]['color'] ?? '#f0f';
    }

    public function getSendingStatusNameAttribute()
    {
        return assets('sending_statuses')[$this->phone2]['text'] ?? 'Невідомий';
    }

    public function getSendingStatusColorAttribute()
    {
        return assets('sending_statuses')[$this->phone2]['color'] ?? '#f0f';
    }

    public function getDateDeliveryHumanAttribute()
    {
        $date  = $this->date_delivery;

        if ($date->format('Y') == date('Y'))
            return (int)$date->format('d') . ' ' . int_to_month($date->format('m'), true);
        else
            return date_for_humans($date->format('Y-m-d'));
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

    public function getSumAttribute()
    {
        $this->products->sum(function ($item){
            return $item->pivot->amount * $item->pivot->price;
        });
    }

    public function getSendingCityNameAttribute()
    {

    }


    public function getSendingWarehouseNameAttribute()
    {

    }

    public function getTimeAttribute()
    {
        if (is_null($this->time_with) && is_null($this->time_to)){
            return '<span class="text-primary">Не важливо</span>';
        } elseif (is_null($this->time_with) && !is_null($this->time_to)){
            return "до " . string_to_time($this->time_to);
        } elseif (!is_null($this->time_with) && is_null($this->time_to)){
            return "з " . string_to_time($this->time_with);
        } else {
            return string_to_time($this->time_with) . ' - ' . string_to_time($this->time_to);
        }
    }

    public function getPhoneFormatAttribute()
    {
        return get_number_world_format(str_replace('-', '', $this->phone));
    }
}