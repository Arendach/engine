<?php

namespace Web\Controller;

use Web\Model\ManufacturersGroup;
use Web\App\Controller;

class ManufacturerGroupsController extends Controller
{
    public $access = 'manufacturer';

    public function section_main()
    {
        $data = [
            'title' => 'Каталог :: Групи виробників',
            'components' => ['modal', 'sweet_alert'],
            'breadcrumbs' => [['Виробники', uri('manufacturer')], ['Групи виробників']],
            'groups' => ManufacturersGroup::getAll()
        ];

        $this->view->display('manufacturer.groups.main', $data);
    }

    public function action_update_form($post)
    {
        $data = [
            'title' => 'Редагування групи',
            'group' => ManufacturersGroup::getOne($post->id)
        ];
        $this->view->display('manufacturer.groups.update_form', $data);
    }

    public function action_create_form()
    {
        $this->view->display('manufacturer.groups.create_form', ['title' => 'Нова група виробників']);
    }

    public function action_create($post)
    {
        if (empty($post->name))
            response(400, 'Запоніть імя!');

        ManufacturersGroup::insert($post);

        response(200, 'Група вдало створена!');
    }

    public function action_update($post)
    {
        if (empty($post->name))
            response(400, 'Заповніть імя!');

        ManufacturersGroup::update($post, $post->id);

        response(200, 'Дані вдало оновлені!');
    }

    public function action_delete($post)
    {
        ManufacturersGroup::delete($post->id);

        response(200, 'Дані вдало видалені!');
    }
}