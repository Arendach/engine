<?php include parts('components') ?>

    <!DOCTYPE html>
    <html lang="uk">
    <head>
        <meta charset="UTF-8">
        <title><?= isset($title) ? $title : 'ENTER TITLE' ?></title>

        <link rel="shortcut icon" href="<?= asset('favicon.ico'); ?>" type="image/x-icon">
        <link rel="icon" href="<?= asset('favicon.ico'); ?>" type="image/x-icon">

        <link rel="stylesheet" href="<?= asset('css/custom.css') ?>">

        <?= $CSS_COMPONENTS; ?>

        <?php if (isset($css)) { ?>
            <?php foreach ($css as $item) { ?>
                <link rel="stylesheet" href="<?= asset("css/" . p2s($item) . ".css") ?>">
            <?php } ?>
        <?php } ?>

        <script type="text/javascript">
            var pin = '<?= user()->pin ?>',
                my_url = '<?= SITE; ?>';
        </script>
        <script type="text/javascript" src="<?= asset("js/jquery.js") ?>"></script>
        <script type="text/javascript" src="<?= asset("js/components/jquery/cookie.js") ?>"></script>
        <script type="text/javascript" src="<?= asset('js/components/jquery/serialize_json.js') ?>"></script>
        <script type="text/javascript" src="<?= asset("js/URLs.js") ?>"></script>
        <script type="text/javascript" src="<?= asset("js/common.js") ?>"></script>

        <?= $JS_COMPONENTS; ?>

        <?php if (isset($scripts)) { ?>
            <?php foreach ($scripts as $script) { ?>
                <script type="text/javascript" src="<?= asset("js/" . p2s($script) . ".js") ?>"></script>
            <?php } ?>
        <?php } ?>
        <?= isset($to_js) ? to_javascript($to_js) : '' ?>
        <?= isset($style) ? $style : '' ?>
    </head>
<body style="background: #FBFDF3">
    <input style="display: none" name="login" type="text">
    <input style="display: none" name="password" type="password">
    <input style="display: none" name="password" type="password">

<?php include parts('nav_bar') ?>
<?php include parts('left_bar') ?>
<div class="<?= template_class('content', 'content-big') ?>" id="content">

<?php if (isset($breadcrumbs)) { ?>
    <?php include parts('breadcrumbs') ?>
<?php } ?>