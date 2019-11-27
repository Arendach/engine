<?php include t_file('buy.update.elements') ?>

<div class="centered" style="background: #eee; padding: 15px; margin-bottom: 10px;">
    <a style="margin-right: 20px; color: #0a790f"
       data-type="ajax_request"
       data-uri="<?= uri('orders') ?>"
       data-action="change_type"
       data-post="<?= params(['id' => $id, 'type' => 'self']) ?>" href="#">
        <i class="fa fa-cog"></i> Змінити тип на Самовивіз
    </a>
    <a style="margin-right: 20px; color: #0a790f" target="_blank"
       href="<?= uri('orders', ['section' => 'receipt', 'id' => $id]) ?>">
        <i class="fa fa-print"></i> Товарний чек
    </a>
    <a style="margin-right: 20px; color: #0a790f" target="_blank"
       href="<?= uri('orders', ['section' => 'receipt', 'id' => $id, 'official' => 1]) ?>">
        <i class="fa fa-print"></i> Товарний чек для бугалетрії
    </a>
    <a target="_blank"
       style="margin-right: 20px; color: #0a790f" href="<?= uri('orders', ['section' => 'invoice', 'id' => $id]) ?>">
        <i class="fa fa-print"></i> Рахунок-фактура
    </a>
    <a target="_blank"
       style="margin-right: 20px; color: #0a790f"
       href="<?= uri('orders', ['section' => 'sales_invoice', 'id' => $id]) ?>">
        <i class="fa fa-print"></i> Видаткова накладна
    </a>

</div>

<div class="form-horizontal">
    <div class="row right">
        <div class="col-md-4">
            <h4><b>Статус</b></h4>
        </div>
    </div>

    <div class="type_block">
        <form action="<?= uri('orders') ?>" data-type="update_order_status">

            <input type="hidden" name="id" value="<?= $order->id ?>">
            <input type="hidden" name="type" value="<?= $order->type ?>">
            <input type="hidden" name="old_status" value="<?= $order->status ?>">

            <?php element('status', ['type' => $type, 'status' => $order->status]); ?>
            <?php element('button'); ?>
        </form>
    </div>

    <?php if (htmlspecialchars($order->status) == 1 || htmlspecialchars($order->status) == 0) { ?>
        <div class="row right">
            <div class="col-md-4">
                <h4><b>Контакти</b></h4>
            </div>
        </div>

        <div class="type_block">
            <form action="<?= uri('orders') ?>" data-type="ajax">

                <input type="hidden" name="id" value="<?= $order->id ?>">
                <input type="hidden" name="action" value="update_contacts">

                <?php element('fio', ['fio' => $order->fio]) ?>

                <?php element('phone', ['phone' => $order->phone]) ?>

                <?php element('phone2', ['phone2' => $order->phone2]) ?>

                <?php element('email', ['email' => $order->email]) ?>

                <?php element('button') ?>
            </form>
        </div>

        <div class="row right">
            <div class="col-md-4">
                <h4><b>Загальні дані</b></h4>
            </div>
        </div>

        <div class="type_block">
            <form action="<?= uri('orders') ?>" data-type="ajax">

                <input type="hidden" name="id" value="<?= $order->id ?>">
                <input type="hidden" name="action" value="update_working">

                <?php element('hint', ['hint' => $order->hint, 'type' => $type]) ?>

                <?php element('date_delivery', ['date_delivery' => $order->date_delivery]) ?>

                <?php element('site', ['site' => $order->site]) ?>

                <?php element('time_with', ['time_with' => $order->time_with]) ?>

                <?php element('time_to', ['time_to' => $order->time_to]) ?>

                <?php element('courier', ['courier' => $order->courier, 'status' => $order->status]) ?>

                <?php element('coupon', ['coupon' => $order->coupon]) ?>

                <?php element('comment', ['comment' => $order->comment]) ?>

                <?php element('button') ?>
            </form>
        </div>

        <div class="row right">
            <div class="col-md-4">
                <h4><b>Адреса</b></h4>
            </div>
        </div>

        <div class="type_block">
            <form action="<?= uri('orders') ?>" data-type="ajax">

                <input type="hidden" name="id" value="<?= $order->id ?>">
                <input type="hidden" name="action" value="update_address">
                <input type="hidden" name="type" value="delivery">

                <?php element('city_delivery', ['city' => $order->city]); ?>

                <?php element('street', ['street' => $order->street]); ?>

                <?php element('address', ['address' => $order->address]); ?>

                <?php element('comment_address', ['comment_address' => $order->comment_address]); ?>

                <?php element('button'); ?>
            </form>
        </div>

    <?php } else { ?>
        <div class="row right">
            <div class="col-md-4">
                <h4><b>Купон</b></h4>
            </div>
        </div>

        <div class="type_block">
            <form action="<?= uri('orders') ?>" data-type="ajax">
                <input type="hidden" name="id" value="<?= $order->id ?>">
                <input type="hidden" name="action" value="update_working">

                <?php element('coupon', ['coupon' => $order->coupon]); ?>
                <?php element('button'); ?>
            </form>
        </div>
    <?php } ?>

</div>