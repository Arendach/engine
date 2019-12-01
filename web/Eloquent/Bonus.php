<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;

class Bonus extends Model
{
    protected $table = 'bonuses';

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}