<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\ProductRequest;
use Backpack\CRUD\app\Http\Controllers\CrudController;
use Backpack\CRUD\app\Library\CrudPanel\CrudPanelFacade as CRUD;

/**
 * Class ProductCrudController
 * @package App\Http\Controllers\Admin
 * @property-read \Backpack\CRUD\app\Library\CrudPanel\CrudPanel $crud
 */
class ProductCrudController extends CrudController
{
    use \Backpack\CRUD\app\Http\Controllers\Operations\ListOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\CreateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\UpdateOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\DeleteOperation;
    use \Backpack\CRUD\app\Http\Controllers\Operations\ShowOperation;

    /**
     * Configure the CrudPanel object. Apply settings to all operations.
     * 
     * @return void
     */
    public function setup()
    {
        CRUD::setModel(\App\Models\Product::class);
        CRUD::setRoute(config('backpack.base.route_prefix') . '/product');
        CRUD::setEntityNameStrings('product', 'products');
    }

    /**
     * Define what happens when the List operation is loaded.
     * 
     * @see  https://backpackforlaravel.com/docs/crud-operation-list-entries
     * @return void
     */
    protected function setupListOperation()
    {
        CRUD::setFromDb(); // set columns from db columns.

        /**
         * Columns can be defined using the fluent syntax:
         * - CRUD::column('price')->type('number');
         */
        CRUD::addColumn([
            'name' => 'quantity',
            'label' => 'Quantity',
            'type' => 'text',
        ]);

        // CRUD::addColumn([
        //     'name' => 'full_image2',
        //     'label' => 'Image 2',
        //     'type' => 'image',
        //     'prefix' => '',
        // ]);

        // CRUD::addColumn([
        //     'name' => 'full_image3',
        //     'label' => 'Image 3',
        //     'type' => 'image',
        //     'prefix' => '',
        // ]);

        // CRUD::addColumn([
        //     'name' => 'full_image4',
        //     'label' => 'Image 4',
        //     'type' => 'image',
        //     'prefix' => '',
        // ]);

        // CRUD::addColumn([
        //     'name' => 'full_image5',
        //     'label' => 'Image 5',
        //     'type' => 'image',
        //     'prefix' => '',
        // ]);
        
    }

    /**
     * Define what happens when the Create operation is loaded.
     * 
     * @see https://backpackforlaravel.com/docs/crud-operation-create
     * @return void
     */
    protected function setupCreateOperation()
    {
        CRUD::setValidation(ProductRequest::class);
        CRUD::setFromDb(); // set fields from db columns.
        CRUD::field('quantity')->type('text'); 
        CRUD::field('image1')->type('upload')->upload(true);
        CRUD::field('image2')->type('upload')->upload(true);
        CRUD::field('image3')->type('upload')->upload(true);
        CRUD::field('image4')->type('upload')->upload(true);
        CRUD::field('image5')->type('upload')->upload(true);
    }

    /**
     * Define what happens when the Update operation is loaded.
     * 
     * @see https://backpackforlaravel.com/docs/crud-operation-update
     * @return void
     */
    protected function setupUpdateOperation()
    {
        $this->setupCreateOperation();
    }
}
