<?php

$components = ['modal', 'inputmask'];

// $scripts = ['elements.js', 'orders/order.js', 'orders/update.js'];

$css = ['elements.css'];
/*
if ($type == 'sending')
    $scripts[] = 'orders/sending.js';

if ($type == 'delivery')
    $scripts[] = 'orders/delivery.js';*/

?>

<?php include parts('head') ?>

<!--    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">-->
    <link rel="stylesheet" href="/public/css/autocomplete.css">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="/js/orders/common.js"></script>
    <script src="/js/orders/update.js"></script>


    <ul class="nav nav-pills nav-justified">
        <li class="active"><a data-toggle="tab" href="#main">Основне</a></li>

        <li><a data-toggle="tab" href="#products_tab">Товари</a></li>

        <li><a data-toggle="tab" href="#sms">СМС розсилка</a></li>

        <li><a data-toggle="tab" href="#clients">Постійний клієнт</a></li>

        <?php if (can('bonuses') || $order->liable->id == user()->id) { ?>
            <li><a data-toggle="tab" href="#bonuses">Бонуси</a></li>
        <?php } ?>

        <?php if ($order->type == 'delivery' || $order->type == 'self') { ?>
            <li><a data-toggle="tab" href="#prof">Тип замовлення</a></li>
        <?php } ?>

        <li><a data-toggle="tab" href="#transactions">Оплата</a></li>

        <li><a data-toggle="tab" href="#photo">Файли</a></li>

    </ul>

    <hr>

    <div class="tab-content" style="margin-top: 15px;">
        <div id="main" class="tab-pane fade in active">
            <?php include t_file("buy.update.forms.$type") ?>
        </div>

        <div id="products_tab" class="tab-pane fade">
            <?php include t_file('buy.update.parts.products') ?>
        </div>

        <div id="sms" class="fade tab-pane">
            <?php // include t_file('buy.update.parts.sms') ?>
        </div>

        <?php if ($order->type != 'shop') { ?>
            <div id="clients" class="fade tab-pane">
                <?php // include t_file('buy.update.parts.clients') ?>
            </div>
        <?php } ?>

        <?php if (can('bonuses') || $order->liable == user()->id) { ?>
            <div id="bonuses" class="fade tab-pane">
                <?php // include t_file('buy.update.parts.bonuses'); ?>
            </div>
        <?php } ?>

        <?php if ($order->type == 'delivery' || $order->type == 'self') { ?>
            <div id="prof" class="fade tab-pane">
                <?php // include t_file('buy.update.parts.order_type'); ?>
            </div>
        <?php } ?>

        <div id="transactions" class="fade tab-pane">
            <?php //include t_file('buy.update.parts.transactions'); ?>
        </div>

        <div id="photo" class="fade tab-pane">
            <?php //include t_file('buy.update.parts.photo'); ?>
        </div>
    </div>

    <script>
        window.id = '<?= $id ?>';
        window.type = '<?= $order->type ?>';
        window.discount = '<?= $order->discount ?>';
        window.delivery_cost = '<?= $order->delivery_cost ?>';
        window.closed_order = '<?= $closed_order ?>';
    </script>

<?php include parts('foot') ?>