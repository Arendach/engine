<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Model\Clients;
use Web\Model\User;

class ClientsController extends Controller
{

    public $access = 'clients';

    public function section_main()
    {
        $data = [
            'title' => 'Продажі :: Постійні клієнти',
            'scripts' => ['ckeditor/ckeditor.js'],
            'components' => ['modal', 'jquery', 'inputmask'],
            'clients' => Clients::getClients(),
            'groups' => Clients::getAll('clients_group'),
            'breadcrumbs' => [
                ['Групи постійних клієнтів', uri('clients_group')],
                ['Постійні клієнти']
            ]
        ];
        $this->view->display('clients.main', $data);
    }

    public function action_add_order_form($post)
    {
        echo $this->view->render('clients.forms.add_order', [
            'title' => 'Привязка замовлень',
            'modal_size' => 'lg',
            'recommended' => Clients::getRecommendedOrders($post->client_id),
            'client_id' => $post->client_id
        ]);
    }

    public function action_create_form()
    {
        $data = [
            'groups' => Clients::getAll('clients_group'),
            'title' => 'Новий клієнт',
            'modal_size' => 'lg',
            'users' => User::findAll('users', 'archive = 0')
        ];

        echo $this->view->render('clients.forms.create_client', $data);
    }


    public function action_update_form($post)
    {
        $data = [
            'groups' => Clients::getAll('clients_group'),
            'client' => Clients::getClient($post->id),
            'users' => User::findAll('users', 'archive = 0'),
            'modal_size' => 'lg',
            'title' => 'Редагування клієнта'
        ];

        echo $this->view->render('clients.forms.update_client', $data);
    }

    public function action_create($data)
    {
        Clients::insert($data);

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update($post)
    {
        Clients::update($post, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_delete($post)
    {
        Clients::delete($post->id, 'clients');

        response(200, DATA_SUCCESS_DELETED);
    }

    public function section_client_orders()
    {
        if (!get('id')) $this->display_404();

        $data = [
            'title' => 'Замовлення клієнта',
            'orders' => Clients::getOrders(get('id')),
            'scripts' => ['clients/orders.js'],
            'components' => ['modal'],
            'client_id' => get('id'),
            'breadcrumbs' => [
                ['Групи постійних клієнтів', uri('clients_group')],
                ['Постійні клієнти', uri('clients')],
                ['Замовлення']
            ]
        ];

        $this->view->display('clients.orders', $data);
    }

    /**
     * Видалити замовлення від клієнта
     */
    public function order_remove($data)
    {
        Clients::order_remove($data);
    }

    /**
     * Пошук замовлень
     */
    public function action_search_orders($data)
    {
        $array = Clients::getOrdersByClient($data->client);
        $new_array = [];
        foreach ($array as $item)
            $new_array[] = $item['order_id'];
        $orders = Clients::search_order($data);
        $arr = [];
        foreach ($orders as $k => $item)
            if (!in_array($item->id, $new_array))
                $arr[$k] = $item;

        echo $this->view->render('clients.forms.search_result', ['data' => $arr]);
    }

    public function action_save_orders($post)
    {
        if (!isset($post->orders) || my_count($post->orders) == 0)
            response(400, 'Виберіть хоча-б одне замовлення!');

        Clients::save_orders($post);

        response(200, DATA_SUCCESS_CREATED);
    }

    /**
     * @param $post
     */
    public function action_search_clients($post)
    {
        $result = Clients::search_clients($post->name);

        if (my_count($result) > 0) {
            echo $this->view->render('clients.search', ['items' => $result]);
        } else {
            echo '';
        }
    }

    /**
     * @param $post
     */
    public function action_reset_client_to_order($post)
    {
        $res = Clients::exec('DELETE FROM `client_orders` WHERE `client_id` = ? AND `order_id` = ?', [$post->client_id, $post->order_id]);
        if ($res) response(200, 'Дані вдало збережено'); else response(500, 'Помилка!');
    }

    /**
     * @param $post
     */
    public function action_add_order_to_client($post)
    {
        Clients::exec('DELETE FROM `client_orders` WHERE `order_id` = ?', [$post->order_id]);
        Clients::insert($post, 'client_orders');

        response(200, 'Клієнт закріплений за замовленням!');
    }

}