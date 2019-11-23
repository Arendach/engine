<?php

use Web\App\Model;

include t_file('buy.create.elements')

?>

<div class="row right">
    <div class="col-md-4">
        <h4><b>Контактна інформація</b></h4>
    </div>
</div>

<div class="type_block">
    <?php element('fio') ?>

    <?php element('phone') ?>

    <?php element('phone2') ?>

    <?php element('email') ?>
</div>


<div class="row right">
    <div class="col-md-4">
        <h4><b>Службова інформація</b></h4>
    </div>
</div>

<div class="type_block">

    <?php element('hint', ['hints' => $hints]) ?>

    <?php element('date_delivery') ?>

    <?php element('site') ?>

    <?php element('time_with') ?>

    <?php element('time_to') ?>

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

    <?php element('warehouse') ?>

</div>

<div class="row right">
    <div class="col-md-4">
        <h4><b>Оплата</b></h4>
    </div>
</div>

<div class="type_block">

    <?php element('pay_method', ['pays' => $pays]) ?>

    <?php element('prepayment') ?>

</div>