<?php

namespace App\Console\Commands;

use App\Models\Product;
use App\Models\Warehouse;
use App\Models\ProductMovement;
use Illuminate\Console\Command;

class PopulateTestData extends Command
{
    protected $signature = 'populate:testdata';
    protected $description = 'Наполнение базы данных тестовыми данными';

    public function __construct()
    {
        parent::__construct();
    }

    public function handle()
    {
        // Наполнение складами
        $warehouse1 = Warehouse::create(['name' => 'Основной склад']);
        $warehouse2 = Warehouse::create(['name' => 'Дополнительный склад']);

        // Наполнение товарами
        $product1 = Product::create(['name' => 'Товар 1', 'stock_quantity' => 100, 'price' => 200]);
        $product2 = Product::create(['name' => 'Товар 2', 'stock_quantity' => 50, 'price' => 150]);
        $product3 = Product::create(['name' => 'Товар 3', 'stock_quantity' => 75, 'price' => 300]);

        // Наполнение движениями товаров
        ProductMovement::create([
            'product_id' => $product1->id,
            'warehouse_id' => $warehouse1->id,
            'quantity_change' => 20,
            'movement_type' => 'incoming',
        ]);

        ProductMovement::create([
            'product_id' => $product2->id,
            'warehouse_id' => $warehouse1->id,
            'quantity_change' => -10,
            'movement_type' => 'outgoing',
        ]);

        ProductMovement::create([
            'product_id' => $product3->id,
            'warehouse_id' => $warehouse2->id,
            'quantity_change' => 30,
            'movement_type' => 'incoming',
        ]);

        // Для демонстрации создадим несколько дополнительных товаров и складов
        $product4 = Product::create(['name' => 'Товар 4', 'stock_quantity' => 200, 'price' => 250]);
        $product5 = Product::create(['name' => 'Товар 5', 'stock_quantity' => 40, 'price' => 100]);

        $warehouse3 = Warehouse::create(['name' => 'Склад в Москве']);
        $warehouse4 = Warehouse::create(['name' => 'Склад в Санкт-Петербурге']);

        ProductMovement::create([
            'product_id' => $product4->id,
            'warehouse_id' => $warehouse3->id,
            'quantity_change' => -50,
            'movement_type' => 'outgoing',
        ]);

        ProductMovement::create([
            'product_id' => $product5->id,
            'warehouse_id' => $warehouse4->id,
            'quantity_change' => 15,
            'movement_type' => 'incoming',
        ]);

        $this->info('Тестовые данные успешно добавлены!');
    }
}
