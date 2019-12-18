<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;

class Client extends Model
{
    protected $table = 'clients';

    protected $fillable = [
        'name',
        'email',
        'phone',
        'address',
        'info',
        'group_id',
        'percentage',
        'manager_id'
    ];

    public function manager()
    {
        return $this->belongsTo(User::class, 'manager_id', 'id');
    }

    public function group()
    {
        return $this->hasOne(ClientGroup::class);
    }
}