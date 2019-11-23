<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <!--    <link rel="stylesheet" href="--><? //= asset('css/components/bootstrap/bootstrap.css') ?><!--">-->
    <link rel="stylesheet" href="<?= asset('css/print/order.css') ?>">
    <link rel="stylesheet" href="<?= asset('css/print/new_post.css') ?>">
    <style>
        * {
            margin: 0;
            padding: 0;
            font-size: 10px;
        }

        .table-container {
            width: 98%;
            margin: 1%;
        }

        span.b_line {
            text-decoration: underline;
        }

        .centered {
            text-align: center;
        }

        .inline {
            display: inline;
        }

        .small {
            font-size: 9px;
        }

        td {
            font-size: 10px;
        }

    </style>
    <title>Товарний чек</title>

    <?php if (isset($marker)) { ?>
        <link rel="stylesheet" type="text/css"
              href="http://my.novaposhta.ua/public/css/print.css?21cd557d8933b281b27dd17280e10075">
        <script type="text/javascript"
                src="http://my.novaposhta.ua/public/js/vendors.js?9384e078d27ed17eede614d7fe914054"></script>
    <?php } ?>

</head>
<body>
<div class="table-container">
    <table class="table table-bordered">
        <tr>
            <td colspan="1" class="centered">
                <h4>Товарний чек №<b><?= $id ?></b></h4>
            </td>

            <td colspan="1" class="centered small">
                Дата виписки рахунку: <?= $order->date ?>
                <br>
                Менеджер: <?= user($order->author)->login ?>
            </td>
        </tr>
        <tr>
            <td colspan="2" class="centered">
                Портал феєрверків, повітряних кульок та подарунків - SkyFire.com.ua
                <br>
                063-247-91-35(кульки), 063-478-01-78(піротехніка)
                <br>
                <br>
                <span style="font-size: 18px">Номер картки:
                <span class="b_line">&emsp;</span>
                <span class="b_line">&emsp;</span>
                <span class="b_line">&emsp;</span>
                <span class="b_line">&emsp;</span>
                <span class="b_line">&emsp;</span>
                <span class="b_line">&emsp;</span>
                </span>
            </td>
        </tr>
        <tr>
            <td style="padding: 5px">
                Дата доставки: <b><?= $order->date_delivery ?></b>
            </td>
            <td style="padding: 5px">
                <?php if ($type == 'delivery' or $type == 'self') { ?>
                    Від-до: <b><?= string_to_time($order->time_with) ?> - <?= string_to_time($order->time_to) ?></b>
                <?php } else { ?>
                    Транспортна компанія: <b><?= $order->delivery_name ?></b>
                <?php } ?>
            </td>
        </tr>
        <tr>
            <td style="padding: 5px">
                Отримувач: <b><?= $order->fio ?></b>
            </td>
            <?php if ($type != 'self') { ?>
                <td style="padding: 5px">
                    Місто: <b><?= $order->city ?></b>
                </td>
            <?php } else { ?>
                <td style="padding: 5px">
                    Телефон: <b><?= $order->phone ?></b>
                </td>
            <?php } ?>
        </tr>
        <?php if ($type != 'self') { ?>
            <tr>
                <td style="padding: 5px">
                    Телефон: <b><?= $order->phone ?></b>
                </td>
                <td style="padding: 5px">
                    <b><?php if ($type == 'delivery' or $type == 'self') { ?></b>
                    Район: <b><?= $street['region'] ?></b>
                    <?php } else { ?>
                        Склад: <b><?= $order->warehouse; ?></b>
                    <?php } ?>
                </td>
            </tr>
            <tr>
                <b><?php if ($order->phone2 != '') { ?></b>
                <td style="padding: 5px">
                    Додатковий телефон: <b><?= $order->phone2 ?></b>
                </td>
                <?php } ?>
                <td colspan="<?= $order->phone2 == '' ? '2' : '1' ?>" style="padding: 5px">
                    <b><?php if ($type == 'delivery') {
                            echo $street['type'] . ': ' . $street['name'] . ' ' . $order->address ?>
                        <?php } else if ($type == 'sending') {
                            echo 'Адреса: ' . $order->address;
                        } ?></b>
                </td>
            </tr>
        <?php } ?>
        <?php if ($order->comment_address != '') { ?>
            <tr>
                <td colspan="2">
                    <b><?= $order->comment_address ?></b>
                </td>
            </tr>
        <?php } ?>

        <?php if ($type == 'sending') { ?>
            <tr>
                <td>
                    <b>Доставку оплачує: <?= $order->pay_delivery == 'sender' ? 'Відправник' : 'Отримувач' ?></b>
                </td>
                <td>
                    <b>Форма оплати: <?= $order->form_delivery == 'imposed' ? 'Готівкова' : 'Безготівкова' ?></b>
                </td>
            </tr>
            <?php if ($pay->type == 'remittance') { ?>
                <tr>
                    <td>
                        <b>Грошовий
                            переказ: <?= number_format($order->full_sum - $order->discount + $order->delivery_cost, 2) ?></b>
                    </td>
                    <td>
                        <b>Платник грошового переказу: <?= $pay->payer == 'sender' ? 'Відправник' : 'Отримувач' ?></b>
                    </td>
                </tr>
            <?php } ?>
        <?php } ?>

    </table>
