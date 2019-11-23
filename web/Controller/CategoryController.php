<?php

namespace Web\Controller;

use Web\Model\Category;
use Web\App\Controller;
use Web\Model\Coupon;
use Web\Tools\Categories;

class CategoryController extends Controller
{
    public $access = 'category';

    public function section_main()
    {
        $data = [
            'title' => 'Каталог :: Категорії товарів',
            'components' => ['modal'],
            'categories' => Category::getCategories(),
            'breadcrumbs' => [['Товари', uri('product')], ['Категорії']]
        ];

        $this->view->display('category.main', $data);
    }

    public function action_create_form()
    {
        $data = [
            'title' => 'Створити категорію',
            'categories' => Coupon::getCategories()
        ];

        $this->view->display('category.create_form', $data);
    }

    public function action_update_form($post)
    {
        $data = [
            'title' => 'Редагувати категорію',
            'categories' => Coupon::getCategories(),
            'category' => Category::getOne($post->id)
        ];

        $this->view->display('category.update_form', $data);
    }

    public function action_create($post)
    {
        Category::insert($post);

        Categories::clear_cache();

        response(200, 'Категорія вдало створена!');
    }

    public function action_update($post)
    {
        Category::update($post, $post->id);

        Categories::clear_cache();

        response(200, 'Категорія вдало відредагована!');
    }

    public function action_delete($data)
    {
        Category::delete_parent($data->id);

        Categories::clear_cache();

        response(200, 'Категорія вдало видалена!');
    }

    public function api_all()
    {
        echo Coupon::getCategories();
    }
}