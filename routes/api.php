<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Api\ProductController;

//Register
Route::post("register", [ApiController::class,"register"]);
//Login
Route::post("login", [ApiController::class,"login"]);


Route::group(['middleware' => ["auth:sanctum"]],function(){
    //profile
    Route::get("profile", [ApiController::class,"profile"]);
    //Logout
    Route::get("logout", [ApiController::class,"logout"]);
    //Product
    Route::get('products', [ProductController::class, 'index']);
    //Add to favorites
    Route::post('favorites/{productId}', [ProductController::class, 'addToFavorites']);
    //Removed from favorites
    Route::delete('favorites/{productId}', [ProductController::class, 'removeFromFavorites']);
    //show favorites
    Route::get('favorites', [ProductController::class, 'getFavorites']);
});

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');
