<?php
$history = new History($data);
echo $history->getHead($i, $item, 'Статус') . $item->data . $history->getFoot() ?>