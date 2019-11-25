<?php

namespace Web\Orders;

use RedBeanPHP\OODBBean;
use RedBeanPHP\R;
use stdClass;

class OrderUpdate extends Order
{
    /**
     * @var OrderHistory
     */
    private $history;

    /**
     * @var OODBBean
     */
    private $order;

    /**
     * OrderUpdate constructor.
     * @param $id
     */
    public function __construct(int $id)
    {
        $this->order = R::load('orders', $id);

        $this->history = new OrderHistory(clone $this->order);
    }

    /**
     * @param string $type
     */
    public function changeType(string $type): void
    {
        $this->order->type = $type;
        $this->save();

        $this->history->changeType($type);
    }

    /**
     * @param int $status
     * @return void
     */
    public function status(int $status): void
    {
        $this->order->status = $status;

        // якщо статус відмінено або доставлено вертаєм товари на склад
        if ($status == 2 || $status == 3)
            $this->returnProducts();

        $this->save();

        $this->history->status($status);
    }

    // Оновлення контактів
    public function contacts(stdClass $post)
    {
        foreach ($post as $field => $value)
            $this->order->{$field} = trim($value);

        $this->save();

        $this->history->contacts($post);
    }

    /**
     * Оновлення загальної інформації
     * @param stdClass $data
     * @return void
     */
    public function working(stdClass $data): void
    {
        if (isset($data->time_with))
            $data->time_with = time_to_string($data->time_with);

        if (isset($data->time_to))
            $data->time_to = time_to_string($data->time_to);

        $this->setFields($data);

        $this->save();

        $this->history->working($data);
    }

    /**
     * @return void
     */
    private function returnProducts(): void
    {
        // загружаємо всі товари замовлення
        $pto = R::findAll('product_to_order', '`order_id` = ?', [$this->order->id]);

        // перебираємо кожен товар замовлення
        foreach ($pto as $item) {

            // загружаємо безпосередньо сам товар
            $product = R::load('products', $item->product_id);

            // якщо товар обліковий і одиничний
            if ($product->accounted && !$product->combine) {
                $pts = $this->getPTS($item->product_id, $item->storage->id);
                $pts->count += $item->amount;
                R::store($pts);

                // якщо товар комбінований
            } else if ($product->combine) {

                // загружаємо всі компоненти товара
                $linked = R::findAll('combine_product', 'product_id = ?', [$item->product_id]);

                // перебираємо всі компоненти товару
                foreach ($linked as $component) {
                    $pts_c = $this->getPTS($component->linked_id, $item->storage_id);
                    $pts_c->count += $component->combine_minus * $item->amount;
                    R::store($pts_c);
                }
            }

            // обнуляємо кількість товару в замовленні
            $item->amount = 0;
            R::store($item);
        }
    }

    /**
     * @param stdClass $data
     * @return void
     */
    private function setFields(stdClass $data): void
    {
        foreach ($data as $field => $value)
            $this->order->{$field} = trim($value);
    }

    /**
     * @return void
     */
    private function save(): void
    {
        R::store($this->order);
    }
}