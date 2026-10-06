<?php

namespace App\Http\Controllers;

use App\Services\ProductService;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    protected ProductService $productService;

    public function __construct(ProductService $productService)
    {
        $this->productService = $productService;
    }

    public function index()
    {
        return response()->json([
            'data' => $this->productService->getAll()
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
        ]);

        $product = $this->productService->create($validated);

        return response()->json([
            'data' => $product
        ], 201);
    }

    public function show(string $id)
    {
        return response()->json([
            'data' => $this->productService->getById($id)
        ]);
    }

    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
        ]);

        $product = $this->productService->update($id, $validated);

        return response()->json([
            'data' => $product
        ]);
    }

    public function destroy(string $id)
    {
        $this->productService->delete($id);

        return response()->json([
            'message' => 'Product deleted'
        ]);
    }
}