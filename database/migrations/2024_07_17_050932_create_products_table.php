<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('image1');
            $table->string('image2')->nullable;
            $table->string('image3')->nullable;
            $table->string('image4')->nullable;
            $table->string('image5')->nullable;
            $table->string('brand');
            $table->string('name');
            $table->decimal('popularity');
            $table->decimal('price');
            $table->longText('description');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
