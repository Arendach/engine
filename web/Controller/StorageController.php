<?php

namespace Web\Controller;

use RedBeanPHP\R;
use Web\App\Controller;
use Web\Model\Storage;

class StorageController extends Controller
{
    public $access = 'storage';

    public function section_main()
    {
        $data = [
            'title' => 'Каталог :: Склади',
            'scripts' => ['storage.js', 'ckeditor/ckeditor.js'],
            'components' => ['modal', 'summer_note'],
            'storage' => Storage::getAll(),
            'breadcrumbs' => [['Склади']]
        ];

        $this->view->display('storage.main', $data);
    }

    public function action_form_create()
    {
        $this->view->display('storage.form_create', ['title' => 'Новий склад', 'modal_size' => 'lg']);
    }

    public function action_form_update($post)
    {
        $data = [
            'title' => 'Оновити склад',
            'storage' => Storage::getOne($post->id),
            'modal_size' => 'lg'
        ];

        $this->view->display('storage.form_update', $data);
    }

    public function action_delete($post)
    {
        Storage::delete($post->id);

        response(200, DATA_SUCCESS_DELETED);
    }

    public function action_create($post)
    {
        if (empty($post->name))
            response(400, 'Заповніть назву складу!');

        Storage::insert($post);

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update($post)
    {
        if (!isset($post->self)) $post->self = 0;
        if (!isset($post->delivery)) $post->delivery = 0;
        if (!isset($post->shop)) $post->shop = 0;
        if (!isset($post->sending)) $post->sending = 0;

        if (empty($post->name))
            response(400, 'Заповніть назву складу!');

        Storage::update($post, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function api_count_products($post)
    {
        $ids = implode("','", (array)$post->ids);

        $products = R::findAll('products', "`product_key` IN('$ids')");

        $result = [];
        foreach ($products as $product) {
            $pts = R::findAll('product_to_storage', 'product_id = ?', [$product->id]);

            $result[$product->product_key] = [];

            foreach ($pts as $pt) {
                $storage = R::load('storage', $pt->storage_id);

                $result[$product->product_key][] = [
                    'count' => $pt->count,
                    'name' => $storage->name,
                    'id' => $storage->id
                ];
            }
        }

        header('Content-Type: application/json');

        echo json($result);
    }
}

?>