</div>
<div class="table-container">
    <table class="table table-bordered">
        <tr>
            <td colspan="1">
                Товар
            </td>
            <td colspan="1">
                Ідентифікатор складу
            </td>
            <td colspan="1">
                Аттрибути
            </td>
            <td colspan="1">
                <b>Кількість</b>
            </td>

            <?php if ($order->type == 'sending') { ?>
                <td colspan="1">
                    <b>Номер місця</b>
                </td>
            <?php } ?>

            <td colspan="1">
                Ціна одного
            </td>
            <td colspan="1">
                В сумі
            </td>
        </tr>
        <?php foreach ($products as $product) { ?>
            <tr>
                <td colspan="1">
                    <?= $product->name ?>
                </td>
                <td colspan="1">
                    <?= $product->identefire_storage ?>
                </td>
                <td colspan="1">
                    <?php foreach (json_decode($product->attributes) as $k => $v): ?>
                        <span class="text-primary"><?= $k ?>:</span> <?= $v ?>
                    <?php endforeach ?>
                </td>
                <td colspan="1" style="background: <?= $product->amount > 1 ? 'yellow' : 'white' ?>">
                    <?php if ($product->amount > 1) { ?>
                        <b style="font-size: 150%"><?= $product->amount ?> !!!</b>
                    <?php } else { ?>
                        <b><?= $product->amount ?></b>
                    <?php } ?>
                </td>
                <?php if ($order->type == 'sending') { ?>
                    <td colspan="1">
                        <b><?= $product->place ?></b>
                    </td>
                <?php } ?>
                <td colspan="1">
                    <?= number_format($product->price, 2) ?>
                </td>
                <td colspan="1">
                    <?= number_format($product->sum, 2) ?>
                </td>
            </tr>
        <?php } ?>

        <tr>
            <td colspan="<?= $type == 'sending' ? '5' : '4' ?>"></td>
            <td colspan="1"><b>Доставка</b></td>
            <td colspan="1"><?= number_format($order->delivery_cost, 2) ?></td>
        </tr>
        <tr>
            <td colspan="<?= $type == 'sending' ? '5' : '4' ?>"></td>
            <td colspan="1"><b>Знижка</b></td>
            <td colspan="1"><?= number_format($order->discount, 2) ?></td>
        </tr>
        <tr>
            <td colspan="<?= $type == 'sending' ? '5' : '4' ?>"></td>
            <td colspan="1"><b>Сума</b></td>
            <td colspan="1"><b><?= number_format($sum + $order->delivery_cost - $order->discount, 2) ?></b></td>
        </tr>
        <?php if ($order->comment != '') { ?>
            <tr>
                <td colspan="<?= $type == 'sending' ? '7' : '6' ?>">
                    <?= preg_replace('/\n/', '<br>', $order->comment) ?>
                </td>
            </tr>
        <?php } ?>

        <?php if ($order->type == 'sending') { ?>
            <tr>
                <td colspan="<?= $type == 'sending' ? '7' : '6' ?>">
                    <?php foreach ($places as $place_id => $place) { ?>
                        Місце <?= $place_id ?>: Вага - <?= $place->weight ?> кг., Об'єм - <?= $place->volume ?> м
                        <sup>3</sup>.<br>
                    <?php } ?>
                </td>
            </tr>
        <?php } ?>
    </table>
</div>

<?php if (isset($marker)) { ?>
    .
    <div class="table-container">
        <?= $marker ?>
    </div>
<?php } ?>

<?php if ($type == 'self') { ?>
    <div class="centered" style="font-size: 120px; border: 3px solid black;">
        <?= $order->id ?><br>
        <div style="font-size: 60px"><?= date_for_humans($order->date_delivery) ?></div>
    </div>
<?php } ?>


<?php if (isset($marker)) { ?>
    <script type="text/javascript" src="http://my.novaposhta.ua/public/js/print.js?1568809155991"></script>
    <script type="text/javascript">
        /*<![CDATA[*/
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

        /*]]>*/
    </script>
<?php } ?>

<script> print() </script>
</body>
</html>