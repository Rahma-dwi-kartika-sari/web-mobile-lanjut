<?php

namespace App\Services;

use App\Models\Product;

class ProductService
{
    public function getAll()
    {
        return Product::all();
    }

    public function getById(string $id)
    {
        return Product::findOrFail($id);
    }

    public function create(array $data)
    {
        return Product::create($data);
    }

    public function update(string $id, array $data)
    {
        $product = Product::findOrFail($id);
        $product->update($data);

        return $product->fresh();
    }

    public function delete(string $id)
    {
        $product = Product::findOrFail($id);
        $product->delete();

        return $product;
    }
}