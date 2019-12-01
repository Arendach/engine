<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;

class ProductHistory extends Model
{
    protected $table = 'history_product';

    public $timestamps = false;
}