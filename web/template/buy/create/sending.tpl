<?php include t_file('buy.create.elements') ?>

<?php element('client_id') ?>
<?php element('fio') ?>
<?php element('phone') ?>
<?php element('email') ?>

    <hr>

<?php element('hint', ['hints' => $hints, 'type' => $type]) ?>
<?php element('delivery', ['deliveries' => $deliveries]) ?>
<?php element('date_delivery') ?>
<?php element('site') ?>
<?php element('courier', ['users' => $users]) ?>
<?php element('coupon') ?>
<?php element('comment') ?>

    <hr>

<?php element('sending_city') ?>
<?php element('address') ?>

    <hr>

<?php element('sending_variant') ?>
<?php element('prepayment') ?>