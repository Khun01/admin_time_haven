<?php

namespace App\Models;

use Backpack\CRUD\app\Models\Traits\CrudTrait;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Product extends Model
{
    use CrudTrait;
    use HasFactory;

    protected $fillable = [
        'image1',
        'image2',
        'image3',
        'image4',
        'image5',
        'name',
        'brand',
        'name',
        'popularity',
        'price',
        'description',
        'quantity',
    ];

    protected static function boot()
    {
        parent::boot();

        static::saving(function ($product){
            $product->image1 = static::handleImageUpload(request(), 'image1', $product->image1);
            $product->image2 = static::handleImageUpload(request(), 'image2', $product->image2);
            $product->image3 = static::handleImageUpload(request(), 'image3', $product->image3);
            $product->image4 = static::handleImageUpload(request(), 'image4', $product->image4);
            $product->image5 = static::handleImageUpload(request(), 'image5', $product->image5);
        });
    }

    protected static function handleImageUpload($request, $fieldName, $currentValue)
    {
        if($request->hasFile($fieldName))
        {
            $image = $request->file($fieldName);
            $path = $image->store('public/products');
            return Storage::url($path);
        }

        return $currentValue;

    }

}

