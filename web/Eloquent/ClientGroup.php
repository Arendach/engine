<?php
/**
 * Created by PhpStorm.
 * User: taras
 * Date: 18.12.2019
 * Time: 22:58
 */

namespace Web\Eloquent;


use Illuminate\Database\Eloquent\Model;

class ClientGroup extends Model
{
    protected $table = 'client_groups';

    protected $fillable = ['name'];
}