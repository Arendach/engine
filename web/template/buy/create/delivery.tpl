<?php include t_file('buy.create.elements') ?>

<?php element('fio') ?>

<?php element('phone') ?>

<?php element('phone2') ?>

<?php element('email') ?>

    <hr>

<?php element('hint', ['hints' => $hints]) ?>

<?php element('date_delivery') ?>

<?php element('site') ?>

<?php element('time') ?>

<?php element('courier', ['users' => $users]) ?>

<?php element('coupon') ?>

<?php element('comment') ?>

    <hr>

<?php element('delivery_city') ?>

<?php element('street') ?>

<?php element('address') ?>

<?php element('comment_address') ?>

    <hr>

<?php element('pay_method', ['pays' => $pays]) ?>

<?php element('prepayment') ?>