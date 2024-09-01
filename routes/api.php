<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\CommentController;

//Register
Route::post("register", [ApiController::class,"register"]);
//Login
Route::post("login", [ApiController::class,"login"]);


Route::group(['middleware' => ["auth:sanctum"]],function(){
    //profile
    Route::get("profile", [ApiController::class,"profile"]);
    //Logout
    Route::post("logout", [ApiController::class,"logout"]);
    //Product
    Route::get('products', [ProductController::class, 'index']);
    //Add to favorites
    Route::post('favorites/{productId}', [ProductController::class, 'addToFavorites']);
    //Removed from favorites
    Route::delete('favorites/{productId}', [ProductController::class, 'removeFromFavorites']);
    //show favorites
    Route::get('favorites', [ProductController::class, 'getFavorites']);
    //search products
    Route::get('products/search', [ProductController::class, 'search']);
    //Get the comments on a specific product
    Route::post('comments', [CommentController::class, 'store']);
    //Add a comment on a specific product
    Route::get('comments/{productId}', [CommentController::class, 'index']);

});

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');
