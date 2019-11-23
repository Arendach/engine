<?php
/**
 * History Class Object
 */
$history = new History(with_json($item->data));

/**
 * Header
 */
echo $history->getHead($i, $item, 'Оновлено ціну');
/**
 * Body
 */
echo $history->newBody('discount');
echo $history->newBody('delivery_cost');
echo $history->newBody('full_sum');

/**
 * Footer
 */
echo $history->getFoot();

?>