<?php

namespace Web\Orders;

use RedBeanPHP\OODBBean;
use RedBeanPHP\R;
use Illuminate\Support\Collection;
use Web\Eloquent\Logistic;
use Web\Eloquent\OrderHint;
use Web\Eloquent\OrderProduct;
use Web\Eloquent\Product;
use Web\Eloquent\Site;
use Web\Model\OrderSettings;
use stdClass;
use Web\Eloquent\Order;
use Web\Eloquent\OrderHistory as OrderHistoryModel;

class OrderHistory
{
    /**
     * @var Order
     */
    private $order;

    /**
     * @var OrderHistoryModel
     */
    private $history;

    /**
     * OrderHistory constructor.
     * @param Order $order
     */
    public function __construct(Order $order)
    {
        $this->order = $order;
        $this->history = new OrderHistoryModel;
    }

    /**
     * @param string $type
     * @return void
     */
    public function changeType(string $type): void
    {
        $types = [
            'delivery' => 'Доставка',
            'self' => 'Самовивіз',
            'sending' => 'Відправка'
        ];

        $message = "Змінено тип з <b class='text-info'>{$types[$this->order->type]}</b> на <b class='text-success'>{$types[$type]}</b>";

        $this->save('update_type', $message);
    }

    /**
     * @param int $status
     * @return void
     */
    public function status(int $status): void
    {
        $statuses = OrderSettings::statuses($this->order->type);

        $new_status = $statuses[$status]->text;
        $old_status = $statuses[$this->order->status]->text;

        $message = "Оновлений статус: <b class='text-info'>$old_status</b> => <b class='text-success'>$new_status</b>";

        $this->save('update_status', $message);
    }

    /**
     * @param array $data
     * @return void
     */
    public function contacts(array $data): void
    {
        $edited = $this->getEdited($data);

        $this->save('update_contact', $edited);
    }

    /**
     * @param array $data
     * @return void
     */
    public function working(Collection $data): void
    {
        $history = [];

        $this->courierCheck($history, $data);

        $this->logisticCheck($history, $data);

        $this->siteCheck($history, $data);

        $this->hintCheck($history, $data);

        $this->workingFieldsCheck($history, $data);

        $this->save('update_working', $history);
    }

    /**
     * @param OODBBean $product_id
     * @return void
     */
    public function dropProduct(Product $product): void
    {
        $this->save('delete_product', ['id' => $product->id, 'name' => $product->name]);
    }

    /**
     * @param int $courier_id
     */
    public function courier(int $courier_id)
    {
        $history = [];

        $data = new stdClass;
        $data->courier = $courier_id;

        $this->courierCheck($history, $data);

        $this->save('update_courier', $history['courier'] ?? '');
    }

    public function sum(Collection $data)
    {
        $history = [];

        if ($this->order->discount != $data->discount)
            $history['discount'] = "Знижка <b style='color: red'>{$this->order->discount}</b> => <b style='color: blue'>$data->discount</b>";

        if ($this->order->delivery_cost != $data->delivery_cost)
            $history['delivery_cost'] = "Ціна доставки <b style='color: red'>{$this->order->delivery_cost}</b> => <b style='color: blue'>{$data->delivery_cost}</b>";

        if (count($history)) {
            $history->full_sum = "Сума <b style='color: red'>" . nf($this->order->full_sum) . "</b> => <b style='color: blue'>" . nf($data->full_sum + $data->delivery_cost - $data->discount) . "</b>";
            $this->save('update_price', $history);
        }
    }

    /**
     * @param OrderProduct $pivot
     * @param Collection $product
     */
    public function changeProduct(OrderProduct $pivot, Collection $product): void
    {
        $history = [];

        if ($pivot->amount != $product->amount)
            $history['amount'] = "Кількість <b style='color: red'>{$pivot->amount}</b> => <b style='color: blue;'>{$product->amount}</b>";

        if (isset($product->place) && $product->place != $pivot->place)
            $history['place'] = "Місце <b style='color: red'>{$pivot->place}</b> => <b style='color: blue'>{$product->place}</b>";

        if ($product->price != $pivot->price)
            $history['price'] = "Ціна <b style='color: red'>{$pivot->price}</b> => <b style='color: blue'>{$product->price}</b>";

        if (!count($history)) return;

        $this->save('update_product', array_merge($history, [
            'product_name' => $pivot->product->name,
            'product_id' => $pivot->product->id
        ]));

        $product_history = new ProductHistory($pivot->product);

        $product_history->updateInOrder(array_merge($history, [
            'order' => $this->order->id
        ]));
    }

    public function addProduct(array $data)
    {

    }

    /**
     * @param array $history
     * @param Collection $data
     */
    private function courierCheck(array &$history, Collection $data): void
    {
        if (!$data->has('courier_id')) return;

        if ($this->order->courier_id == $data->get('courier_id')) return;

        $old = $this->order->courier_id == 0 ? 'Не вибраний' : $this->order->courier->name;
        $new = $data->get('courier_id') == 0 ? 'Не вибраний' : user($data->get('courier_id'))->name;

        $history['courier'] = "<span><i class='text-info'>$old</i> => <i class='text-success'>$new</i></span>";
    }

    /**
     * Транспортна компанія
     * @param array $history
     * @param Collection $data
     */
    private function logisticCheck(array &$history, Collection $data): void
    {
        if (!$data->has('logistic_id')) return;

        if ($this->order->logistic_id == $data->logistic_id) return;

        $logistic = Logistic::find($data->logistic_id);
        $history['logistic'] = $logistic->name;
    }

    /**
     * Зміна сайту
     * @param array $history
     * @param Collection $data
     * @return void
     */
    private function siteCheck(array &$history, Collection $data): void
    {
        if ($data->has('site')) return;

        if ($this->order->site == $data->site) return;

        $site = Site::find($data->site);
        $history['site'] = $site->name;
    }

    /**
     * Підказка(кольоровий маркер)
     * @param array $history
     * @param Collection $data
     * @return void
     */
    private function hintCheck(array &$history, Collection $data): void
    {
        if (!$data->has('hint_id')) return;

        if ($this->order->hint_id == $data->get('hint_id')) return;

        $hint = OrderHint::find($data->get('hint_id'));

        $history['hint'] = '<span style="color: #' . $hint->color . '">' . $hint->description . '</span>';
    }

    /**
     * Дата доставки, коментар, купон, градація по часу доставки
     * @param array $history
     * @param Collection $data
     * @return void
     */
    private function workingFieldsCheck(array &$history, Collection $data): void
    {
        $fields = [
            'date_delivery',
            'comment',
            'coupon',
            'time_with',
            'time_to'
        ];

        foreach ($fields as $field) {
            if (!$data->has($field)) continue;

            if ($this->order->{$field} == $data->get($field)) continue;

            $history[$field] = $data->get($field);
        }
    }

    /**
     * @param string $type
     * @param array|string $data
     * @return void
     */
    private function save(string $type, $data): void
    {
        if (is_string($data) && mb_strlen($data) == 0) return;
        if (is_array($data) && count($data) == 0) return;

        if (is_array($data))
            $data = json_encode($data);

        $this->history->data = $data;
        $this->history->id_order = $this->order->id;
        $this->history->type = $type;
        $this->history->date = date('Y-m-d H:i:s');
        $this->history->author = user()->id;

        $this->history->save();
    }

    /**
     * @param array $data
     * @return array
     */
    private function getEdited(array $data): array
    {
        $edited = [];
        foreach ($data as $field => $value)
            if ($this->order->{$field} != $value)
                $edited[$field] = $value;

        return $edited;
    }
}