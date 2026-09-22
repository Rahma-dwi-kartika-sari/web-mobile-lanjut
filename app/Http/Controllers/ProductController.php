<?php

namespace App\Http\Controllers;

use App\Services\ProductService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class ProductController extends Controller
{
    private ProductService $productService;

    public function __construct(
        ProductService $productService
    ) {
        $this->productService = $productService;
    }

    public function index()
    {
        $products = $this->productService->getProducts();

        return response()->json([
            'data' => $products
        ]);
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:100',
                'price' => 'required|numeric|min:0'
            ]);

            return response()->json(
                [
                    'message' => 'Produk berhasil dibuat',
                    'data' => $validated
                ],
                201
            );
        } catch (\Exception $e) {
            Log::error(
                $e->getMessage()
            );

            return response()->json(
                [
                    'message' => 'Terjadi kesalahan pada server'
                ],
                500
            );
        }
    }
}