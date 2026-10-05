<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use App\Http\Middleware\RequestLogger;
use App\Http\Controllers\AuthController;
use App\Http\Middleware\JwtMiddleware;
use App\Http\Middleware\AdminMiddleware;

Route::delete('/users/{id}', [AuthController::class, 'destroyUser'])
    ->middleware([
        JwtMiddleware::class,
        AdminMiddleware::class
    ]);

Route::post('/login', [AuthController::class, 'login']);

Route::get('/profile', [AuthController::class, 'profile'])
    ->middleware(JwtMiddleware::class);

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