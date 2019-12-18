<?php include t_file('buy.create.elements') ?>

<?php element('client_id') ?>
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

<?php element('warehouse') ?>

<hr>

<?php element('pay_method', ['pays' => $pays]) ?>
<?php element('prepayment') ?>

