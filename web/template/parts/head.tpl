<?php include parts('components') ?>

    <!DOCTYPE html>
    <html lang="uk">
    <head>
        <meta charset="UTF-8">
        <title><?= $title ?? 'ENTER TITLE' ?></title>

        <link rel="shortcut icon" href="<?= asset('favicon.ico'); ?>" type="image/x-icon">
        <link rel="icon" href="<?= asset('favicon.ico'); ?>" type="image/x-icon">

        <link rel="stylesheet" href="<?= asset('css/custom.css') ?>">
        <link rel="stylesheet" href="<?= asset('css/autocomplete.css') ?>">

        <?= $CSS_COMPONENTS; ?>

        <?php if (isset($css)) { ?>
            <?php foreach ($css as $item) { ?>
                <link rel="stylesheet" href="<?= asset("css/" . p2s($item) . ".css") ?>">
            <?php } ?>
        <?php } ?>
        <?= isset($style) ? $style : '' ?>
    </head>
<body>
    <input style="display: none" name="login" type="text">
    <input style="display: none" name="password" type="password">

<?php include parts('nav_bar') ?>
<?php include parts('left_bar') ?>
<div class="<?= template_class('content', 'content-big') ?>" id="content">

<?php if (isset($breadcrumbs)) { ?>
    <?php include parts('breadcrumbs') ?>
<?php } ?>