<?php

namespace Web\Controller;

use SergeyNezbritskiy\PrivatBank\AuthorizedClient;
use SergeyNezbritskiy\PrivatBank\Merchant;
use Web\Model\Coupon;
use Web\Model\Orders;
use Web\App\Controller;
use Web\Model\OrderSettings;
use Web\Model\Products;
use Web\Model\Api\NewPost;
use Web\Model\Sms;
use Web\Model\Reports;
use RedBeanPHP\R;
use Web\Orders\OrderUpdate;

class OrdersController extends Controller
{
    public function __construct()
    {
        parent::__construct();

        $this->checkBlackDate();
    }

    private function checkBlackDate()
    {
        if (!post('date_delivery'))
            return;

        $filepath = ROOT . '/server/black_dates.txt';

        if (!file_exists($filepath))
            file_put_contents($filepath, null);

        $filecontent = file_get_contents($filepath);

        if (mb_strlen($filecontent) < 5) return;

        $black_dates = explode(',', $filecontent);

        $black_dates = array_map('trim', $black_dates);

        if (in_array(trim(post('date_delivery')), $black_dates))
            response(400, 'На цю дату неможливо завести замовлення!');
    }

    public function section_main()
    {
        // якщо тип не вказано то по дефолту доставки
        if (!get('type')) $_GET['type'] = 'delivery';


        $order = Orders::orderDataByType(get('type'));

        //$order = [];
        $full = 0;
        foreach ($order['data'] as $item)
            $full += $item['full_sum'];


        $data = [
            'title' => 'Замовлення :: ' . type_parse(get('type')),
            'scripts' => ['orders/view.js'],
            'full' => $full,
            'components' => ['inputmask'],
            'type' => get('type'),
            'css' => ['orders/common.css'],
            'data' => get_object($order['data']),
            'paginate' => $order['paginate'],
            'shops' => Orders::getAll('shops'),
            'breadcrumbs' => [['Замовлення', uri('orders', ['type' => 'delivery'])], [type_parse(get('type'))]]
        ];

        $this->view->display('buy.view.index', $data);
    }

    public function section_create()
    {
        if (!get('type')) get('type', 'delivery');

        $data = [
            'title' => 'Замовлення :: Нове замовлення',
            'scripts' => ['elements.js', 'orders/order.js', 'orders/create.js'],
            'components' => ['inputmask'],
            'css' => ['elements.css'],
            'categories' => Coupon::getCategories(),
            'type' => get('type'),
            'hints' => Orders::getHints(get('type')),
            'pays' => OrderSettings::getAll('pays'),
            'users' => OrderSettings::findAll('users', 'archive = 0'),
            'deliveries' => OrderSettings::getAll('logistics'),
            'to_js' => [
                'type' => get('type')
            ],
            'breadcrumbs' => [
                ['Замовлення', uri('orders', ['type' => 'delivery'])],
                [type_parse(get('type')), uri('orders', ['type' => get('type')])],
                ['Нове замовлення']
            ],
            'storage' => Orders::findAll('storage', '`accounted` = 1 ORDER BY `sort` ASC')
        ];

        if (get('type') == 'sending') {
            $data['scripts'][] = 'orders/sending.js';
        } elseif (get('type') == 'shop') {
            $data['address'] = 'Бориспільська 26 \'З\', магазин \'Повітряно\'';
        } elseif (get('type') == 'delivery') {
            $data['scripts'][] = 'orders/delivery.js';
        }

        $this->view->display('buy.create.main', $data);
    }

