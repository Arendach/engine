<?php
$history = new History($data);
echo $history->getHead($i, $item, 'Змінений курєр') . $item->data . $history->getFoot() ?>