<?php

include t_file('buy.update.elements');

$card_class = $return_shipping->type == 'remittance' && $return_shipping->type_remittance == 'on_the_card' ? '' : ' none ';
$field_class = $return_shipping->type != 'none' ? '' : ' none ';
$remittance_class = $return_shipping->type == 'remittance' ? '' : ' none ';
$payer_class = $return_shipping->payer == 'none' ? 'none ' : '';

?>

<div class="centered" style="background: #eee; padding: 15px; margin-bottom: 10px;">
    <a target="_blank" style="margin-right: 20px; color: #0a790f"
       href="<?= uri('orders', ['section' => 'receipt', 'id' => $id]) ?>">
        <i class="fa fa-print"></i> Товарний чек
    </a>
    <a style="margin-right: 20px; color: #0a790f" target="_blank"
       href="<?= uri('orders', ['section' => 'receipt', 'id' => $id, 'official' => 1]) ?>">
        <i class="fa fa-print"></i> Товарний чек для бугалетрії
    </a>
    <a target="_blank" style="margin-right: 20px; color: #0a790f"
       href="<?= uri('orders', ['section' => 'invoice', 'id' => $id]) ?>">
        <i class="fa fa-print"></i> Рахунок-фактура
    </a>
    <a target="_blank" style="margin-right: 20px; color: #0a790f"
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

                <?php element('delivery', ['delivery' => $order->delivery]) ?>

                <?php element('date_delivery', ['date_delivery' => $order->date_delivery]) ?>

                <?php element('site', ['site' => $order->site]) ?>

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

        <div class="row right">
            <div class="col-md-4">
                <h4><b>Зворотня доставка</b></h4>
            </div>
        </div>

        <div class="type_block">
            <form action="<?= uri('orders') ?>" data-type="ajax">

                <input type="hidden" name="action" value="update_return_shipping">
                <input type="hidden" name="id" value="<?= $order->id ?>">

                <div class="form-group">
                    <label class="col-md-4 control-label">Тип</label>
                    <div class="col-md-5">
                        <select name="type" class="form-control" id="return_shipping_type">
                            <option <?= $return_shipping->type == 'none' ? 'selected' : ''; ?> value="none">Немає</option>
                            <option <?= $return_shipping->type == 'documents' ? 'selected' : ''; ?> value="documents">Документ
                            </option>
                            <option <?= $return_shipping->type == 'remittance' ? 'selected' : ''; ?> value="remittance">Грошовий
                                переказ
                            </option>
                            <option <?= $return_shipping->type == 'other' ? 'selected' : ''; ?> value="other">Інше</option>
                        </select>
                    </div>
                </div>

                <div class="form-group<?= $remittance_class; ?>" id="return_shipping_remittance_type_container">
                    <label class="col-md-4 control-label">Грошовий переказ</label>
                    <div class="col-md-5">
                        <select class="form-control" name="type_remittance">
                            <option value="imposed">У відділенні</option>
                            <option disabled value="on_the_card">На картку</option>
                        </select>
                    </div>
                </div>

                <div class="form-group<?= $card_class; ?>" id="return_shipping_card_container">
                    <label class="col-md-4 control-label">Карточка</label>
                    <div class="col-md-5">
                        <select disabled class="form-control" name="card">
                            <?php foreach ($cards as $item) { ?>
                                <option <?= $return_shipping->card == $item['Ref'] ? 'selected' : '' ?> value="<?= $item['Ref'] ?>">
                                    <?= $item['MaskedNumber'] ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>
                </div>

     <!--           <div class="form-group<?/*= $field_class; */?>" id="return_shipping_sum_container">
                    <label class="col-md-4 control-label">Дані/сума</label>
                    <div class="col-md-5">
                        <input required pattern="[0-9\.]+" class="form-control" name="sum" value="<?/*= $return_shipping->sum */?>">
                    </div>
                </div>-->

                <div class="form-group<?= $payer_class; ?><?= $field_class ?>" id="return_shipping_payer_container">
                    <label class="col-md-4 control-label">Платник зворотньої відправки</label>
                    <div class="col-md-5">
                        <select name="payer" class="form-control">
                            <option <?= $return_shipping->payer == 'receiver' ? 'selected' : '' ?> value="receiver">Отримувач             </option>
                            <option <?= $return_shipping->payer == 'sender' ? 'selected' : '' ?> value="sender">Відправник</option>
                        </select>
                    </div>
                </div>

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