    public function section_update()
    {
        if (!get('id')) $this->display_404();

        $id = get('id');

        $order = Orders::getOrderById($id);

        $sms = Sms::getMessagesByOrderId($id);

        $data = [
            'title' => 'Замовлення :: Редагування',
            'components' => ['modal', 'inputmask'],
            'breadcrumbs' => [
                ['Замовлення', uri('orders', ['type' => 'delivery'])],
                [type_parse($order->type), uri('orders', ['type' => $order->type])],
                ['№<b>' . $order->id . '</b> - ' . user($order->author)->login]
            ],
            'scripts' => ['elements.js', 'orders/order.js', 'orders/update.js'],
            'css' => ['elements.css'],
            'id' => $id,
            'type' => $order->type,
            'products' => Orders::getProductsByOrderId($id),
            'order' => $order,
            'categories' => Coupon::getCategories(),
            'to_js' => [
                'id' => $id,
                'type' => $order->type,
                'discount' => $order->discount,
                'delivery_cost' => $order->delivery_cost,
                'closed_order' => Orders::count('reports', "`data` = ? AND `type` = 'order'", [$id])
            ],
            'sms_templates' => Sms::getAllByType($order->type),
            'sms' => $sms,
            'bonuses' => Orders::getBonuses($id),
            'images' => Orders::getImages($id),
            'storage' => Orders::findAll('storage', '`accounted` = 1  ORDER BY `sort` ASC'),
            'pay' => Orders::getOne($order->pay_method, 'pays')
        ];

        $add_transaction = false;

        $pay_method = OrderSettings::getOne($order->pay_method, 'pays');

        if ($pay_method->merchant_id != null) {
            $data['transactions'] = Orders::findAll('order_transaction', 'order_id = ?', [$order->id]);
            if (Orders::count('merchant', 'id = ?', [$pay_method->merchant_id])) {
                $add_transaction = true;
            }
        }
        $data['add_transaction'] = $add_transaction;

        if ($order->client != '') $order->client = Orders::getOne($order->client, 'clients');

        if ($order->type == 'sending') {
            if ($order->logistic_name == 'НоваПошта') {
                $new_post = new NewPost();
                $order->city_name = $new_post->getNameCityByRef($order->city);
                $data['warehouses'] = $new_post->search_warehouses($order->city);
                $data['return_shipping'] = Orders::get_return_shipping($data['id']);
                $data['cards'] = $new_post->get_cards();
            } else {
                $data['return_shipping'] = Orders::get_return_shipping($data['id']);
                $data['cards'] = [];
            }
            $data['scripts'][] = 'orders/sending.js';
        } elseif ($order->type == 'delivery') {
            $data['scripts'][] = 'orders/delivery.js';
        }

        $this->view->display('buy.update.main', $data);
    }

    public function action_create($post)
    {
        unset($post->storage);
        $arr = ['sending', 'delivery', 'self', 'shop'];
        if (isset($post->client_id)) unset($post->client_id);

        if ($post->type != 'shop')
            if (!preg_match('/[0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}/', $post->phone))
                response(400, 'Заповніть телефон в правильному форматі!');

        if (isset($post->date_delivery))
            if (strtotime($post->date_delivery) < strtotime(date('Y-m-d')))
                $post->date_delivery = date('Y-m-d');

        if (in_array($post->type, $arr)) {
            $m = "action_create_{$post->type}";
            $this->$m($post);
        } else response(400, 'Такого типу замовлень не існує!');
    }

    public function action_drop_product($post)
    {
        (new OrderUpdate($post->id))->dropProduct($post);

        response(200, ['action' => 'close', 'message' => 'Товар вдало видалений!']);
    }

    // Пошук товарів
    public function action_search_products($post)
    {
        $where = '';
        $return = '';
        if (isset($post->category_id))
            $where .= " `category` = '{$post->category_id}' ";
        elseif (isset($post->name))
            $where .= " `name` LIKE '%{$post->name}%' ";
        elseif (isset($post->services_code))
            $where .= " `services_code` LIKE '%{$post->services_code}%' ";

        $where = str_replace('\'`', '\', `', $where);

        foreach (Products::search($where, $post->storage) as $product) {
            if ($product['combine']) $c = 'n';
            else $c = $product['accounted'] ? $product['count_on_storage'] : 'n';

            $return .= "<div data-storage='{$product['storage_id']}' data-id='{$product['id']}' class='option'> ";
            $return .= $product['name'];
            $return .= " | ";
            $return .= "<span style='color: blue;'>";
            $return .= $c;
            $return .= "</span></div>\n";
        }
        echo $return;
    }

