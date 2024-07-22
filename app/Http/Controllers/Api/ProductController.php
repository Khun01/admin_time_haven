<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::all();
        return response()->json($products);
    }

    public function addToFavorites(Request $request, $productId)
    {
        $user = Auth::user();
        $product = Product::find($productId);

        if(!$product){
            return response()->json(['error' => 'Product not found'], 404);
        }

        $user->favorites()->attach($productId);
        return response()->json(['message' => 'Product added to favorites']);
    }

    public function removeFromFavorites(Request $request, $productId)
    {
        $user = Auth::user();
        $product = Product::find($productId);

        if(!$product){
            return response()->json(['error' => 'Product not found'], 404);
        }

        $user->favorites()->detach($productId);
        return response()->json(['message' => 'Product removed from favorites']);
    }

    public function getFavorites(Request $request)
    {
        $user = Auth::user();
        $favorites = $user->favorites;

        if($favorites->isEmpty())
        {
            return response()->json(['message' => 'You have no favorite products'], 404);
        }

        return response()->json($favorites);
    }
}
