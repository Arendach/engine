<?php

$data = json_decode($item->data);
/**
 * History Class Object
 */
$history = new History($data);

/**
 * Header
 */
echo $history->getHead($i, $item, 'Оновлено робочу інформацію');

if (isset($data->coupon)) { ?>
    <div><span class="text-primary">Купон: </span><?= $data->coupon ?></div>
<?php } ?>

<?php if (isset($data->time_with)) { ?>
    <div><span class="text-primary">Час від:</span> <?= string_to_time($data->time_with) ?></div>
<?php } ?>

<?php if (isset($data->time_to)) { ?>
    <div><span class="text-primary">Час до:</span> <?= string_to_time($data->time_to) ?></div>
<?php } ?>

<?php if (isset($data->comment)) { ?>
    <div><span class="text-primary">Коментар:</span> <?= $data->comment ?></div>
<?php } ?>

<?php if (isset($data->courier)) { ?>
    <div><span class="text-primary">Курєр:</span> <?= $data->courier ?></div>
<?php } ?>

<?php if (isset($data->site)) { ?>
    <div><span class="text-primary">Сайт:</span> <?= $data->site ?></div>
<?php } ?>

<?php if (isset($data->hint)) { ?>
    <div><span class="text-primary">Підказка:</span> <?= $data->hint ?></div>
<?php } ?>

<?php if (isset($data->date_delivery)) { ?>
    <div><span class="text-primary">Дата доставки:</span> <?= $data->date_delivery ?></div>
<?php } ?>

<?php echo $history->getFoot();
