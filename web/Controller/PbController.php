<?php

namespace Web\Controller;

use SergeyNezbritskiy\PrivatBank\Merchant;
use SergeyNezbritskiy\PrivatBank\AuthorizedClient;
use Web\App\Controller;
use Web\Model\OrderSettings;

class PbController extends Controller
{
    public $access = 'transaction';

    public function section_main()
    {
        $this->section_orders();
    }

    public function section_orders()
    {
        // якщо вибрано мерчанта і карту
        if (get('merchant') && get('card')) {

            // получаємо дані мерчанта з бази
            $merchant_db = OrderSettings::getOne(get('merchant'), 'merchant');

            // получаємо дані карти з бази
            $card_db = OrderSettings::getOne(get('card'), 'merchant_card');

            // визначаємо дату старту
            if (get('date_to')) $date_to = date('d.m.Y', strtotime(get('date_to')));
            else $date_to = date('d.m.Y', time() - 60 * 60 * 24 * 30);

            // визначаємо дату фінішу
            if (get('date_from')) $date_from = date('d.m.Y', strtotime(get('date_from')));
            else $date_from = date('d.m.Y');

            // Авторизація клієнта
            $client = new AuthorizedClient();

            // Авторизація мерчанта
            $merchant = new Merchant($merchant_db->merchant_id, $merchant_db->password);
            $client->setMerchant($merchant);

            // запит на виписку по карті
            $result = $client->statements($card_db->number, $date_to, $date_from);

            // фільтруємо витрати з картки
            // залишаємо тільки прибутки
            $temp = [];
            foreach ($result as $item) if ($item['cardamount'] > 0) $temp[] = $item;

            // загрузка карток мерчанта
            $cards = OrderSettings::findAll('merchant_card', 'merchant_id = ?', [$merchant_db->id]);
        } else {

            //якщо не вибрано мерчанта і карту то результат порожній
            $temp = [];

            $cards = [];
        }

        $data = [
            'title' => 'Транзакції',
            'items' => $temp,
            'breadcrumbs' => [
                ['Транзакції']
            ],
            'merchant' => OrderSettings::getAll('merchant'),
            'cards' => $cards
        ];

        $this->view->display('pb.orders', $data);
    }

    public function action_get_cards($post)
    {
        $cards = OrderSettings::findAll('merchant_card', 'merchant_id = ?', [$post->merchant]);

        if ($cards == null) response(500, 'У мерчанта немає жодної карточки!');

        $result = '<option value=""></option>';
        foreach ($cards as $item) {
            $result .= '<option value="%1">%2</option>';
            $result = str_replace('%1', $item->id, $result);
            $result = str_replace('%2', $item->number, $result);
        }

        echo $result;
    }

}