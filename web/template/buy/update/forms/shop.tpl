<?php

use Web\App\Model;

include t_file('buy.update.elements');
?>

<div class="centered" style="background: #eee; padding: 15px; margin-bottom: 10px;">
    <a style="margin-right: 20px; color: #0a790f" target="_blank"
       href="<?= uri('orders', ['id' => $id, 'section' => 'invoice']); ?>">
        <i class="fa fa-print"></i> Рахунок-фактура
    </a>
    <a style="margin-right: 20px; color: #0a790f" target="_blank"
       href="<?= uri('orders', ['id' => $id, 'section' => 'sales_invoice']); ?>">
        <i class="fa fa-print"></i> Видаткова накладна
    </a>
</div>

<form data-type="ajax" action="<?= uri('orders') ?>" class="form-horizontal">

    <input type="hidden" name="id" value="<?= $id ?>">
    <input type="hidden" name="action" value="update_status">

    <div class="row right">
        <div class="col-md-4">
            <h4><b>Статус</b></h4>
        </div>
    </div>

    <div class="type_block">

        <?php element('status', ['type' => $order->type, 'status' => $order->status]) ?>

        <?php element('button') ?>

    </div>
</form>


<form data-type="ajax" action="<?= uri('orders') ?>" class="form-horizontal">

    <input type="hidden" name="id" value="<?= $id ?>">
    <input type="hidden" name="action" value="update_shop">


    <div class="row right">
        <div class="col-md-4">
            <h4><b>Інформація</b></h4>
        </div>
    </div>

    <div class="type_block">
        <?php if ($order->status != 2) { ?>

            <?php element('date_delivery', ['date_delivery' => $order->date_delivery]) ?>

            <?php element('address', ['address' => $order->address]) ?>

            <?php element('pay_method', [
                'pay_method' => $order->pay_method,
                'required' => 1,
                'pays' => Model::getAll('pays')
            ]) ?>

            <?php element('button') ?>


        <?php } ?>

    </div>
</form>