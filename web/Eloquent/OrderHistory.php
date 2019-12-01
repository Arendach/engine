<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;

class OrderHistory extends Model
{
    protected $table = 'changes';

    public $timestamps = false;

}