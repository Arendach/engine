<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Закупка по виробнику: "<?= $data->manufacturer_name ?>"</title>
    <style>
        table {
            font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
            font-size: 14px;
            border-collapse: collapse;
            text-align: center;
            width: 100%;
        }

        th, .custom td:first-child {
            background: #AFCDE7;
            color: white;
            padding: 10px 20px;
        }

        th, td {
            border-style: solid;
            border-width: 0 1px 1px 0;
            border-color: white;
        }

        td {
            background: #D8E6F3;
        }

        .custom th:first-child, .custom td:first-child {
            text-align: left;
        }
    </style>
</head>
<body>

<table>
    <tr>
        <th>Дата</th>
        <th>Виробник</th>
        <th>Склад</th>
        <th>Сума($)</th>
        <th>Статус оплати</th>
        <th>Тип предзамовлення</th>
    </tr>
    <tr>
        <td><?= date_for_humans($data->date) ?></td>
        <td><?= $data->manufacturer_name ?></td>
        <td><?= $data->storage_name ?></td>
        <td><?= number_format($data->sum, 2) ?></td>
        <td>
            <?php if ($data->status == 0) echo 'Не оплачено';
            elseif ($data->status == 1) echo 'Сплачено частково';
            else echo 'Сплачено'; ?>
        </td>
        <td><?= $data->type == 0 ? 'Необхідно закупити' : 'Прийнято на облік' ?></td>
    </tr>
    <?php if ($data->comment != '') { ?>
        <tr>
            <td colspan="6" align="left" style="padding: 10px">Коментар: <?= $data->comment ?></td>
        </tr>
    <?php } ?>
</table>

<br>

<table class="custom">
    <tr>
        <th>Товар</th>
        <th>Необхідно закупити (одиниць)</th>
        <th>По ціні($)</th>
        <th>В сумі</th>
    </tr>
    <?php foreach ($data->products as $product) { ?>
        <tr>
            <td><?= $product->name ?></td>
            <td><?= $product->amount ?></td>
            <td><?= number_format($product->price, 2) ?></td>
            <td><?= number_format($product->price * $product->amount, 2) ?></td>
        </tr>
    <?php } ?>
</table>

</body>
</html>