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
        body {
            padding: 10%;
            margin: 0;
        }
    </style>
</head>
<body>

<table class="table table-bordered">
    <?php foreach ($products as $product) { ?>
        <tr>
            <td style="padding: 10px; width: 15%; text-align: center; vertical-align: middle; font-size: 200%; font-weight: bolder">
                <img style="width: 100%" src="<?= $product[0]->image; ?>" alt="">
            </td>

            <td style="width: 35%; text-align: center; vertical-align: middle; font-size: 200%; font-weight: bolder">
                <?= $product[0]->articul ?>
            </td>
            <td style="padding: 10px; width: 15%; text-align: center; vertical-align: middle; font-size: 200%; font-weight: bolder">
                <?php if (isset($product[1])) { ?>
                    <img style="width: 100%" src="<?= $product[1]->image; ?>" alt="">
                <?php } ?>
            </td>

            <td style="width: 35%; text-align: center; vertical-align: middle; font-size: 200%; font-weight: bolder">
                <?php if (isset($product[1])) { ?>
                    <?= $product[1]->articul ?>
                <?php } ?>
            </td>
        </tr>
    <?php } ?>
</table>

<script>
    print();
</script>

</body>
</html>