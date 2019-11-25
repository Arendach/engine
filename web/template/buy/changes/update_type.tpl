<?php

$history = new History($data);

echo $history->getHead($i, $item, 'Тип замовлення');

echo $item->data;

echo $history->getFoot()

?>