    // Вивод вибраних товарів при пошуку
    public function action_get_products($post)
    {
        $data = [
            'products' => get_object(Products::get_by_ids($post)),
            'type' => $post->type
        ];

        $this->view->display('buy.show_found_products', $data);
    }

    public function section_changes()
    {
        $order = Orders::getOne(get('id'));

        $data = [
            'order' => $order,
            'title' => 'Історія змін замовлення',
            'changes' => Orders::get_changes_by_id(get('id')),
            'id' => get('id'),
            'breadcrumbs' => [
                ['Замовлення', uri('orders', ['type' => 'delivery'])],
                [type_parse($order->type), uri('orders', ['type' => $order->type])],
                ['Замовлення #' . $order->id, uri('orders', ['section' => 'update', 'id' => $order->id])],
                ['Історія']
            ]
        ];

        // dd($data['changes']);

        $this->view->display('buy.changes.main', $data);
    }

    public function action_change_type($post)
    {
        Orders::change_type($post->type, $post->id);

        response(200, 'Тип замовлення вдало змінений!');
    }

    public function action_preview($post)
    {
        $data = [
            'products' => Orders::getProductsByOrderId($post->id),
            'order' => get_object(Orders::getOne($post->id))
        ];

        $this->view->display('orders.preview', $data);
    }

