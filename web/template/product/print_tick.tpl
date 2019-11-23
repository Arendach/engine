<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><?= $title ?? '' ?></title>
    <link rel="stylesheet" href="<?= asset('css/components/bootstrap/bootstrap.css') ?>">

    <style>
        .block {
            display: inline-block;
            width: calc(33.333333% - 45px);
            border: 1px solid black;
            margin: 10px;
            padding: 10px;
            /*text-align: center;*/
        }

        .price {
            text-decoration: underline;
            font-size: 160%;
        }

        .price_block{
            /*text-align: center;*/
        }

        .name{
            /*text-align: center;*/
            text-decoration: underline;
            display: block;
        }

        body {
            padding: 0;
            margin: 0;
        }
    </style>
</head>
<body>

<?php foreach ($products as $product) { ?>
    <div class="block">

        <!-- Модель + Назва -->
        <b class="name"><?= $product->model ?> <?= $product->name ?></b>

        <p><?= htmlspecialchars_decode($product->meta_description_uk) ?></p>

        <!-- Виробник -->
        Виробник: <b><?= \RedBeanPHP\R::load('manufacturers', $product->manufacturer)->name ?></b><br><br>

        <!-- Атрибути -->
        <?php if ($product->attributes != 'null' && $product->attributes != '' && $product->attributes != '[]') { ?>
            <?php foreach (with_json($product->attributes) as $key => $item) { ?>
                <?php if (isset($item->{0}) && $item->{0} != '' && $key == 0) { ?>

                    <!-- Ключ -->
                    <?= $key ?>

                    <!-- Значення -->
                    <b><?= $item->{0} ?></b>   <br>
                <?php } else {
                    continue;
                } ?>
            <?php } ?>
            <br>
        <?php } ?>

        <!-- Ціна -->

        <div class="price_block"> Ціна: <b class="price"><?= $product->costs ?></b> грн</div>
    </div>
<?php } ?>

<script>
    print();
</script>

</body>
</html>