<?php

namespace App\Http\Controllers;

use App\Models\ProductMovement;
use Illuminate\Http\Request;

class ProductMovementController extends Controller
{
    public function index(Request $request)
    {
        // Строим запрос
        $query = ProductMovement::with(['product', 'warehouse']);

        // Фильтрация по складу
        if ($request->has('warehouse_id')) {
            $query->where('warehouse_id', $request->warehouse_id);
        }

        // Фильтрация по товару
        if ($request->has('product_id')) {
            $query->where('product_id', $request->product_id);
        }

        // Фильтрация по датам
        if ($request->has('start_date') && $request->has('end_date')) {
            $query->whereBetween('created_at', [$request->start_date, $request->end_date]);
        }

        // Пагинация
        $perPage = $request->input('per_page', 15); // По умолчанию 15 элементов на страницу
        $movements = $query->paginate($perPage);

        return response()->json($movements);
    }
}
