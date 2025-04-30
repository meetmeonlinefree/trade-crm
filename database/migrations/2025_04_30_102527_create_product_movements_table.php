<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::create('product_movements', function (Blueprint $table) {
            $table->id();
            $table->foreignId('product_id')->constrained()->onDelete('cascade'); // Связь с товаром
            $table->foreignId('warehouse_id')->constrained()->onDelete('cascade'); // Связь со складом
            $table->integer('quantity_change'); // Изменение количества
            $table->enum('movement_type', ['incoming', 'outgoing']); // Тип движения (поступление или расход)
            $table->timestamps();
        });
    }
    
    public function down()
    {
        Schema::dropIfExists('product_movements');
    }
};
