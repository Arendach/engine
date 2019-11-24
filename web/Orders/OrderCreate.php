<?php

namespace Web\Orders;

use RedBeanPHP\OODBBean;
use RedBeanPHP\R;
use Web\Model\Reports;
use stdClass;

class OrderCreate extends Order
{
    /**
     * @var OODBBean
     */
    private $order;

    /**
     * @var stdClass
     */
    private $products;

    /**
     * @param stdClass $data
     * @param stdClass $products
     * @param stdClass $return_shipping
     * @return int
     */
    public function sending(stdClass $data, stdClass $products, stdClass $return_shipping): int
    {
        $this->products = $products;

        // створення початкових даних
        $this->createAbstractOrder($data);

        // привязка клієнта
        $this->attachClient();

        // предоплата замовлення
        $this->orderPrepayment();

        // додавання товарів до замовлення
        $this->attachProducts();

        // створення зворотньої доставки
        $this->returnShipping($return_shipping);

        // створюємо оригінал історії замовлення
        new OrderHistoryOriginal($data, $products, $this->order->id);

        return $this->order->id;
    }

    /**
     * @param stdClass $data
     * @param stdClass $products
     * @return int
     */
    public function delivery(stdClass $data, stdClass $products): int
    {
        $this->products = $products;

        // перетворення градації доставки
        $this->deliveryTimePrepare($data);

        // створення початкових даних
        $this->createAbstractOrder($data);

        // привязка клієнта
        $this->attachClient();

        // предоплата замовлення
        $this->orderPrepayment();

        // додавання товарів до замовлення
        $this->attachProducts();

        // створюємо оригінал історії замовлення
        new OrderHistoryOriginal($data, $products, $this->order->id);

        return $this->order->id;
    }

    /**
     * @param stdClass $data
     * @param stdClass $products
     * @return int
     */
    public function self(stdClass $data, stdClass $products): int
    {
        $this->products = $products;

        // створення початкових даних
        $this->createAbstractOrder($data);

        // привязка клієнта
        $this->attachClient();

        // предоплата замовлення
        $this->orderPrepayment();

        // додавання товарів до замовлення
        $this->attachProducts();

        // створюємо оригінал історії замовлення
        new OrderHistoryOriginal($data, $products, $this->order->id);

        return $this->order->id;
    }

    /**
     * @param stdClass $data
     * @param stdClass $products
     * @return int
     */
    public function shop(stdClass $data, stdClass $products): int
    {
        $this->products = $products;

        // створення початкових даних
        $this->createAbstractOrder($data);

        // додавання товарів до замовлення
        $this->attachProducts();

        // створюємо оригінал історії замовлення
        new OrderHistoryOriginal($data, $products, $this->order->id);

        return $this->order->id;
    }

    /**
     * @param stdClass $data
     * @return void
     */
    private function createAbstractOrder(stdClass $data): void
    {
        $order = R::dispense('orders');

        foreach ($data as $k => $v)
            $order->$k = trim($v);

        $order->date = date('Y-m-d H:i:s');
        $order->author = user()->id;

        $id = R::store($order);

        $this->order = R::load('orders', $id);
    }

    /**
     * Звязати замовлення з постійним клієнтом
     * @return void
     */
    private function attachClient(): void
    {
        if (!isset($_POST['client_id'])) return;

        $bean = R::xdispense('client_orders');
        $bean->client_id = $_POST['client_id'];
        $bean->order_id = $this->order->id;
        R::store($bean);
    }

    /**
     * Предоплата замовлення
     * @return void
     */
    private function orderPrepayment(): void
    {
        if ($this->order->prepayment <= 0) return;

        Reports::createOrderPrepayment($this->order->prepayment, $this->order->id);
    }

    /**
     * @param stdClass $products
     * @return void
     */
    private function attachProducts(): void
    {
        $sum = 0;
        foreach ($this->products as $product) {
            $history = [
                'order_id' => $this->order->id,
                'amount' => $product->amount,
                'price' => $product->price
            ];

            $this->historyProduct('add_to_order', $history, $product->id);

            $this->takeProductFromWarehouse($product);

            $this->attachProduct($product);

            $sum += $product->amount * $product->price;
        }

        $this->setOrderSum((float)$sum);
    }

    /**
     * @param $product
     * @return void
     */
    private function attachProduct($product): void
    {
        // привязуємо товар до замовлення і зберігаємо
        $pto = R::xdispense('product_to_order');
        $pto->order_id = $this->order->id;
        $pto->product_id = $product->id;
        $pto->attributes = isset($product->attributes) ? json($product->attributes) : '{}';
        $pto->amount = $product->amount;
        $pto->price = $product->price;
        $pto->place = isset($product->place) ? $product->place : 1;
        $pto->storage_id = $product->storage;
        R::store($pto);
    }

    /**
     * установка суми замовлення
     * @param float $sum
     */
    private function setOrderSum(float $sum): void
    {
        $this->order->full_sum = ($sum + $this->order->delivery_cost - $this->order->discount);

        R::store($this->order);
    }

    /** Списання товару з складу
     * @param $product
     * @return void
     */
    private function takeProductFromWarehouse($product): void
    {
        $bean = R::load('products', $product->id);

        // якщо товар комбінований
        if ($bean->combine) {

            // загружаємо аліаси компонентів
            $components = R::findAll('combine_product', 'product_id = ?', [$product->id]);

            foreach ($components as $component) {
                // загружаємо pts компонента
                $pts = $this->getPTS($component->linked_id, $product->storage);

                // віднімаємо з складу
                $pts->count -= $product->amount * $component->combine_minus;

                // додаємо до закупки якщо <= 2
                $this->createPurchase($pts, ($product->amount * $component->combine_minus));

                // зберігаємо
                R::store($pts);
            }
        } elseif (!$bean->combine && $bean->accounted) { // якщо товар одиничний і обіковий
            // загружаємо pts
            $pts = $this->getPTS($product->id, $product->storage);

            // віднімаємо з складу
            $pts->count -= $product->amount;

            // додаємо до закупки якщо <= 2
            $this->createPurchase($pts, $product->amount);

            // зберігаємо
            R::store($pts);
        }
    }

    /**
     * @param $data
     * @return void
     */
    private function returnShipping($data): void
    {
        // створення зворотньої доставки
        $rs = R::xdispense('return_shipping');

        foreach ($data as $key => $value)
            $rs->$key = $value;

        $rs->sum = $this->order->full_sum - $this->order->discount + $this->order->delivery_cost;
        $rs->order_id = $this->order->id;

        R::store($rs);
    }

    /**
     * @param $data
     * @return void
     */
    private function deliveryTimePrepare(&$data): void
    {
        if (isset($data->time_with))
            $data->time_with = time_to_string($data->time_with);

        if (isset($data->time_to))
            $data->time_to = time_to_string($data->time_to);
    }

}