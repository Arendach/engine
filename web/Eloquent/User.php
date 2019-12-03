<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Builder;

class User extends Model
{
    use SoftDeletes;

    protected $table = 'users';

    public function scopeCouriers(Builder $query)
    {
        $query->where('is_courier', 1);
    }

}