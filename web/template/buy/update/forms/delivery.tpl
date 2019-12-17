<?php include t_file('buy.update.elements') ?>

<div class="order-update-actions">
    <a data-type="ajax_request"
       data-uri="<?= uri('orders/change_type') ?>"
       data-post="<?= params(['id' => $id, 'type' => 'self']) ?>"
       href="javascript:void(0)">
        <i class="fa fa-cog"></i> Змінити тип на Самовивіз
    </a>
    <a target="_blank" href="<?= uri('orders/receipt', ['id' => $id]) ?>">
        <i class="fa fa-print"></i> Товарний чек
    </a>
    <a target="_blank"
       href="<?= uri('orders/receipt', ['id' => $id, 'official' => 1]) ?>">
        <i class="fa fa-print"></i> Товарний чек для бугалетрії
    </a>
    <a target="_blank" href="<?= uri('orders/invoice', ['id' => $id]) ?>">
        <i class="fa fa-print"></i> Рахунок-фактура
    </a>
    <a target="_blank" href="<?= uri('orders/sales_invoice', ['id' => $id]) ?>">
        <i class="fa fa-print"></i> Видаткова накладна
    </a>
</div>

<hr>

<div class="form-horizontal">
    <form action="<?= uri('orders/update_status') ?>" data-type="update_order_status">
        <input type="hidden" name="old_status" value="<?= $order->status ?>">
        <?php element('id', $order) ?>
        <?php element('status', $order) ?>
        <?php element('button', $order) ?>
    </form>

    <hr>

    <form action="<?= uri('orders/update_contacts') ?>" data-type="ajax">
        <?php element('id', $order) ?>
        <?php element('fio', $order) ?>
        <?php element('phone', $order) ?>
        <?php element('phone2', $order) ?>
        <?php element('email', $order) ?>
        <?php element('button', $order) ?>
    </form>

    <hr>

    <form action="<?= uri('orders/update_working') ?>" data-type="ajax">
        <?php element('id', $order) ?>
        <?php element('hint', $order) ?>
        <?php element('date_delivery', $order) ?>
        <?php element('site', $order) ?>
        <?php element('time', $order) ?>
        <?php element('courier', $order) ?>
        <?php element('coupon', $order) ?>
        <?php element('comment', $order) ?>
        <?php element('button', $order) ?>
    </form>

    <hr>

    <form action="<?= uri('orders/update_delivery_address') ?>" data-type="ajax">
        <?php element('id', $order) ?>
        <?php element('city_delivery', $order) ?>
        <?php element('street', $order) ?>
        <?php element('address', $order) ?>
        <?php element('comment_address', $order) ?>
        <?php element('button', $order) ?>
    </form>
</div>
