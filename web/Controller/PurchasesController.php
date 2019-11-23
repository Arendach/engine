<?php

namespace Web\Controller;

use RedBeanPHP\R;
use Web\App\Controller;
use Web\Model\Coupon;
use Web\Model\Manufacturers;
use Web\Model\Purchases;
use Web\Model\Reports;
use Web\Model\Storage;

class PurchasesController extends Controller
{
    public $access = 'purchases';

    public function section_main()
    {
        $items = Purchases::getAllPurchases();
        $sum = 0;
        foreach ($items as $item) $sum += $item->sum;

        $data = [
            'title' => 'Замовлення :: Закупки',
            'breadcrumbs' => [['Закупки']],
            'items' => $items,
            'sum' => $sum,
            'scripts' => ['purchases.js'],
            'manufacturers' => Purchases::getAll('manufacturers'),
            'storage' => Storage::findAll('storage', 'accounted = 1')
        ];

        $this->view->display('purchases.main', $data);
    }

    public function section_create()
    {
        $data = [
            'title' => 'Закупки :: Нова закупка',
            'manufacturers' => Purchases::getAll('manufacturers'),
            'scripts' => ['purchases.js'],
            'categories' => Coupon::getCategories(),
            'opened' => Purchases::getOpenPurchases(),
            'css' => ['purchases.css'],
            'storage' => Storage::findAll('storage', 'accounted = 1'),
            'breadcrumbs' => [
                ['Закупки', uri('purchases')],
                ['Нова закупка']
            ]
        ];

        if (get('storage')) {
            $s = Storage::getOne(get('storage'));
            $data['storage_name'] = $s->name;
        }
        if (get('manufacturer')){
            $m = Manufacturers::getOne(get('manufacturer'));
            $data['manufacturer_name'] = $m->name;
        }

        $this->view->display('purchases.create', $data);
    }

    public function section_update($get)
    {
        $purchases = Purchases::getOne($get->id);

        if ($purchases->id == 0) $this->display_404();

        if ($purchases->status == 2 && $purchases->type == 1) redirect(uri('purchases'));

        $data = [
            'title' => 'Закупки :: Редагування',
            'items' => Purchases::getProductsByPurchasesID($get->id),
            'components' => ['modal'],
            'scripts' => ['purchases.js'],
            'css' => ['purchases.css'],
            'categories' => Coupon::getCategories(),
            'purchases' => Purchases::getOne($get->id),
            'breadcrumbs' => [
                ['Закупки', uri('purchases')],
                ['Редагування']
            ],
            'payments' => Purchases::getPayments($get->id)
        ];

        $this->view->display('purchases.update', $data);
    }

    public function section_print()
    {
        $this->view->display('purchases.print', ['data' => Purchases::getToPrint(get('id'))]);
    }


    public function action_create($post)
    {
        if (!isset($post->products) || my_count($post->products) == 0)
            response(400, 'Виберіть хоча-б один товар!');

        if (!isset($post->manufacturer_id))
            response(400, 'Виберіть виробника!');

        if (!isset($post->storage_id))
            response(400, 'Виберіть склад!');

        $id = Purchases::create($post);

        response(200, [
            'message' => DATA_SUCCESS_CREATED,
            'action' => 'redirect',
            'uri' => uri('purchases')
        ]);
    }

    public function action_search_products($post)
    {
        if (!isset($post->manufacturer) || empty($post->manufacturer))
            response(400, 'Виберіть виробника!');
        if (!isset($post->field) || empty($post->field))
            response(400, 'Error!');
        if (!isset($post->data) || empty($post->data))
            response(400, 'Введіть дані!');

        $data = [
            'items' => Purchases::searchProducts($post)
        ];

        $this->view->display('purchases.products', $data);
    }

    public function action_update($post)
    {
        if (empty($post->products)) response(400, 'Виберіть хоча-б один товар!');

        $comment = isset($post->comment) ? $post->comment : '';

        Purchases::updateProducts($post->id, $post->products, $post->sum, $comment);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_update_type($post)
    {
        if ($post->type == 0) response(200, DATA_SUCCESS_UPDATED);

        Purchases::close($post->id);

        response(200, ['action' => 'redirect', 'uri' => uri('purchases'), 'message' => DATA_SUCCESS_UPDATED]);
    }

    public function action_get_products($post)
    {
        if (!isset($post->products) || empty($post->products))
            response('400', 'Виберіть хоча-б один товар!');

        $data = ['items' => Purchases::getProducts(get_array($post->products), $post->storage)];

        echo $this->view->render('purchases.get_products', $data);
    }

    public function action_payment_create_form($post)
    {
        $payments = Purchases::getPayments($post->id);

        $payed = 0;
        foreach ($payments as $item) $payed += $item->sum;


        $sum = Purchases::getOne($post->id);

        $sum = $sum->sum;

        $data = [
            'title' => 'Нова проплата',
            'sum' => $sum,
            'payed' => $payed,
            'id' => $post->id
        ];

        $this->view->display('purchases.forms.create_payment', $data);
    }

    public function action_payment_create($post)
    {
        $payments = Purchases::getPayments($post->id);

        $payed = 0;
        foreach ($payments as $item) $payed += $item->sum;

        $sum = Purchases::getOne($post->id);

        $sum = $sum->sum;

        if (($sum - $payed) - $post->sum < 0) response(400, 'Сума проплати перевищує суму всієї закупки!');

        Purchases::createPayment($post, ($sum - $payed) - $post->sum);

        Reports::createPurchasePayment($post);

        response(200, DATA_SUCCESS_CREATED);
    }
}