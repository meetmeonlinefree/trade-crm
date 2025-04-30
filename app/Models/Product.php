<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    public $timestamps = false; // в таблице нет created_at/updated_at

    protected $fillable = ['name', 'price'];

    /**
     * Остатки на складах (многие-ко-многим с pivot stock)
     */
    public function stocks()
    {
        return $this->hasMany(Stock::class);
    }
}

