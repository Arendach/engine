<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="<?= asset('css/print.css') ?>">
    <style>
        * {margin: 0;padding: 0;font-size: 10px}
        .table-container {width: 98%;margin: 1%}
        .centered {text-align: center}
        .small {font-size: 9px}
        td {font-size: 10px}
    </style>
    <title>Товарний чек</title>
    <?php if (isset($marker)) { ?>
        <link rel="stylesheet" type="text/css" href="http://my.novaposhta.ua/public/css/print.css?21cd557d8933b281b27dd17280e10075">
        <script type="text/javascript" src="http://my.novaposhta.ua/public/js/vendors.js?9384e078d27ed17eede614d7fe914054"></script>
    <?php } ?>

    <!-- Стилі нової пошти -->
    <style>
        .marking-100-100 .Number {font-weight: normal}
        .marking-100-100 .Number b {font-size: 24px}
    </style>
</head>
<body>
<div class="table-container">
    <table class="table table-bordered">
        <tr>
            <td>Номер замовлення: <b><?= $order->id ?></b></td>
            <td class="small">Менеджер: <b><?= $order->author->login ?></b></td>
            <td>Замовлення заведено: <b><?= $order->created_at->format('d.m.Y H:i') ?></b></td>
        </tr>
        <tr>
            <td>Дата доставки: <b><?= $order->date_delivery_human ?></b></td>
            <td>
                <?php if ($order->type != 'sending') { ?>
                    Час доставки: <b><?= $order->time ?></b>
                <?php } else { ?>
                    Транспортна компанія: <b><?= $order->logistic->name ?></b>
                <?php } ?>
            </td>
            <td rowspan="10"></td>
        </tr>
        <tr>
            <td colspan="2">
                <?php if ($order->type == 'delivery') { ?>
                    Адреса: <b><?= $order->city ?> <?= $order->street ?> <?= $order->address ?></b>
                <?php } else if ($type == 'sending') { ?>
                    Адреса: <b><?= $order->sending_city_name ?> - <?=    $order->sending_warehouse_name ?></b>
                <?php } ?>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                Коментар до адреси: <b><?= $order->comment_address ?></b>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                Отримувач: <b><?= $order->fio ?></b>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                Телефон: <b><?= $order->phone ?></b>
                <?= !empty($order->phone2) ? "<br>$order->phone2" : '' ?>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                Дисконтна карта: <?= $order->coupon ?>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                Оплата: <b><?= $order->pay->name ?? 'Не вибрана' ?></b>
                <?php if ($order->prepayment != 0) { ?>
                    <br> Предоплата: <b><?= number_format($order->prepayment) ?></b>
                <?php } ?>
            </td>
        </tr>

        <tr>
            <td colspan="2">
                Підказка: <b><?= $order->hint->description ?? 'Не вибрана' ?></b>
            </td>
        </tr>

        <?php if ($order->type == 'sending') { ?>
            <tr>
                <td>
                    Доставку оплачує: <b><?= $order->pay_delivery == 'sender' ? 'Відправник' : 'Отримувач' ?></b>
                </td>
                <td>
                    Форма оплати: <b><?= $order->form_delivery == 'imposed' ? 'Готівкова' : 'Безготівкова' ?></b>
                </td>
            </tr>
            <!-- TODO: дописати  -->
            <?php /*if ($pay->type == 'remittance') { */?><!--
                <tr>
                    <td>
                        Грошовий переказ: <b><?/*= number_format($order->full_sum, 2) */?></b>
                    </td>
                    <td>
                        Платник грошового переказу: <b><?/*= $pay->payer == 'sender' ? 'Відправник' : 'Отримувач' */?></b>
                    </td>
                </tr>
            --><?php /*} */?>
        <?php } ?>
    </table>
