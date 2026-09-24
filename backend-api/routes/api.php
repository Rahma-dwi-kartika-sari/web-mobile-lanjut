<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use App\Http\Middleware\RequestLogger;

Route::get(
    '/products',
    [ProductController::class, 'index']
)->middleware(RequestLogger::class);

Route::post(
    '/products',
    [ProductController::class, 'store']
);

Route::get(
    '/products/{id}',
    [ProductController::class, 'show']
);

Route::put(
    '/products/{id}',
    [ProductController::class, 'update']
);

Route::delete(
    '/products/{id}',
    [ProductController::class, 'destroy']
);