<?php include t_file('buy.update.elements') ?>

<div class="centered" style="background: #eee; padding: 15px; margin-bottom: 10px;">
    <a target="_blank" class="order-print-button" href="<?= uri('orders/receipt', ['id' => $id]) ?>">
        <i class="fa fa-print"></i> Товарний чек
    </a>
    <a class="order-print-button" target="_blank" href="<?= uri('orders/receipt', ['id' => $id, 'official' => 1]) ?>">
        <i class="fa fa-print"></i> Товарний чек для бугалетрії
    </a>
    <a target="_blank" class="order-print-button" href="<?= uri('orders/invoice', ['id' => $id]) ?>">
        <i class="fa fa-print"></i> Рахунок-фактура
    </a>
    <a target="_blank" class="order-print-button" href="<?= uri('orders/sales_invoice', ['id' => $id]) ?>">
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
        <form action="<?= uri('orders/update_status') ?>" data-type="update_order_status">

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
            <form action="<?= uri('orders/update_working') ?>" data-type="ajax">
                <input type="hidden" name="id" value="<?= $order->id ?>">
                <?php element('hint', ['hint_id' => $order->hint_id, 'type' => $type]) ?>
                <?php element('delivery', ['delivery' => $order->delivery]) ?>
                <?php element('date_delivery', ['date_delivery' => $order->date_delivery]) ?>
                <?php element('site', ['site' => $order->site]) ?>
                <?php element('courier', ['courier_id' => $order->courier_id, 'status' => $order->status]) ?>
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

                <?php if (htmlspecialchars($order->logistic_name) == 'НоваПошта') { ?>

                    <?php element('city_new_post', [
                        'city' => $order->city,
                        'warehouse' => $order->warehouse,
                        'city_name' => $order->city_name,
                        'warehouses' => $warehouses
                    ]) ?>

                <?php } else { ?>

                    <?php element('city_warehouse', ['city' => $order->city, 'warehouse' => $order->warehouse]) ?>

                <?php } ?>

                <?php element('address', ['address' => $order->address]) ?>

                <?php element('ttn', ['ttn' => $order->street]) ?>

                <?php element('button') ?>
            </form>

        </div>

        <div class="row right">
            <div class="col-md-4">
                <h4><b>Оплата доставки товару</b></h4>
            </div>
        </div>

        <div class="type_block">
            <form action="<?= uri('orders') ?>" data-type="ajax" data-pin_code="">

                <input type="hidden" name="action" value="update_pay">
                <input type="hidden" name="id" value="<?= $order->id ?>">
                <input type="hidden" name="type" value="<?= $order->type ?>">

                <?php element('form_delivery', ['form_delivery' => $order->form_delivery]) ?>

                <?php element('pay_delivery', ['pay_delivery' => $order->pay_delivery]) ?>

                <?php element('prepayment', ['prepayment' => $order->prepayment]) ?>

                <?php element('button') ?>

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
