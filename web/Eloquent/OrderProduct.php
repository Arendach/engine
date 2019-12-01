<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Relations\Pivot;

class OrderProduct extends Pivot
{
    protected $fillable = [
        'order_id',
        'attribute',
        'product_id',
        'storage_id',
        'amount',
        'price',
        'place'
    ];

    protected $table = 'order_product';

    public $timestamps = false;

    public function storage()
    {
        return $this->belongsTo(Storage::class);
    }

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    /**
     * @param static $json
     * @return array
     */
    public function getAttributesAttribute(string $json): array
    {
        $attributes = json_decode($json, true);

        return is_array($attributes) ? $attributes : [];
    }

    public function test()
    {
        return $this->belongsTo(Storage::class, ProductStorage::class, 'storage_id');
    }
}