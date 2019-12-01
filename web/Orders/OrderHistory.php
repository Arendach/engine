<?php

namespace Web\Orders;

use RedBeanPHP\OODBBean;
use RedBeanPHP\R;
use Web\Model\OrderSettings;
use stdClass;

class OrderHistory
{
    /**
     * @var OODBBean
     */
    private $order;

    /**
     * @var array|OODBBean
     */
    private $history;

    /**
     * OrderHistory constructor.
     * @param OODBBean $order
     */
    public function __construct(OODBBean $order)
    {
        $this->order = $order;
        $this->history = R::xdispense('changes');
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
     * @param stdClass $data
     * @return void
     */
    public function contacts(stdClass $data): void
    {
        $edited = $this->getEdited($data);

        if (!count($edited)) return;

        $this->save('update_contact', $edited);
    }

    /**
     * @param stdClass $data
     * @return void
     */
    public function working(stdClass $data): void
    {
        $history = [];

        $this->courierCheck($history, $data);

        $this->deliveryCheck($history, $data);

        $this->siteCheck($history, $data);

        $this->hintCheck($history, $data);

        $this->workingFieldsCheck($history, $data);

        $this->save('update_working', $history);
    }

    /**
     * @param OODBBean $product_id
     * @return void
     */
    public function dropProduct(OODBBean $product): void
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

    /**
     * @param array $history
     * @param stdClass $data
     */
    private function courierCheck(array &$history, stdClass $data): void
    {
        if (!isset($data->courier)) return;

        if ($this->order->courier == $data->courier) return;

        $old = $this->order->courier == 0 ? 'Не вибраний' : user($this->order->courier)->name;
        $new = $data->courier == 0 ? 'Не вибраний' : user($data->courier)->name;

        $history['courier'] = "<span><i class='text-info'>$old</i> => <i class='text-success'>$new</i></span>";
    }

    /**
     * Транспортна компанія
     * @param array $history
     * @param stdClass $data
     */
    private function deliveryCheck(array &$history, stdClass $data): void
    {
        if (!isset($dat->delivery)) return;

        if ($this->order->delivery == $data->delivery) return;

        $delivery = R::load('logistics', $data->delivery);
        $history['delivery'] = $delivery->name;
    }

    /**
     * Зміна сайту
     * @param array $history
     * @param stdClass $data
     * @return void
     */
    private function siteCheck(array &$history, stdClass $data): void
    {
        if (!isset($data->site)) return;

        if ($this->order->site == $data->site) return;

        $site = R::load('sites', $data->site);
        $history['site'] = $site->name;
    }

    /**
     * Підказка(кольоровий маркер)
     * @param array $history
     * @param stdClass $data
     * @return void
     */
    private function hintCheck(array &$history, stdClass $data): void
    {
        if (!isset($data->hint) || ($this->order->hint == $data->hint)) return;

        $hint = R::load('colors', $data->hint);
        $history['hint'] = '<span style="color: #' . $hint->color . '">' . $hint->description . '</span>';
    }

    /**
     * Дата доставки, коментар, купон, градація по часу доставки
     * @param array $history
     * @param stdClass $data
     * @return void
     */
    private function workingFieldsCheck(array &$history, stdClass $data): void
    {
        $fields = [
            'date_delivery',
            'comment',
            'coupon',
            'time_with',
            'time_to'
        ];

        foreach ($fields as $field) {
            if (!isset($data->{$field})) continue;

            if ($this->order->{$field} == $data->{$field}) continue;

            $history[$field] = $data->{$field};
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

        R::store($this->history);
    }

    /**
     * @param stdClass $data
     * @return array
     */
    private function getEdited(stdClass $data): array
    {
        $edited = [];
        foreach ($data as $field => $value)
            if ($this->order->{$field} != $value)
                $edited[$field] = $value;

        return $edited;
    }
}