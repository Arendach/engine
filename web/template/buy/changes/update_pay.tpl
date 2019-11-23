<?php

$data = json_decode($item->data);
/**
 * History Class Object
 */
$history = new History($data);

/**
 * Header
 */
echo $history->getHead($i, $item, 'Оновлено інформацію про оплату');

/**
 * Body
 */
$form_delivery = isset($data->form_delivery ) && $data->form_delivery == 'imposed' ? 'Наложений платіж' : 'Безготівкова';
$imposed = isset($data->imposed ) && $data->imposed == 'sender' ? 'Відправник' : 'Отримувач';
$pay_delivery = isset($data->pay_delivery ) && $data->pay_delivery == 'sender' ? 'Відправник' : 'Отримувач';
$payment_status = isset($data->payment_status ) && $data->payment_status == 1 ? 'Оплачено' : 'Не оплачено';

echo $history->getHistoryKV('form_delivery', 'Форма оплати', $form_delivery);
echo $history->getHistory('pay_method', 'Спосіб оплати');
echo $history->getHistoryKV('imposed', 'Наложений платіж оплчує', $imposed);
echo $history->getHistoryKV('pay_delivery', 'Доставку оплачує', $pay_delivery);
echo $history->getHistoryKV('payment_status', 'Статус оплати', $payment_status);
echo $history->getHistory('prepayment', 'Предоплачено: %s грн');

/**
 * Footer
 */
echo $history->getFoot();

?>