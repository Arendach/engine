<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="<?= asset('css/print/order.css') ?>">
    <title>Переміщення</title>

    <style>
        * {
            font-size: 10px;
        }
    </style>
</head>
<body>

<table class="table table-bordered">
    <tr>
        <td>Дата</td>
        <td>З складу</td>
        <td>На склад</td>
        <td>Передав</td>
        <td>Отримав</td>
        <td>Статус</td>
    </tr>
    <tr>
        <td><?= date_for_humans($moving->date) ?></td>
        <td><i style="color: green"><?= $moving->sf_name ?></i></td>
        <td><i style="color: blue"><?= $moving->st_name ?></i></td>
        <td>
            <a href="<?= uri('user', ['section' => 'view', 'id' => $item->user_from]) ?>">
                <?= $moving->uf_login ?>
            </a>
        </td>
        <td>
            <a href="<?= uri('user', ['section' => 'view', 'id' => $item->user_to]) ?>">
                <?= $moving->ut_login ?>
            </a>
        </td>
        <td>
            <?= $moving->status ? '<b style="color: green">Виконано</b>' : '<b style="color: blue">Обробляється</b>' ?>
        </td>
    </tr>
</table>

<table class="table table-bordered">
    <tr>
        <th>Товар</th>
        <th>Кількість</th>
    </tr>
    <?php foreach ($products as $item) { ?>
        <tr>
            <td>
                <a href="<?= uri('product', ['section' => 'update', 'id' => $item->product_id]) ?>">
                    <?= $item->product_name ?>
                </a>
            </td>
            <td>
                <?= $item->count ?>
            </td>
        </tr>
    <?php } ?>
</table>

</body>
</html>