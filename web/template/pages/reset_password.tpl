<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>Скидання паролю</title>
    <?= style('login') ?>
</head>
<body>
<section class="container">
    <div class="login">
        <h1>Скидання паролю</h1>
        <form>
            <p><input type="email" id="email" placeholder="Електронна пошта"></p>
            <p class="submit"><input type="submit" class="reset" value="Скинути"></p>
        </form>
    </div>

    <div class="login-help">
        <a href="<?= route('login') ?>">Авторизація</a>
    </div>
</section>
<script>var site = '<?= my_site_url() ?>'</script>
<?= script_file('jquery') ?>
<?= script_file('login') ?>
</body>
</html>