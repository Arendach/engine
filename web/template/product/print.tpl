<!doctype html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="<?= asset('css/components/bootstrap/bootstrap.css') ?>">
    <title>Document</title>
</head>
<body>

<table class="table table-bordered">
    <tr>
        <th>Назва</th>
        <td>На складі</td>
        <td>На доставку</td>
        <th>Облік</th>
        <th>Виробник</th>
        <th>Артикул</th>
        <th>ІД складу</th>
        <th>Ціна</th>
    </tr>
    <?php foreach ($items as $item) { ?>
        <tr>
            <td><?= $item->name ?></td>
            <td><?= $item->count_on_storage ?></td>
            <td><?= !empty($item->delivery_count) ? $item->delivery_count : '0' ?></td>
            <td><?= $item->combine ? 'Ні' : ($item->accounted ? 'Так' : 'Ні') ?></td>
            <td><?= $item->manufacturer_name ?></td>
            <td><?= $item->articul ?></td>
            <td><?= $item->identefire_storage ?></td>
            <td><?= $item->costs ?></td>
        </tr>
    <?php } ?>
</table>

<script>
    print();
</script>
</body>
</html>