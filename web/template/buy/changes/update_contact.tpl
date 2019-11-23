<?php
/**
 * History Class Object
 */
$history = new History(json_decode($item->data));

/**
 * Header
 */
echo $history->getHead($i, $item, 'Оновлено контактну інформацію');

/**
 * Body
 */
echo $history->getHistory('fio', 'Імя');
echo $history->getHistory('phone', 'Номер телефону');
echo $history->getHistory('phone2', 'Додатковий номер телефону');
echo $history->getHistory('email', 'Електронна пошта');

/**
 * Footer
 */
echo $history->getFoot();

?>