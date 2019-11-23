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
            font-size: 12px;
            margin: 0;
            padding: 0;
        }

        .table-container {
            width: 90%;
            margin: 5%;
        }

        .centered {
            text-align: center;
        }

        .right {
            text-align: right;
        }

        td > span {
            display: inline-block;
            border-bottom: 1px solid;
            width: 100%;
            height: 18px;
        }

        .num {
            font-size: 120%;
        }

        .num > span {
            display: inline-block;
            width: 200px;
            border: 1px solid #000;
            padding: 20px 10px;
        }

        .table-top-null > tbody > tr > td {
            border-top: none;
        }

        h1{
            font-size: 25px;
            font-weight: bold;
        }

    </style>
    <title>Рахунок-фактура</title>
</head>
<body>
<div class="table-container">
    <table class="table">
        <tr>
            <td style="border-top: none">
                <table class="table">
                    <tr>
                        <td class="right" style="border-left: 1px solid #ddd;"><b>Постачальник</b></td>
                        <td style="border-right: 1px solid #ddd;">
                            <span>
                                <?= isset($pay->provider) && !is_null($pay->provider)
                                    ? $pay->provider
                                    : 'ФОП Нечипоренко Роман Олександрович' ?>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="right" style="border-top: none; border-left: 1px solid #ddd;"><b>Адреса</b></td>
                        <td style="border-top: none;border-right: 1px solid #ddd;">
                            <span>
                                <?= isset($pay->address) && !is_null($pay->address)
                                    ? $pay->address
                                    : '02093 Київ, пров.Поліський 5, кв 32' ?>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="right" style="border-top: none; border-left: 1px solid #ddd;"><b>ІПН</b></td>
                        <td style="border-top: none;border-right: 1px solid #ddd;">
                            <span>
                                <?= isset($pay->ipn) && !is_null($pay->ipn)
                                    ? $pay->ipn
                                    : '3103714173' ?>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="right" style="border-top: none; border-left: 1px solid #ddd;"><b>Р/рахунок</b></td>
                        <td style="border-top: none;border-right: 1px solid #ddd;">
                            <span>
                                <?= isset($pay->account) && !is_null($pay->account)
                                    ? $pay->account
                                    : '26003050305595' ?>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="right" style="border-top: none; border-left: 1px solid #ddd;"><b>банк</b></td>
                        <td style="border-top: none;border-right: 1px solid #ddd;">
                            <span>
                                <?= isset($pay->bank) && !is_null($pay->bank)
                                    ? $pay->bank
                                    : 'АТ КБ «Приватбанк»' ?>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="right" style="border-top: none; border-left: 1px solid #ddd;"><b>МФО</b></td>
                        <td style="border-top: none;border-right: 1px solid #ddd;">
                            <span>
                                <?= isset($pay->mfo) && !is_null($pay->mfo)
                                    ? $pay->mfo
                                    : '305299' ?>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="right"
                            style="border-top: none; border-bottom: 1px solid #ddd; border-left: 1px solid #ddd;">
                            <b>Тел./ф.</b>
                        </td>
                        <td style="border-top: none;border-right: 1px solid #ddd; border-bottom: 1px solid #ddd;">
                            <span>
                                <?= isset($pay->phone) && !is_null($pay->phone)
                                    ? $pay->phone
                                    : '095-886-45-14' ?>
                            </span>
                        </td>
                    </tr>
                </table>
            </td>
            <td style="border-top: none">

                <h1 class="centered">
                    РАХУНОК-ФАКТУРА
                </h1>

                <div class="num centered">
                    <b>№</b> <span><b><?= $id ?></b></span>
                </div>

                <br>

                <div class="centered">
                    <b>від "<?= $order->date_delivery ?>"</b>
                </div>

            </td>
        </tr>
    </table>

    <table class="table table-bordered">
        <tr>
            <td class="right" style="width: 20%;"><b>Платник:</b></td>
            <td style="width: 80%;"><b><?= $order->fio ?></b></td>
        </tr>
    </table>
    <table class="table table-bordered">
        <tr>
            <td colspan="5" class="centered">
                <h4>Товари</h4>
            </td>
        </tr>

        <tr>
            <td colspan="1">
                <b>Найменування</b>
            </td>
            <td colspan="1">
                <b>Одиниця виміру</b>
            </td>
            <td colspan="1">
                <b>Кількість</b>
            </td>
            <td colspan="1">
                <b>Ціна одного</b>
            </td>
            <td colspan="1">
                <b>В сумі</b>
            </td>
        </tr>

        <?php $sum = 0;
        foreach ($products as $product) {
            $sum += $product->sum; ?>
            <tr>
                <td colspan="1">
                    <?= $product->name ?>
                </td>
                <td colspan="1">
                    шт
                </td>
                <td colspan="1">
                    <?= $product->amount ?>
                </td>
                <td colspan="1">
                    <?= number_format($product->price, 2) ?>
                </td>
                <td colspan="1">
                    <?= number_format($product->sum, 2) ?>
                </td>
            </tr>
        <?php } ?>

        <tr>
            <td colspan="3"></td>
            <td colspan="1"><b>Сума</b></td>
            <td colspan="1"><?= number_format($sum, 2); ?></td>
        </tr>
        <tr>
            <td colspan="3"></td>
            <td colspan="1"><b>Податок на додану вартість (ПДВ)</b></td>
            <td colspan="1"></td>
        </tr>
        <tr>
            <td colspan="3"></td>
            <td colspan="1"><b>Загальна сума БЕЗ ПДВ</b></td>
            <td colspan="1"><?= number_format($sum, 2); ?></td>
        </tr>
    </table>

    <table class="table table-top-null">
        <tr>
            <td class="right" style="width: 25%;"><b>Загальна сума, що підлягає оплаті:</b></td>
            <td colspan="3"><span><?= num2str($sum) ?></span></td>
        </tr>
        <tr>
            <td colspan="4"></td>
        </tr>
        <tr>
            <td class="right"><b>Директор:</b></td>
            <td style="width: 20%">
                <?= isset($pay->director) && !is_null($pay->director)
                    ? $pay->director
                    : 'Нечипоренко Р.О.' ?></td>

            <td class="right" style="width: 20%"><b>Підпис:</b></td>
            <td><span></span></td>
        </tr>
    </table>
</div>
<script>
    print();
</script>
</body>
</html>