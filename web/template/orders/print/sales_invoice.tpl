<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="<?= asset('css/components/bootstrap/bootstrap.css') ?>">
    <style>
        * {
            margin: 0;
            padding: 0;
            font-size: 12px;
        }

        body {
            padding-top: 40px;
            padding-bottom: 40px;
        }

        .table-container {
            width: 90%;
            margin: 0 5%;
        }

        span.b_line {
            text-decoration: underline;
        }

        .centered {
            text-align: center;
        }

        .gray-tr > td {
            background-color: #777;
            color: #000;
        }

        td > span {
            display: inline-block;
            border-bottom: 1px solid;
            width: 100%;
            /*height: 18px;*/
        }

        .right {
            text-align: right;
        }

        .table-w > tbody > tr > td, {
            border: none;
        }

    </style>
    <title>Видаткова накладна</title>
</head>
<body>
<div class="table-container">

    <table class="table table-bordered">
        <tr>
            <td><b>Постачальник</b></td>
            <td>
                <?= isset($pay->provider) && !is_null($pay->provider) ? $pay->provider : 'ФОП Нечипоренко Роман Олександрович' ?>
                <br>

                ІПН <?= isset($pay->ipn) && !is_null($pay->ipn) ? $pay->ipn : '3103714173' ?> <br>

                <?= isset($pay->address) && !is_null($pay->address) ? $pay->address : '02093 Київ, пров.Поліський 5, кв 32' ?>
                <br>

                р/р <?= isset($pay->account) && !is_null($pay->account) ? $pay->account : '26003050305595' ?> <br>

                МФО <?= isset($pay->mfo) && !is_null($pay->mfo) ? $pay->mfo : '305299' ?> <br>

                <?= isset($pay->bank) && !is_null($pay->bank) ? $pay->bank : 'АТ КБ «Приватбанк»' ?> <br>

                тел. <?= isset($pay->phone) && !is_null($pay->phone) ? $pay->phone : '095-886-45-14' ?>
            </td>
        </tr>
        <tr>
            <td><b>Одержувач</b></td>
            <td><?= $order->fio ?></td>
        </tr>
        <tr>
            <td><b>Платник</b></td>
            <td><?= $order->fio ?></td>
        </tr>
        <tr>
            <td><b>Замовлення</b></td>
            <td>№ <?= $id ?></td>
        </tr>
        <tr>
            <td><b>Умова продажу</b></td>
            <td>без замовлення</td>
        </tr>
    </table>

    <h4 class="centered">
        <b>Видаткова накладна № <?= $id ?>
            <br>
            від <!--<span style="border-bottom: 1px solid; display: inline-block; height: 25px; width: 300px">-->
            <?= $order->date_delivery ?>
            <!--</span>-->
        </b>
    </h4>

    <table class="table table-bordered">
        <tr class="gray-tr">
            <td><b>№</b></td>
            <td><b>Назва</b></td>
            <td><b>Од.</b></td>
            <td><b>Кількість</b></td>
            <td><b>Ціна без ПДВ</b></td>
            <td><b>Сума без ПДВ</b></td>
        </tr>
        <?php
        $sum = 0;
        foreach ($products as $i => $product) { ?>
            <tr>
                <td><b><?= $i + 1 ?></b></td>
                <td><b><?= $product->name ?></b></td>
                <td><b>шт</b></td>
                <td><b><?= $product->amount ?></b></td>
                <td><b><?= number_format($product->price, 2) ?></b></td>
                <td><b><?= number_format($product->sum, 2) ?></b></td>
            </tr>
            <?php $sum += $product->sum;
        } ?>

        <tr>
            <td style="border: none" colspan="4"></td>
            <td><b>Знижка:</b></td>
            <td><b><?= number_format($order->discount, 2) ?></b></td>
        </tr>
        <tr>
            <td style="border: none" colspan="4"></td>
            <td><b>Разом без ПДВ:</b></td>
            <td><b><?= number_format($sum, 2) ?></b></td>
        </tr>
        <tr>
            <td style="border: none" colspan="4"></td>
            <td><b>ПДВ:</b></td>
            <td></td>
        </tr>
        <tr>
            <td style="border: none" colspan="4"></td>
            <td><b>Всього БЕЗ ПДВ:</b></td>
            <td><b><?= number_format($sum, 2) ?></b></td>
        </tr>
    </table>

    <table class="table table-bordered">
        <tr>
            <td>
                <div> Всього на суму: <br>
                    <b><?= num2str($sum) ?></b><br>
                    ПДВ: 0,00 грн.
                </div>
            </td>
        </tr>

    </table>

    <table class="table-w table">
        <tr>
            <td style="width: 25%; border: none;" class="right">Від постачальника:</td>
            <td style="width: 25%; border: none;">
                <span class="centered">
                    <?= isset($pay->director) && !is_null($pay->director) ? $pay->director : 'Нечипоренко Р.О.' ?>
                </span>
            </td>
            <td style="width: 25%; border: none;" class="right">Отримав(ла):</td>
            <td style="width: 25%; border: none;"><span></span></td>
        </tr>
        <tr>
            <td style="width: 25% ;border: none;" class="right">Підпис:</td>
            <td style="width: 25% ;border: none;"><span></span></td>
            <td style="width: 25%; border: none;" class="right">Підпис:</td>
            <td style="width: 25%; border: none;"><span></span></td>
        </tr>

    </table>

</div>

<script>
    print();
</script>
</body>
</html>