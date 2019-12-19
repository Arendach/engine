<?php

namespace Web\Eloquent;

use Illuminate\Database\Eloquent\Model;

class OrderFile extends Model
{
    protected $table = 'order_files';

    public function getIconAttribute()
    {
        $extension = mb_strtolower(pathinfo($this->path)['extension']);

        if (in_array($extension, ['png', 'gif', 'jpeg', 'jpg', 'bmp'])) {
            return $this->path;
        } else {
            return asset("images/formats/$extension.png");
        }
    }

    public function getBaseNameAttribute()
    {
        return pathinfo($this->path)['basename'];
    }

    public function getCreateDateAttribute()
    {
        if (!is_file(base_path($this->path))) return '0000.00.00 00:00';

        return date("Y.m.d H:i", filemtime(base_path($this->path)));
    }

    public function getSizeAttribute()
    {
        if (!is_file(base_path($this->path))) return '0 mb';
        return my_file_size(filesize(base_path($this->path)));
    }
}