    public function action_create_user_bonus($post)
    {
        if ($post->sum <= 0) response('Сума не може бути меншою від нуля!');

        $post->date = date('Y-m-d H:i:s');

        Orders::create_user_bonus($post);

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_bonus_form($post)
    {
        $this->view->display('buy.update.parts.bonus_update_form',
            ['bonus' => Orders::getOne($post->id, 'bonuses')]);
    }

    public function action_update_bonus_sum($post)
    {
        $post->sum = $post->sum < 0 ? 0 : $post->sum;

        Orders::update_bonus_sum($post);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_delete_bonus($post)
    {
        Orders::delete_bonus($post);

        response(200, DATA_SUCCESS_DELETED);
    }

    public function action_update_order_type($post)
    {
        if ($post->atype != '' && $post->liable == '') response(400, 'Виберіть менеджера!');

        if (!isset($post->liable)) $post->liable = 0;

        if ($post->atype == '') {
            $post->atype = 0;
            $post->liable = 0;
        }

        Orders::update($post, $post->id);

        response(200, ['action' => 'close', 'message' => DATA_SUCCESS_UPDATED]);
    }

    ///////////////////////////////////////////////
    // Роздруковка                               //
    ///////////////////////////////////////////////
    public function section_route_list()
    {
        $ids = explode(':', get('ids'));
        $orders = Orders::findByIDS($ids, 'orders');

        foreach ($orders as $key => $item) {
            $id = $item->id;
            $orders[$id]->sum = Orders::getSum($item);
        }

        $this->view->display('orders.print.route_list', ['orders' => $orders]);
    }

    // Товарний чек
    public function section_receipt()
    {
        //header('Content-Type: text/plain');
        if (!get('id')) $this->display_404();
        $order = Orders::getOne(get('id'));

        $products = Orders::getProducts(get('id'));
        $data = [
            'order' => $order,
            'id' => get('id'),
            'type' => $order->type,
            'products' => $products->products,
            'sum' => $products->sum,
            'places' => $products->places
        ];

        if ($order->type == 'sending' && $order->street != '') {
            $address = 'https://my.novaposhta.ua/orders/printMarkings/orders[]/' . $order->street . '/type/html/apiKey/' . NEW_POST_KEY;

            $dom = new Document($address, true);

            $body = $dom->first('body');

            $imgs = $body->findInDocument('img');

            foreach ($imgs as $k => $img) {
                $attr = $img->attr('src');
                $body->findInDocument('img')[$k]->attr('src', 'http://my.novaposhta.ua' . $attr);
            }

            $markers = $body->findInDocument('.page-100-100');
            $data['marker'] = '';
            foreach ($markers as $marker) {
                $data['marker'] .= $marker->html();
            }
        }

        if ($order->type == 'delivery') {
            $data['street'] = parse_street($order->street);
        } elseif ($order->type == 'sending') {
            $data['order']['delivery_name'] = Orders::getDeliveryName($order->delivery);
            if ($data['order']['delivery_name'] == 'НоваПошта') {
                $new_post = new NewPost();
                $address = $new_post->get_address($order->city, $order->warehouse);
                $data['order']['city'] = $address['city'];
                $data['order']['warehouse'] = $address['warehouse'];
            }
            $data['pay'] = Orders::getPay(get('id'));
        }

        $this->view->display('orders.print.receipt', $data);
    }

    // Роздруковка рахунку фактури
    public function section_invoice()
    {
        if (!get('id')) $this->display_404();

        $order = Orders::getOne(get('id'));

        $pay = Orders::getOne($order->pay_method, 'pays');

        $data = [
            'id' => get('id'),
            'products' => Orders::getProducts(get('id'))->products,
            'order' => $order,
            'pay' => $pay
        ];

        $this->view->display('orders.print.invoice', $data);
    }

    // Роздруковка видаткової накладної
    public function section_sales_invoice()
    {
        if (!get('id')) $this->display_404();

        $order = Orders::getOne(get('id'));

        $pay = Orders::getOne($order->pay_method, 'pays');

        $data = [
            'id' => get('id'),
            'products' => Orders::getProducts(get('id'))->products,
            'order' => $order,
            'pay' => $pay
        ];

        $this->view->display('orders.print.sales_invoice', $data);
    }

    public function action_create_sending($post)
    {
        if (empty($post->fio))
            response(400, 'Заповніть імя!');

        if (empty($post->phone))
            response(400, 'Заповніть телефон!');

        if (empty($post->city))
            response(400, 'Заповніть місто!');

        if (empty($post->warehouse))
            response(400, 'Заповніть відділення!');

        if (!isset($post->products))
            response(400, 'Виберіть хоча-б один товар!');

        $return_shipping = $this->return_shipping_parse($post);
        $products = $post->products;
        unset($post->products);

        $id = Orders::createSending($post, $products, $return_shipping);

        response(200, [
            'action' => 'redirect',
            'uri' => uri('orders', ['section' => 'update', 'id' => $id]),
            'message' => 'Всі дані успішно збережено!'
        ]);
    }

    public function action_create_delivery($post)
    {
        if (empty($post->fio)) {
            response('400', 'Заповніть імя!');
        }

        if (empty($post->phone)) {
            response('400', 'Заповніть телефон!');
        }

        if (empty($post->city)) {
            response('400', 'Заповніть місто!');
        }

        if (!isset($post->products))
            response(400, 'Виберіть хоча-б один товар!');

        $products = $post->products;
        unset($post->products);

        $id = Orders::createDelivery($post, $products);

        response(200, [
            'action' => 'redirect',
            'uri' => uri('orders', ['section' => 'update', 'id' => $id]),
            'message' => 'Замовлення вдало створено!'
        ]);
    }

    public function action_create_self($post)
    {
        if (empty($post->fio)) {
            response('400', 'Заповніть імя!');
        }

        if (empty($post->phone)) {
            response('400', 'Заповніть телефон!');
        }

        if (!isset($post->products))
            response(400, 'Виберіть хоча-б один товар!');

        $products = $post->products;
        unset($post->products);

        $id = Orders::createSelf($post, $products);

        response(200, [
            'action' => 'redirect',
            'uri' => uri('orders', ['section' => 'update', 'id' => $id]),
            'message' => 'Замовлення вдало створено!'
        ]);
    }

    public function action_create_shop($post)
    {
        if (!isset($post->pay_method) || empty($post->pay_method))
            response(400, 'Виберіть варіант оплати');

        if (!isset($post->products))
            response(400, 'Виберіть хоча-б один товар!');

        $products = $post->products;
        unset($post->products);

        $id = Orders::createShop($post, $products);

        response(200, [
            'action' => 'redirect',
            'uri' => uri('orders', ['section' => 'update', 'id' => $id]),
            'message' => 'Замовлення вдало створено!'
        ]);
    }

    private function return_shipping_parse(&$data)
    {
        $temp = new \stdClass();

        foreach (OrderSettings::getSendingVariant($data->sending_variant)['params'] as $key => $value) {
            if (in_array($key, ['type', 'type_remittance', 'payer']))
                $temp->$key = $value;
            else
                $data->$key = $value;
        }

        return $temp;
    }

    public function action_update_shop($post)
    {
        if (empty($post->date_delivery)) response(400, 'Заповніть дату доставки!');

        Orders::update($post, $post->id);

        response(200, ['message' => DATA_SUCCESS_UPDATED, 'action' => 'close']);
    }

    // Оновлення інформації по зворотній доставці
    public function action_update_return_shipping($post)
    {
        Orders::update_return_shipping($post);

        response(200, DATA_SUCCESS_UPDATED);
    }

    // Оновлення контактної інформації
    public function action_update_contacts($post)
    {
        if (empty($post->fio)) response(400, 'Заповніть імя!');

        if (empty($post->phone)) response(400, 'Заповніть телефон!');

        (new OrderUpdate($post->id))->contacts($post);

        response(200, ['message' => 'Контакти вдало оновлені!', 'action' => 'close']);
    }

    // Оновлення службової інформації
    public function action_update_working($post)
    {
        if (isset($post->date_delivery) && empty($post->date_delivery))
            response(400, 'Заповніть дату доставки!');

        (new OrderUpdate($post->id))->working($post);

        response(200, ['action' => 'close', 'message' => DATA_SUCCESS_UPDATED]);
    }

    // Оновлення інформаціїї про адресу
    public function action_update_address($post)
    {
        if (isset($post->type) && $post->type == 'delivery') {
            if (empty($post->city)) response(400, 'Введіть назву міста!');
        }

        Orders::update_address($post);

        response(200, ['action' => 'close', 'message' => 'Адресу вдало змінено!']);
    }

    // Оновлення інформаціїї про оплату
    public function action_update_pay($post)
    {
        if ($post->type == 'delivery' || $post->type == 'self') {
            if (!isset($post->prepayment) || !is_numeric($post->prepayment))
                response(400, 'Введіть коректну суму предоплати!');
        }

        if ($post->type == 'sending')
            if (empty($post->pay_delivery))
                response(400, 'Заповніть платника доставки!');

        $post->prepayment = (integer)$post->prepayment;

        Orders::update_pay($post);

        response(200, ['action' => 'reload', 'message' => DATA_SUCCESS_UPDATED]);
    }

    // Оновлення товарів
    public function action_update_products($post)
    {
        Orders::update_products($post->products, $post->data, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_close_form($post)
    {
        $this->view->display('buy.update.close_form', [
            'order' => Orders::getOrderById($post->id),
            'title' => 'Закрити замовлення'
        ]);
    }

    public function action_close($post)
    {
        if (!R::count('reports', '`data` = ? AND `type` = ?', [$post->id, 'order'])) {
            $order = R::load('orders', $post->id);
            $status = $order->type == 'shop' ? '2' : '4';

            Reports::createOrder($post);
            Orders::update_status((object)['status' => $status, 'id' => $post->id]);

            response(200, 'Замовлення вдало закрито!');
        } else {
            response(400, 'Замовленя вже закрите!!! Оновіть сторінку!');
        }
    }

    public function action_update_status($post)
    {
        $order = R::load('orders', $post->id);

        if (($order->type == 'delivery' || $order->type == 'self') && $order->courier == 0)
            response(400, 'Для того щоб змінити статус виберіть курєра!');

        (new OrderUpdate($post->id))
            ->status($post->status);

        response(200, [
            'message' => 'Статус вдало оновлено!',
            'action' => 'close'
        ]);
    }

    public function action_update_courier($post)
    {
        (new OrderUpdate($post->id))->courier($post);

        response(200, ['action' => 'close', 'message' => DATA_SUCCESS_UPDATED]);
    }

    public function action_export($post)
    {
        if (!isset($post->ids) || empty($post->ids))
            response(400, 'Виберіть хоча б одне замовлення!');

        $success = 0;
        foreach ($post->ids as $id) {
            $success += Orders::export($id);
        }

        $count = my_count($post->ids);

        $response = "Вдало проекспортовано $success з $count замовлень!";

        if ($success < $count)
            $response .= '<br><a target="_blank" href="' . uri('log', ['section' => 'new_post']) . '">Переглянути логи!</a>';

        response(200, $response);
    }

    public function section_new_post_logs()
    {
        $content = file_get_contents(ROOT . '/server/logs/new_post.txt');

        $arr = explode(PHP_EOL, $content);

        foreach ($arr as $i => $item) {
            $arr[$i] = json_decode($item);
        }

        $data = [
            'title' => 'Логи помилок Нової пошти',
            'logs' => $arr
        ];

        $this->view->display('orders.new_post_logs', $data);
    }

    public function action_load_photo($post)
    {
        $file = $_FILES['0'];

        create_folder_if_not_exists('/server/uploads/orders/');

        $pi = pathinfo($file['name']);

        $new_name = '/server/uploads/orders/' . $post->id . rand32() . '.' . $pi['extension'];

        if (move_uploaded_file($file['tmp_name'], ROOT . $new_name)) {
            Orders::insert([
                'path' => $new_name,
                'order_id' => $post->id
            ], 'order_images');

            response(200, DATA_SUCCESS_CREATED);
        } else {
            response(500, 'Фото не завантажено!');
        }
    }

    public function action_delete_image($post)
    {
        $bean = R::load('order_images', $post->id);

        unlink(ROOT . $bean->path);

        R::trash($bean);

        response(200, DATA_SUCCESS_DELETED);
    }

    public function action_search_clients($post)
    {
        $str = '';

        $result = Orders::search_clients($post);
        foreach ($result as $item) {
            $str .= '<div data-phone="' . $item->phone . '" data-value="' . $item->id . '" class="client">' . $item->name . '</div>';
        }
        echo $str;
    }

    public function action_search_transaction($post)
    {
        $start = date('d.m.Y', time() - 60 * 60 * 24 * 30);
        $finish = date('d.m.Y');

        $order = Orders::getOne($post->id);
        $pay_method = Orders::getOne($order->pay_method, 'pays');
        $merchant_db = Orders::getOne($pay_method->merchant_id, 'merchant');
        $merchant_cards = Orders::findAll('merchant_card', 'merchant_id = ?', [$merchant_db->id]);

        // Авторизація клієнта
        $client = new AuthorizedClient();

        // Авторизація мерчанта
        $merchant = new Merchant($merchant_db->merchant_id, $merchant_db->password);

        $client->setMerchant($merchant);

        $temp = [];
        foreach ($merchant_cards as $card) {
            // запит на виписку по карті
            $result = $client->statements($card->number, $start, $finish);

            foreach ($result as $item) {
                // залишаємо тільки прибутки
                if ($item['cardamount'] > 0) {
                    if (!Orders::count('order_transaction', 'transaction_id = ?', [$item['appcode']]))
                        $temp[] = $item;
                }
            }
        }

        $data = [
            'title' => 'Додати транзакцію',
            'transactions' => $temp,
            'order_id' => $post->id,
            'modal_size' => 'lg'
        ];

        $this->view->display('buy.update.parts.transaction_add', $data);
    }

    public function action_add_transaction($post)
    {
        $temp = [];
        foreach ($post->transactions as $k => $item) {
            parse_str($item, $temp[$k]);

            Orders::insert($temp[$k], 'order_transaction');
        }

        response(200, 'Транзакції вдало привязані!');
    }

    public function action_delete_transaction($post)
    {
        Orders::delete($post->id, 'order_transaction');

        response(200, 'Транзакція вдало видалена!');
    }

}