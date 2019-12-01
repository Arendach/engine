<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;

class ProductStorage extends Model
{
    protected $table = 'product_storage';

    public $timestamps = false;

    public static function getCount($storage_id, $product_id)
    {
        return ProductStorage::select('count')
            ->where('storage_id', $storage_id)
            ->where('product_id', $product_id)
            ->first()
            ->count;
    }
}