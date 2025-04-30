<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Stock;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Order::with(['items.product', 'warehouse']);
    
        // Фильтры
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }
    
        if ($request->has('customer')) {
            $query->where('customer', 'like', '%' . $request->customer . '%');
        }
    
        if ($request->has('warehouse_id')) {
            $query->where('warehouse_id', $request->warehouse_id);
        }
    
        // Пагинация (по умолчанию 10)
        $perPage = $request->get('per_page', 10);
    
        $orders = $query->paginate($perPage);
    
        return response()->json($orders);
    }
    

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Валидация входящих данных
        $request->validate([
            'customer' => 'required|string|max:255',
            'warehouse_id' => 'required|exists:warehouses,id',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.count' => 'required|integer|min:1',
        ]);
    
        // Оборачиваем в транзакцию (чтобы всё откатилось в случае ошибки)
        DB::beginTransaction();
    
        try {
            // Создаём заказ
            $order = Order::create([
                'customer' => $request->customer,
                'warehouse_id' => $request->warehouse_id,
                'status' => 'active',
                'created_at' => Carbon::now(),
                'completed_at' => null,
            ]);
    
            // Для каждого товара — проверяем наличие и списываем со склада
            foreach ($request->items as $item) {
                $stock = Stock::where('product_id', $item['product_id'])
                              ->where('warehouse_id', $request->warehouse_id)
                              ->first();
    
                if (!$stock || $stock->stock < $item['count']) {
                    DB::rollBack();
                    return response()->json(['error' => 'Недостаточно товара на складе'], 400);
                }
    
                // Списываем
                $stock->stock -= $item['count'];
                $stock->save();
    
                // Добавляем позицию в заказ
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item['product_id'],
                    'count' => $item['count'],
                ]);
            }
    
            DB::commit();
    
            return response()->json(['message' => 'Заказ создан успешно', 'order_id' => $order->id]);
    
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Ошибка создания заказа'], 500);
        }

    /**
     * Display the specified resource.
     */
    public function show(Order $order)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Order $order)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Order $order)
    {
        if ($order->status != 'active') {
            return response()->json(['error' => 'Можно изменять только активные заказы'], 400);
        }
    
        // Валидация
        $request->validate([
            'customer' => 'required|string|max:255',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.count' => 'required|integer|min:1',
        ]);
    
        DB::beginTransaction();
    
        try {
            // Возвращаем старые позиции на склад
            foreach ($order->items as $oldItem) {
                $stock = Stock::where('product_id', $oldItem->product_id)
                              ->where('warehouse_id', $order->warehouse_id)
                              ->first();
                $stock->stock += $oldItem->count;
                $stock->save();
            }
    
            // Удаляем старые позиции
            $order->items()->delete();
    
            // Добавляем новые позиции и списываем заново
            foreach ($request->items as $item) {
                $stock = Stock::where('product_id', $item['product_id'])
                              ->where('warehouse_id', $order->warehouse_id)
                              ->first();
    
                if (!$stock || $stock->stock < $item['count']) {
                    DB::rollBack();
                    return response()->json(['error' => 'Недостаточно товара на складе'], 400);
                }
    
                $stock->stock -= $item['count'];
                $stock->save();
    
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item['product_id'],
                    'count' => $item['count'],
                ]);
            }
    
            // Обновляем данные покупателя
            $order->customer = $request->customer;
            $order->save();
    
            DB::commit();
    
            return response()->json(['message' => 'Заказ обновлён успешно']);
    
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Ошибка обновления заказа'], 500);
        }
    }
    
    public function complete(Order $order)
    {
        if ($order->status !== 'active') {
            return response()->json(['error' => 'Можно завершить только активный заказ'], 400);
        }

        $order->status = 'completed';
        $order->completed_at = now();
        $order->save();

        return response()->json(['message' => 'Заказ завершён']);
    }

    public function cancel(Order $order)
    {
        if ($order->status !== 'active') {
            return response()->json(['error' => 'Можно отменить только активный заказ'], 400);
        }

        DB::beginTransaction();

        try {
            foreach ($order->items as $item) {
                $stock = Stock::where('product_id', $item->product_id)
                            ->where('warehouse_id', $order->warehouse_id)
                            ->first();
                $stock->stock += $item->count;
                $stock->save();
            }

            $order->status = 'canceled';
            $order->completed_at = null;
            $order->save();

            DB::commit();

            return response()->json(['message' => 'Заказ отменён']);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Ошибка отмены заказа'], 500);
        }
    }


    public function resume(Order $order)
    {
        if ($order->status !== 'canceled') {
            return response()->json(['error' => 'Можно возобновить только отменённый заказ'], 400);
        }

        DB::beginTransaction();

        try {
            // Проверяем наличие товаров
            foreach ($order->items as $item) {
                $stock = Stock::where('product_id', $item->product_id)
                            ->where('warehouse_id', $order->warehouse_id)
                            ->first();

                if (!$stock || $stock->stock < $item->count) {
                    DB::rollBack();
                    return response()->json(['error' => 'Недостаточно товара на складе'], 400);
                }
            }

            // Списываем товары заново
            foreach ($order->items as $item) {
                $stock = Stock::where('product_id', $item->product_id)
                            ->where('warehouse_id', $order->warehouse_id)
                            ->first();
                $stock->stock -= $item->count;
                $stock->save();
            }

            $order->status = 'active';
            $order->completed_at = null;
            $order->save();

            DB::commit();

            return response()->json(['message' => 'Заказ возобновлён']);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Ошибка возобновления заказа'], 500);
        }
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Order $order)
    {
        //
    }
}

