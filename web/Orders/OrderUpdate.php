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
     * @param stdClass $data
     * @return void
     */
    public function courier(stdClass $data): void
    {
        $this->order->courier = $data->courier;

        $this->save();

        $this->history->courier($data);
    }

    /**
     * Видалити товар з замовлення
     * @param $data
     * @return void
     */
    public function dropProduct(stdClass $data): void
    {
        $pto = R::load('product_to_order', $data->pto);

        if (empty($pto)) return;

        // Змінюємо вартість замовлення
        $this->order->full_sum -= $pto->amount * $pto->price;
        $this->save();

        // загружаємо товар
        $product = R::load('products', $pto->product_id);

        // повертаємо товар на склад
        $this->returnProduct($product, $pto);

        // історія замовлення
        $this->history->dropProduct($product);

        // історія товару
        (new ProductHistory($product))->drop($this->order->id);

        // Видаляємо товар з замовлення
        R::trash($pto);
    }

    /**
     * @return void
     */
    private function returnProducts(): void
    {
        // загружаємо всі товари замовлення
        $pto = R::findAll('product_to_order', '`order_id` = ?', [$this->order->id]);

        foreach ($pto as $item) {
            // загружаємо безпосередньо сам товар
            $product = R::load('products', $item->product_id);

            // вертаєм товар на склад
            $this->returnProduct($product, $item);

            // обнуляємо кількість товару в замовленні
            $item->amount = 0;
            R::store($item);
        }
    }

    /**
     * @param OODBBean $product
     * @param OODBBean $product2order
     * @return void
     */
    private function returnProduct(OODBBean $product, OODBBean $product2order): void
    {
        // якщо товар комбінований
        if ($product->combine) {

            // загружаємо компоненти
            $linked = R::findAll('combine_product', 'product_id = ?', [$product->id]);

            // перебираємо кожен компонент
            foreach ($linked as $item) {

                // загружаємо безпосередньо сам компонент
                $component = R::load('products', $item->linked_id);

                // якщо компонент обліковується
                if ($component->accounted) {

                    // створюємо `pts` якщо немає
                    $pts = $this->getPTS($item->linked_id, $product2order->storage_id);

                    // додаємо до кількості
                    $pts->count += $product2order->amount * $item->combine_minus;

                    // зберігаємо
                    R::store($pts);
                }
            }
        } else {

            // якщо товар обліковується
            if ($product->accounted) {

                // створюємо `pts` якщо немає
                $pts = $this->getPTS($product->id, $product2order->storage_id);

                // додаємо до кількості
                $pts->count += $product2order->amount;

                // зберігаємо
                R::store($pts);
            }
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