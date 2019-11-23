<?php
/**
 * History Class Object
 */
$history = new History(json_decode($item->data));

/**
 * Header
 */
echo $history->getHead($i, $item, 'Оновлено адресу');

/**
 * Body
 */
echo $history->getHistory('city', 'Місто');
echo $history->getHistory('warehouse', 'Відділення');
echo $history->getHistory('address', 'Адреса');
echo $history->getHistory('region', 'Регіон');
echo $history->getHistory('street', 'Вулиця');

/**
 * Footer
 */
echo $history->getFoot();

?>