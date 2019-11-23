<?php

$history = new History(json_decode($item->data));

?>

<?= $history->getHead($i, $item, 'Додано товар') ?>

<?php if (isset($history->data->id) && isset($history->data->name)) { ?>
    Товар: <a href="<?= uri('product', ['section' => 'update', 'id' => $history->data->id]) ?>">
        <?= $history->data->name ?>
    </a> <br>
<?php } ?>

<?php if (isset($history->data->amount)) { ?>
    Кількість: <?= $history->data->amount ?>
    <br>
<?php } ?>

<?= $history->getFoot() ?>