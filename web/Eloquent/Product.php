<?php

namespace Web\Eloquent;

use AjCastro\EagerLoadPivotRelations\EagerLoadPivotTrait;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $table = 'products';

    use EagerLoadPivotTrait;

    public function storage()
    {
        return $this->belongsTo(Storage::class, 'storage_id');
    }

    /**
     * @param static $json
     * @return array
     */
    public function getAttributesAttribute(string $json): array
    {
        $attributes = json_decode(htmlspecialchars_decode($json), true);

        return is_array($attributes) ? $attributes : [];
    }

    public function linked()
    {
        return $this->belongsToMany(Product::class, ProductLinked::class, 'product_id', 'linked_id')
            ->withPivot('combine_price', 'combine_minus');
    }

}