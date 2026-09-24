<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => Product::all()
        ]);
    }

    public function store(Request $request)
    {
        $product = Product::create($request->all());

        return response()->json([
            'data' => $product
        ], 201);
    }

    public function show(string $id)
    {
        return response()->json([
            'data' => Product::findOrFail($id)
        ]);
    }

    public function update(Request $request, string $id)
    {
        $product = Product::findOrFail($id);
        $product->update($request->all());

        return response()->json([
            'data' => $product
        ]);
    }

    public function destroy(string $id)
    {
        Product::findOrFail($id)->delete();

        return response()->json([
            'message' => 'Product deleted'
        ]);
    }
}