<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Model\Task;
use Web\Model\User;

class TaskController extends Controller
{
    public $access = 'task';

    public function section_list($get)
    {
        if (!get('user')) $this->display_404();

        $data = [
            'title' => 'Менеджер задач',
            'user' => User::getOne($get->user),
            'tasks' => Task::findByUser($get->user),
            'components' => ['modal'],
            'scripts' => ['ckeditor/ckeditor'],
            'breadcrumbs' => [
                ['Менеджери', uri('user')],
                [user(get('user'))->login, uri('user', ['section' => 'view', 'id' => get('user')])],
                ['Задачі']
            ]
        ];

        $this->view->display('task.list', $data);
    }


    public function action_create_form($post)
    {
        $data = [
            'title' => 'Створити задачу',
            'users' => Task::findAll('users', 'archive = 0'),
            'modal_size' => 'lg',
            'user_id' => $post->user_id
        ];

        $this->view->display('task.create_form', $data);
    }

    public function action_create($post)
    {
        if (!isset($post->content) || mb_strlen($post->content) < 10)
            response(400, 'Задача не може бити коротшою 10-ти символів');

        if (!User::exists($post->user, 'users'))
            response(400, 'Такого менеджера не існує!');

        $post->date = date('Y-m-d H:i:s');
        $post->success = 0;
        $post->comment = '';
        $post->author = user()->id;

        Task::insert($post);

        response(200, 'Задача вдало створена!');
    }


    public function action_update($post)
    {
        Task::update($post, $post->id);

        response(200, 'Задача вдало відредагована!');
    }

    public function action_update_form($post)
    {
        $data = [
            'task' => Task::getOne($post->id),
            'title' => 'Редагувати задачу',
            'modal_size' => 'lg'
        ];

        $this->view->display('task.update_form', $data);
    }


    public function action_close($post)
    {
        Task::update(['comment' => $post->comment, 'success' => $post->type == 'success' ? '1' : '2'], $post->id);

        response(200, 'Задача вдало закрита!');
    }

    public function action_close_form($post)
    {
        echo $this->view->render('task.close_form', ['id' => $post->id, 'type' => $post->type]);
    }


    public function action_delete($post)
    {
        Task::delete($post->id);

        response(200, 'Задача вдало видалена!');
    }


    public function action_approve_task($post)
    {
        Task::approve_task($post);
    }
}