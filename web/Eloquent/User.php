<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Builder;

class User extends Model
{
    use SoftDeletes;

    protected $table = 'users';

    protected $fillable = [
        'theme'
    ];

    public function scopeCouriers(Builder $query)
    {
        $query->where('is_courier', 1);
    }

    public function getThemeAttribute($theme)
    {
        if (is_null($theme)) return asset("css/themes/flatfly.css");
        else return asset("css/themes/$theme.css");
    }

    public function getIsOnlineAttribute(): bool
    {
        return ((time() - $this->updated_at->timestamp) < 300);
    }

}