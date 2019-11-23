<?php

namespace Web\Controller;

use RedBeanPHP\R;
use Web\App\Controller;
use Web\Model\Blacklist;

class BlacklistController extends Controller
{
    public function section_main()
    {
        $data = [
            'title' => 'Замовлення :: Чорний список',
            'breadcrumbs' => [['Замовлення', uri('orders')], ['Чорний список']],
            'components' => ['modal', 'inputmask'],
            'items' => Blacklist::getItems()
        ];

        $this->view->display('blacklist.main', $data);
    }

    public function action_create_form()
    {
        $this->view->display('blacklist.create_form', [
            'title' => 'Новий номер'
        ]);
    }

    public function action_create($post)
    {
        if ($post->name == '') response(400, 'Заповніть імя!');

        if (R::count('blacklist', 'phone = ? ', [$post->phone]))
            response(400, 'Такий телефон уже є в чорному списку!');

        Blacklist::insert($post);

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_form()
    {
        $this->view->display('blacklist.update_form', [
            'title' => 'Редагувати номер'
        ]);
    }

    public function action_update($post)
    {
        if ($post->name == '') response(400, 'Заповніть імя!');

        if (R::count('blacklist', 'id != ? AND phone = ? ', [$post->id, $post->phone]))
            response(400, 'Такий телефон уже є в чорному списку!');

        Blacklist::insert($post);

        response(200, DATA_SUCCESS_CREATED);
    }
}