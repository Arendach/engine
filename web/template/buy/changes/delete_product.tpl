<?php

$history = new History(json_decode($item->data));

echo $history->getHead($i, $item, 'Видалено товар');

?>

    <a href="<?= uri('product', ['section' => 'update', 'id' => $history->data->id]) ?>">
        <?= $history->data->name ?>
    </a>

<?php

echo $history->getFoot();

?>