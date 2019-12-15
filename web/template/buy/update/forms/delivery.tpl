<?php include t_file('buy.update.elements') ?>

<div class="centered" style="background: #eee; padding: 15px; margin-bottom: 10px;">
    <a style="margin-right: 20px; color: #0a790f"
       data-type="ajax_request"
       data-uri="<?= uri('orders') ?>"
       data-action="change_type"
       data-post="<?= params(['id' => $id, 'type' => 'self']) ?>" href="#">
        <i class="fa fa-cog"></i> Змінити тип на Самовивіз
    </a>
    <a style="margin-right: 20px; color: #0a790f" target="_blank" href="<?= uri('orders/receipt', ['id' => $id]) ?>">
        <i class="fa fa-print"></i> Товарний чек
    </a>
    <a style="margin-right: 20px; color: #0a790f" target="_blank" href="<?= uri('orders/receipt', ['id' => $id, 'official' => 1]) ?>">
        <i class="fa fa-print"></i> Товарний чек для бугалетрії
    </a>
    <a target="_blank" style="margin-right: 20px; color: #0a790f" href="<?= uri('orders/invoice', ['id' => $id]) ?>">
        <i class="fa fa-print"></i> Рахунок-фактура
    </a>
    <a target="_blank" style="margin-right: 20px; color: #0a790f" href="<?= uri('orders/sales_invoice', ['id' => $id]) ?>">
        <i class="fa fa-print"></i> Видаткова накладна
    </a>
</div>

<hr>

<div class="form-horizontal">
    <div class="type_block">
        <form action="<?= uri('orders/update_status') ?>" data-type="update_order_status" data-toggle="validator">
            <input type="hidden" name="id" value="<?= $order->id ?>">
            <input type="hidden" name="old_status" value="<?= $order->status ?>">

            <?php element('status', ['type' => $type, 'status' => $order->status]); ?>
            <?php element('button'); ?>
        </form>
    </div>

    <hr>

    <?php if (htmlspecialchars($order->status) == 1 || htmlspecialchars($order->status) == 0) { ?>
        <div class="type_block">
            <form action="<?= uri('orders/update_contacts') ?>" data-type="ajax">
                <input type="hidden" name="id" value="<?= $order->id ?>">

                <?php element('fio', ['fio' => $order->fio]) ?>

                <?php element('phone', ['phone' => $order->phone]) ?>

                <?php element('phone2', ['phone2' => $order->phone2]) ?>

                <?php element('email', ['email' => $order->email]) ?>

                <?php element('button') ?>
            </form>
        </div>

        <hr>

        <div class="type_block">
            <form action="<?= uri('orders/update_working') ?>" data-type="ajax">

                <input type="hidden" name="id" value="<?= $order->id ?>">

                <?php element('hint', ['hint_id' => $order->hint_id, 'type' => $type]) ?>

                <?php element('date_delivery', ['date_delivery' => $order->date_delivery]) ?>

                <?php element('site', ['site' => $order->site]) ?>

                <?php element('time', ['time_with' => $order->time_with, 'time_to' => $order->time_to]) ?>

                <?php element('courier', ['courier_id' => $order->courier_id, 'status' => $order->status]) ?>

                <?php element('coupon', ['coupon' => $order->coupon]) ?>

                <?php element('comment', ['comment' => $order->comment]) ?>

                <?php element('button') ?>
            </form>
        </div>

        <hr>

        <div class="type_block">
            <form action="<?= uri('orders/update_delivery_address') ?>" data-type="ajax">
                <input type="hidden" name="id" value="<?= $order->id ?>">

                <?php element('city_delivery', ['city' => $order->city]); ?>

                <?php element('street', ['street' => $order->street]); ?>

                <?php element('address', ['address' => $order->address]); ?>

                <?php element('comment_address', ['comment_address' => $order->comment_address]); ?>

                <?php element('button'); ?>
            </form>
        </div>

    <?php } else { ?>
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