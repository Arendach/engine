<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Eloquent\ClientOrder;
use Web\Eloquent\Order;

class NormController extends Controller
{
    public function sectionClients()
    {
        $orders = ClientOrder::all();

        foreach ($orders as $item) {
            $order = Order::find($item->order_id);
            $order->client_id = $item->client_id;
            $order->save();
        }
    }
}