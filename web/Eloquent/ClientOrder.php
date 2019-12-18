<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;

class ClientOrder extends Model
{
    protected $table = 'client_orders';

    public $timestamps = false;
}