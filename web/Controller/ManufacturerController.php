<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Model\Manufacturers;
use Web\Model\ManufacturersGroup;

class ManufacturerController extends Controller
{
    public $access = 'manufacturer';

    public function section_main()
    {
        $data = [
            'title' => 'Каталог :: Виробники',
            'scripts' => ['ckeditor/ckeditor.js'],
            'components' => ['modal', 'inputmask'],
            'breadcrumbs' => [['Групи виробників', uri('manufacturer_groups')], ['Виробники']],
            'manufacturers' => Manufacturers::all()
        ];

        $this->view->display('manufacturer.main', $data);
    }


    public function action_create_form()
    {
        $data = [
            'title' => 'Додати виробника',
            'groups' => ManufacturersGroup::getAll(),
            'modal_size' => 'lg',
        ];

        $this->view->display('manufacturer.create_form', $data);
    }

    public function action_create($post)
    {
        if (empty($post->name))
            response(400, 'Заповніть назву правильно!');

        if (!filter_var($post->email, FILTER_VALIDATE_EMAIL))
            response(400, 'Заповніть E-Mail правильно!');

        if (empty($post->address))
            response(400, 'Заповніть адресу правильно!');

        Manufacturers::insert($post);

        response(200, 'Виробника вдало додано в базу даних!');
    }


    public function action_update_form($post)
    {
        $data = [
            'manufacturer' => Manufacturers::getOne($post->id),
            'title' => 'Редагування виробника',
            'groups' => ManufacturersGroup::getAll(),
            'id' => $post->id,
            'modal_size' => 'lg'
        ];

        $this->view->display('manufacturer.update_form', $data);
    }

    public function action_update($post)
    {
        if (empty($post->name))
            response(400, 'Заповніть назву правильно!');

        if (!filter_var($post->email, FILTER_VALIDATE_EMAIL))
            response(400, 'Заповніть E-Mail правильно!');

        if (empty($post->address))
            response(400, 'Заповніть адресу правильно!');

        Manufacturers::update($post, $post->id);

        response(200, 'Дані вдало оновлено!');
    }


    public function action_delete($post)
    {
        if (!is_numeric($post->id))
            response(400, 'Неправильні вхідні параметри!');

        Manufacturers::delete($post->id);

        response(200, 'Виробника вдало видалено з бази даних!');
    }


    public function action_print($post)
    {
        $data = [
            'section' => 'Виробники',
            'table' => get_object(Manufacturers::printManufacturer($post->ids))
        ];

        $this->view->display('manufacturer.print', $data);
    }

    public function api_test()
    {
        $array = [];
        $manufacturers = Manufacturers::getAll();
        foreach ($manufacturers as $item) {
            $array[] = [
                'id' => $item->id,
                'name_uk' => $item->name,
                'name_ru' => $item->name_ru,
                'photo_uk' => $item->photo_uk,
                'photo_ru' => $item->photo_ru,
            ];
        }

        echo \GuzzleHttp\json_encode($array);
    }
}