<?php


namespace Web\Controller;


use Web\App\Controller;
use Web\Model\Position;

class PositionController extends Controller
{
    public function section_main()
    {
        $data = [
            'positions' => Position::getAll(),
            'title' => 'Менеджери :: Посади',
            'components' => ['modal'],
            'scripts' => ['ckeditor/ckeditor.js'],
            'breadcrumbs' => [
                ['Менеджери', uri('user')],
                ['Посади']
            ]
        ];

        $this->view->display('positions.main', $data);
    }

    public function action_create_form()
    {
        $this->view->display('positions.create_form', [
            'title' => 'Нова посада',
            'modal_size' => 'lg',
        ]);
    }

    public function action_create($post)
    {
        if ($post->name == '') response(400, 'Введіть назву!');

        Position::insert($post);

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_form($post)
    {
        $this->view->display('positions.update_form', [
            'title' => 'Нова посада',
            'modal_size' => 'lg',
            'position' => Position::getOne($post->id)
        ]);
    }

    public function action_update($post)
    {
        if ($post->name == '') response(400, 'Введіть назву!');

        Position::update($post, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_delete($post)
    {
        Position::delete($post->id);

        response(200, DATA_SUCCESS_DELETED);
    }

}