<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;

class SmsMessage extends Model
{
    protected $table = 'sms_messages';

    public function getStatusNameAttribute()
    {
        return assets('sms_statuses')[$this->status] ?? 'Невідмий';
    }
}