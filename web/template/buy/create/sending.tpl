<?php include t_file('buy.create.elements') ?>

<div class="row right">
    <div class="col-md-4">
        <h4><b>Контактна інформація</b></h4>
    </div>
</div>

<div class="type_block">

    <?php element('fio') ?>

    <?php element('phone') ?>

    <?php element('email') ?>

</div>

<div class="row right">
    <div class="col-md-4">
        <h4><b>Службова інформація</b></h4>
    </div>
</div>

<div class="type_block">

    <?php element('hint', ['hints' => $hints, 'type' => $type]) ?>

    <?php element('delivery', ['deliveries' => $deliveries]) ?>

    <?php element('date_delivery') ?>

    <?php element('site') ?>

    <?php element('courier', ['users' => $users]) ?>

    <?php element('coupon') ?>

    <?php element('comment') ?>

</div>

<div class="row right">
    <div class="col-md-4">
        <h4><b>Адреса</b></h4>
    </div>
</div>

<div class="type_block">

    <?php element('sending_city') ?>

    <?php element('address') ?>

</div>

<div class="row right">
    <div class="col-md-4">
        <h4><b>Оплата доставки товару</b></h4>
    </div>
</div>

<div class="type_block">

   <!-- <?php /*element('form_delivery') */?>

    --><?php /*element('pay_delivery') */?>

    <?php element('sending_variant') ?>

    <?php element('prepayment') ?>

</div>
<!--
<div class="row right">
    <div class="col-md-4">
        <h4><b>Зворотня доставка</b></h4>
    </div>
</div>

<div class="type_block">
    <?php /*element('return_shipping', ['cards' => []]) */?>
</div>-->