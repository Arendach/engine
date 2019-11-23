<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Model\Category;
use Web\Model\Coupon;
use Web\Model\Inventory;

class InventoryController extends Controller
{
    public $access = 'inventory';

    public function section_main()
    {
        $data = [
            'title' => 'Інвентаризація',
            'breadcrumbs' => [['Інвентаризація']],
            'items' => Inventory::getItems()
        ];

        $this->view->display('inventory.view', $data);
    }

    public function section_print()
    {
        if (!get('id')) $this->display_404();

        $data = [
            'data' => Inventory::getData(get('id')),
            'products' => Inventory::getProducts(get('id'))
        ];

        $this->view->display('inventory.print', $data);
    }

    public function section_create()
    {
        $data = [
            'scripts' => ['inventory.js'],
            'title' => 'Інвентаризація',
            'manufacturers' => Inventory::getAll("manufacturers"),
            'storage' => Inventory::findAll('storage', 'accounted = 1'),
            'breadcrumbs' => [['Інвентаризація', uri('inventory')], ['Нова']],
            'categories' => Coupon::getCategories()
        ];

        $this->view->display('inventory.create', $data);
    }


    public function action_get_products($post)
    {
        if (empty($post->manufacturer)) exit('');

        $this->view->display('inventory.get_products', [
            'products' => Inventory::findProducts($post->manufacturer, $post->storage, $post->category)
        ]);
    }

    public function action_create($post)
    {
        if (!isset($post->products) || my_count($post->products) == 0)
            response(400, 'Виберіть хоча-б один товар!');

        Inventory::create($post);

        response(200, [
            'action' => 'redirect',
            'message' => DATA_SUCCESS_CREATED,
            'uri' => uri('inventory')
        ]);
    }
}