</div>
<div class="table-container">
    <table class="table table-bordered">
        <tr>
            <td>Товар</td>
            <td>Склад</td>
            <td>Аттрибути</td>
            <td><b>Кількість</b></td>
            <?php if ($order->type == 'sending') { ?>
                <td><b>Номер місця</b></td>
            <?php } ?>
            <td>Ціна одного</td>
            <td>В сумі</td>
        </tr>
        <?php foreach ($order->products as $product) { ?>
            <tr>
                <td><?= $product->name ?></td>
                <td><?= $product->pivot->storage->name ?> - <?= $product->identefire_storage ?></td>
                <td>
                    <?php foreach ($product->pivot->attributes as $k => $v){ ?>
                        <?= $k ?>: <b><?= $v ?></b>
                    <?php } ?>
                </td>
                <td style="background: <?= $product->pivot->amount > 1 ? 'yellow' : 'white' ?>">
                    <?php if ($product->pivot->amount > 1) { ?>
                        <b style="font-size: 150%"><?= $product->pivot->amount ?> !!!</b>
                    <?php } else { ?>
                        <b><?= $product->pivot->amount ?></b>
                    <?php } ?>
                </td>
                <?php if ($order->type == 'sending') { ?>
                    <td><b><?= $product->pivot->place ?></b></td>
                <?php } ?>
                <td><?= number_format($product->pivot->price) ?></td>
                <td><?= number_format($product->pivot->price * $product->pivot->amount) ?></td>
            </tr>
        <?php } ?>
        <tr>
            <td colspan="<?= $order->type == 'sending' ? '5' : '4' ?>"></td>
            <td><b>Доставка</b></td>
            <td><?= number_format($order->delivery_cost) ?></td>
        </tr>
        <tr>
            <td colspan="<?= $order->type == 'sending' ? '5' : '4' ?>"></td>
            <td><b>Знижка</b></td>
            <td><?= number_format($order->discount) ?></td>
        </tr>
        <tr>
            <td colspan="<?= $order->type == 'sending' ? '5' : '4' ?>"></td>
            <td><b>Сума</b></td>
            <td><b><?= number_format($order->full_sum + $order->delivery_cost - $order->discount) ?></b></td>
        </tr>
        <?php if ($order->comment != '') { ?>
            <tr>
                <td colspan="<?= $order->type == 'sending' ? '7' : '6' ?>" style="padding-left: 25px">
                    <?= $order->comment ?>
                </td>
            </tr>
        <?php } ?>

        <?php if ($order->type == 'sending') { ?>
            <tr>
                <td colspan="<?= $type == 'sending' ? '7' : '6' ?>">
                    <?php foreach ($order->places as $place_id => $place) { ?>
                        Місце <?= $place_id ?>: Вага - <?= $place->weight ?> кг., Об'єм - <?= $place->volume ?> м
                        <sup>3</sup>.<br>
                    <?php } ?>
                </td>
            </tr>
        <?php } ?>
    </table>
</div>


<?php if ($order->type != 'sending'){ ?>
    <div class="table-container">
        <table class="table-bordered table">
            <tr>
                <td><span>Номер Замовлення</span> <b><?= $order->id?></b></td>
                <td><span>Номер Замовлення</span> <b><?= $order->id?></b></td>
                <td><span>Номер Замовлення</span> <b><?= $order->id?></b></td>
            </tr>
            <tr>
                <td><span>Дата доставки </span><b><?= $order->date_delivery_human ?></b></td>
                <td><span>Дата доставки </span><b><?= $order->date_delivery_human ?></b></td>
                <td><span>Дата доставки </span><b><?= $order->date_delivery_human ?></b></td>
            </tr>
            <tr>
                <td><span>Час доставки </span><b><?= $order->time ?></b></td>
                <td><span>Час доставки </span><b><?= $order->time ?></b></td>
                <td><span>Час доставки </span><b><?= $order->time ?></b></td>
            </tr>
            <tr>
                <td><span>Адреса </span><b><?= $order->city ?> <?= $order->street ?> <?= $order->address ?></b></td>
                <td><span>Адреса </span><b><?= $order->city ?> <?= $order->street ?> <?= $order->address ?></b></td>
                <td><span>Адреса </span><b><?= $order->city ?> <?= $order->street ?> <?= $order->address ?></b></td>
            </tr>
            <tr>
                <td><span>Менеджер </span><b><?= $order->author->login ?></b></td>
                <td><span>Менеджер </span><b><?= $order->author->login ?></b></td>
                <td><span>Менеджер </span><b><?= $order->author->login ?></b></td>
            </tr>
            <tr>
                <td><b><?= $order->hint->description ?></b></td>
                <td><b><?= $order->hint->description ?></b></td>
                <td><b><?= $order->hint->description ?></b></td>
            </tr>
        </table>
    </div>
<?php } ?>

<?php if (isset($marker)) { ?>
    <div class="table-container">
        <?= $marker ?>
    </div>
<?php } ?>

<?php if ($order->type == 'self') { ?>
    <div class="centered" style="font-size: 120px; border: 3px solid black;">
        <?= $order->id ?><br>
        <div style="font-size: 60px"><?= $order->date_delivery_human ?></div>
    </div>
<?php } ?>

<!-------------------------------------------------------------->

<?php if (isset($marker)) { ?>
    <script type="text/javascript" src="http://my.novaposhta.ua/public/js/print.js?1568809155991"></script>
    <script type="text/javascript">
        if (window.CurrentController == undefined || window.CurrentController == 'orders'
            && (window.CurrentAction == 'printDocument' || window.CurrentAction == 'printMarkings' || window.CurrentAction == 'printMarking100x130' || window.CurrentAction == 'printMarking100x100')) {
        } else {
            var Yii = Yii || {};
            Yii.app = {
                scriptUrl: '/', baseUrl: '',
                hostInfo: 'https://my.novaposhta.ua'
            };
            Yii.app.urlManager = new UrlManager({
                "rules": [],
                "urlSuffix": "",
                "showScriptName": false,
                "appendParams": true,
                "routeVar": "r",
                "caseSensitive": true,
                "matchValue": false,
                "cacheID": "cache",
                "useStrictParsing": false,
                "urlRuleClass": "CUrlRule",
                "behaviors": [],
                "urlFormat": "path"
            });
            Yii.app.createUrl = function (route, params, ampersand) {
                return this.urlManager.createUrl(route, params, ampersand);
            };
        }
    </script>
<?php } ?>

<script> //print() </script>
</body>
</html>