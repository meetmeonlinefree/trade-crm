<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\WarehouseController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\ProductMovementController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('warehouses', [WarehouseController::class, 'index']);
Route::get('products-with-stocks', [ProductController::class, 'withStocks']);

Route::get('orders', [OrderController::class, 'index']);
Route::post('orders', [OrderController::class, 'store']);
Route::put('orders/{order}', [OrderController::class, 'update']);
Route::post('orders/{order}/complete', [OrderController::class, 'complete']);
Route::post('orders/{order}/cancel', [OrderController::class, 'cancel']);
Route::post('orders/{order}/resume', [OrderController::class, 'resume']);

Route::get('product-movements', [ProductMovementController::class, 'index']);
