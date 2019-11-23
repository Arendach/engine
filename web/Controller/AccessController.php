<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Model\Access;

class AccessController extends Controller
{
    public $access = 'access';

    public function section_main()
    {
        $data = [
            'title' => 'Менеджери :: Групи доступу',
            'groups' => Access::getAll(),
            'breadcrumbs' => [['Менеджери', uri('user')], ['Групи доступу']]
        ];

        $this->view->display('access.main', $data);
    }

    public function section_update()
    {
        if (!get('id')) $this->display_404();

        $data = [
            'title' => 'Менеджери :: Налаштування доступу',
            'group' => Access::getOne(get('id')),
            'access' => Access::get_access(get('id')),
            'breadcrumbs' => [
                ['Менеджери', uri('user')],
                ['Групи доступу', uri('access')],
                ['Редагування групи доступу']
            ]
        ];

        $this->view->display('access.update', $data);
    }

    public function action_update($post)
    {
        if ($post->name == '') response(400, 'Заповіть імя групи!');
        if ($post->description == '') response(400, 'Заповіть опис групи!');
        if (!isset($post->keys) || my_count($post->keys) == 0) response(400, 'Виберть ключі');

        $post->params = json_encode(get_array($post->keys));
        unset($post->keys);

        Access::update_group($post);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function section_create()
    {
        $data = [
            'title' => 'Менеджери :: Створення групи доступу',
            'access' => Access::get_all(),
            'breadcrumbs' => [
                ['Менеджери', uri('user')],
                ['Групи доступу', uri('access')],
                ['Створення групи доступу']
            ]
        ];

        $this->view->display('access.create', $data);
    }

    public function action_create($post)
    {
        if ($post->name == '') response(400, 'Заповніть назву групи!');
        if ($post->description == '') response(400, 'Заповніть опис групи!');
        if (!isset($post->keys) || my_count($post->keys) == 0) response(400, 'Виберіть ключі!');

        Access::access_group_create($post);

        response(200, 'Група доступу вдало створена!');
    }

    public function action_delete($post)
    {
        Access::group_delete($post);
    }

    public function section_test()
    {
        response(200);
    }
}