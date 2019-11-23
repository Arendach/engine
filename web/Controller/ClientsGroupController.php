<?php

namespace Web\Controller;

use Web\Model\Clients;
use Web\App\Controller;

class ClientsGroupController extends Controller
{
    public $access = 'clients';

    public function section_main()
    {
        $data = [
            'title' => 'Групи клієнтів',
            'groups' => Clients::getAll('clients_group'),
            'components' => ['modal'],
            'breadcrumbs' => [
                ['Постійні клієнти', uri('clients')],
                ['Групи постійних клієнтів']
            ]
        ];

        $this->view->display('clients.groups.main', $data);
    }

    public function action_create($data)
    {
        Clients::insert($data,'clients_group');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_form($post)
    {
        $data = [
            'group' => Clients::getOne($post->id, 'clients_group'),
            'title' => 'Редагувати групу'
        ];

        echo $this->view->render('clients.forms.update_group', $data);
    }

    public function action_create_form()
    {
        echo $this->view->render('clients.forms.create_group', ['title' => 'Створити групу']);
    }

    public function action_update($post)
    {
        Clients::update($post, $post->id, 'clients_group');

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_delete($data)
    {
        Clients::delete($data->id, 'clients_group');

        response(200, DATA_SUCCESS_DELETED);
    }



}