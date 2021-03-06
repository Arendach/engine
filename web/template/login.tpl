<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>Авторизація</title>
    <link rel="stylesheet" href="<?= asset('css/login.css') ?>">
</head>
<body>
<section class="container">
    <div class="login">
        <h1>Авторизація</h1>
        <form>
            <input type="hidden" id="after" value="<?= request()->is('after', 'close') ? 'close' : 'reload' ?>">
            <p><input type="text" id="login" value="" placeholder="Логін"></p>
            <p><input type="password" id="password" value="" placeholder="Пароль"></p>
            <p class="submit"><input type="submit" id="submit" value="Вхід"></p>
        </form>
    </div>
</section>

<script src="<?= asset('js/app.js') ?>"></script>
<script src="<?= asset('js/login.js') ?>"></script>

</body>
</html>