<?php include parts('head') ?>

    <!-- Tab-Navigation -->

    <ul class="nav nav-pills nav-justified">
        <li class="active"><a data-toggle="tab" href="#main">Основне</a></li>

        <?php if (($order->type == 'shop' && $order->status != 1) || ($order->type != 'shop' && $order->status != 2 && $order->status != 3 && $order->status != 4)) { ?>
            <li><a data-toggle="tab" href="#products_tab">Товари</a></li>
        <?php } ?>

        <li><a data-toggle="tab" href="#sms">СМС розсилка</a></li>

        <?php if ($order->type != 'shop') { ?>
            <li><a data-toggle="tab" href="#clients">Постійний клієнт</a></li>
        <?php } ?>

        <?php if (can('bonuses') || $order->liable == user()->id) { ?>
            <li><a data-toggle="tab" href="#bonuses">Бонуси</a></li>
        <?php } ?>

        <?php if ($order->type == 'delivery' || $order->type == 'self') { ?>
            <li><a data-toggle="tab" href="#prof">Тип замовлення</a></li>
        <?php } ?>

        <li><a data-toggle="tab" href="#transactions">Оплата</a></li>

        <li><a data-toggle="tab" href="#photo">Фото</a></li>

    </ul>

    <hr>

    <!-- Tab-Content -->

    <div class="tab-content" style="margin-top: 15px;">
        <div id="main" class="tab-pane fade in active">
            <?php include t_file("buy.update.forms.$type") ?>
        </div>
        <?php if (($order->type == 'shop' && $order->status != 1) || ($order->type != 'shop' && $order->status != 2 && $order->status != 3 && $order->status != 4)) { ?>
            <div id="products_tab" class="tab-pane fade">
                <?php include t_file('buy.update.parts.products') ?>
            </div>
        <?php } ?>

        <div id="sms" class="fade tab-pane">
            <?php include t_file('buy.update.parts.sms') ?>
        </div>

        <?php if ($order->type != 'shop') { ?>
            <div id="clients" class="fade tab-pane">
                <?php include t_file('buy.update.parts.clients') ?>
            </div>
        <?php } ?>

        <?php if (can('bonuses') || $order->liable == user()->id) { ?>
            <div id="bonuses" class="fade tab-pane">
                <?php include t_file('buy.update.parts.bonuses'); ?>
            </div>
        <?php } ?>

        <?php if ($order->type == 'delivery' || $order->type == 'self') { ?>
            <div id="prof" class="fade tab-pane">
                <?php include t_file('buy.update.parts.order_type'); ?>
            </div>
        <?php } ?>

        <div id="transactions" class="fade tab-pane">
            <?php include t_file('buy.update.parts.transactions'); ?>
        </div>

        <div id="photo" class="fade tab-pane">
            <?php include t_file('buy.update.parts.photo'); ?>
        </div>
    </div>

<?php include parts('foot') ?>