<?php

namespace Web\Orders;

use RedBeanPHP\R;
use stdClass;
use Web\App\Collection;
use Web\App\Interfaces\Converter;
use Web\Eloquent\Order;
use Web\Eloquent\OrderProduct;
use Web\Eloquent\Product;
use Web\Eloquent\ProductStorage;
use Web\Orders\Order as Basic;

class OrderUpdate extends Basic implements Converter
{
    /**
     * @var OrderHistory
     */
    private $history;

    /**
     * @var Order
     */
    private $order;

    /**
     * OrderUpdate constructor.
     * @param $id
     */
    public function __construct(int $order_id)
    {
        $this->order = Order::findOrFail($order_id);

        $this->history = new OrderHistory(clone $this->order);
    }

    public function convert($order_id)
    {
        /*$this->order = R::load('orders', $order_id);

        $this->history = new OrderHistory(clone $this->order);*/
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
    public function courier(int $courier_id): void
    {
        $this->order->courier = $courier_id;

        $this->save();

        $this->history->courier($courier_id);
    }

    /**
     * Видалити товар з замовлення
     * @param $data
     * @return void
     */
    public function dropProduct(int $pivot_id): void
    {
        $pto = OrderProduct::findOrFail($pivot_id);

        // Змінюємо вартість замовлення
        $this->order->full_sum -= $pto->amount * $pto->price;
        $this->save();

        // повертаємо товар на склад
        $this->returnProduct($pto);

        // історія замовлення
        $this->history->dropProduct($pto->product);

        // історія товару
        (new ProductHistory($pto->product))
            ->drop($this->order->id);

        // Видаляємо товар з замовлення
        $pto->delete();
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
     * @param OrderProduct $pto
     */
    private function returnProduct(OrderProduct $pto): void
    {
        if ($pto->product->combine) { // якщо товар комбінований
            foreach ($pto->product->linked as $product) { // перебираємо кожен компонент
                if ($product->accounted) { // якщо компонент обліковується
                    $pts = $this->getPTS($product->pivot->linked_id, $pto->storage_id); // створюємо `pts` якщо немає
                    $pts->count += $pto->amount * $pto->combine_minus; // додаємо до кількості
                    $pts->save(); // зберігаємо
                }
            }
        } else {
            if ($pto->product->accounted) { // якщо товар обліковується
                $pts = $this->getPTS($pto->product->id, $pto->storage_id); // створюємо `pts` якщо немає
                $pts->count += $pto->amount; // додаємо до кількості
                $pts->save(); // зберігаємо
            }
        }
    }

    /**
     * @param array $products
     * @param Collection $data
     */
    public function products(array $products, Collection $data): void
    {
        $sum = 0;
        foreach ($products as $product) {
            !$product->pto ? $this->addProduct($product) : $this->updateProduct($product);
            $sum += $product->amount * $product->price;
        }

        $this->order->delivery_cost = $data->delivery_cost;
        $this->order->discount = $data->discount;
        $this->order->full_sum = $sum + $data->delivery_cost - $data->discount;
        $this->save();

        $data->full_sum = $this->order->full_sum;
        $this->history->sum($data);
    }

    /**
     * @param Collection $product
     */
    private function updateProduct(Collection $product): void
    {
        $pivot = OrderProduct::with('product')->find($product->pto);

        $order_history = new OrderHistory($this->order);

        $order_history->changeProduct($pivot, $product);

        // якщо кількість товару змінилась
        if ($pivot->product->amount != $product->amount) {

            // якщо товар комбінований
            if ($pivot->product->combine) {

                // перебираємо всі аліаси компонентів
                foreach ($pivot->product->linked as $component) {

                    // якщо компонент обліковується
                    if ($component->accounted) {

                        // Загружаємо аліас компонента на складі
                        $pts = $this->getPTS($component->id, $product->storage);

                        // Міняємо кількість товару на складі
                        $pts->count += ($pivot->amount - $product->amount) * $component->pivot->combine_minus;

                        // Створюємо закупку якщо товару менше 2 одиниць
                        $this->createPurchase($pts);

                        $pts->save();
                    }
                }
            } elseif (!$pivot->product->combine && $pivot->product->accounted) { // якщо товар одиничний і обліковий

                // Загружаємо `pts`
                $pts = $this->getPTS($product->id, $product->storage);

                // Змінюємо кількість на складі
                $pts->count += $pivot->amount - $product->amount;

                // створюємо закупку якщо товару менше 2х одиниць
                $this->createPurchase($pts); // create purchase if count on storage <= 2

                $pts->save();
            }
        }

        $pivot->amount = $product->amount;
        $pivot->price = $product->price;
        // $pivot->attributes = $product->attributes;
        $pivot->place = $product->place ?? $pivot->place;

        $pivot->save();
    }

    /**
     * @param array $product
     */
    private function addProduct(array $data): void
    {
        $pto = new OrderProduct;
        $pto->order_id = $this->order->id;
        $pto->product_id = $data['id'];
        $pto->attributes = isset($data['attributes']) ? json_encode($data['attributes']) : '{}';
        $pto->price = $data['price'];
        $pto->amount = $data['amount'];
        $pto->storage_id = $data['storage_id'];
        $pto->place = $data['place'] ?? 1;
        $pto->save();

        // загружаємо товар
        $product = Product::with('linked')->find($data['id']);

        if ($product->combine) { // Якщо товар комбінований
            foreach ($product->linked as $component) { // перебираємо кожен аліас
                if ($component->accounted) {// якщо компонент обліковується

                    // додаємо компонент на склад якщо його там немає і загружаємо
                    $pts = $this->getPTS($component->pivot->linked_id, $component->pivot->storage_id);

                    // віднімаємо з складу кількість
                    $pts->count -= $component->pivot->combine_minus * $data['amount'];

                    // якщо товару менше 2 то створюємо закупку
                    $this->createPurchase($pts);

                    // Зберігаємо кількість на складі
                    $pts->save();
                }
            }
        } elseif (!$product->combine && $product->accounted) { // якщо товар не комбінований і обліковий

            // Загружаєм аліас
            $alias = $this->getPTS($product->id, $data['storage']);

            // Віднімаємо зі складу кількість
            $alias->count -= $product->amount;

            // якщо товару менше 2 то створюємо закупку
            $this->createPurchase($alias);

            // зберігаємо кількість на складі
            $alias->save();
        }

        (new OrderHistory($this->order))
            ->addProduct(array_merge($data, ['name' => $product->name]));

        (new ProductHistory($product))
            ->addToOrder(array_merge($data, ['name' => $product->name]));

        // зберігаємо дані в історію замовлення(додано товар)
        $product->id = $product_id;
        $product->name = $bean->name;

        $storage = R::load('storage', $product->storage);
        $product->storage_name = $storage->name;
        self::save_changes_log('add_product', json($product), $order_id);

        // зберігаємо дані в історію товару(додано товар в замовлення)
        $product->order_id = $order_id;
        unset($product->name, $product->pto, $product->place);
        self::history_product('add_to_order', json($product), $product_id);
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
        $this->order->save();
    }
}