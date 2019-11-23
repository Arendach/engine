<?php
/**
 * History Class Object
 */
$history = new History(with_json($item->data));

/**
 * Header
 */
echo $history->getHead($i, $item, 'Оновлено товар');
/**
 * Body
 */
echo "Товар: <a href='".uri('product', ['section' => 'update', 'id' => $history->data->product_id])."'>{$history->data->product_name}</a><br>";
echo $history->newBody('place');
echo $history->newBody('amount');
echo $history->newBody('price');

/**
 * Footer
 */
echo $history->getFoot();

?>