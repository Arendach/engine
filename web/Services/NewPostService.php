<?php

namespace Web\Services;

use Web\Eloquent\Order;
use Web\Model\Api\NewPost;
use DiDom\Document;

class NewPostService
{
    // Получаємо назву міста по Ref Нової пошти
    public function getWarehouseName(string $city, string $warehouse): array
    {
        $new_post = new NewPost();

        return $new_post->get_address($city, $warehouse);
    }

    public function getMarker(Order $order)
    {
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
}