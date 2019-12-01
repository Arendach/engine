<?php //dd($_COOKIE) ?>
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
            <p><input type="text" id="login" value="" placeholder="Логін"></p>
            <p><input type="password" id="password" value="" placeholder="Пароль"></p>
            <p class="submit"><input type="submit" id="submit" value="Вхід"></p>
        </form>
    </div>
</section>
<script>var site = '<?= SITE ?>'</script>
<script src="<?= asset('js/jquery.js') ?>"></script>

<script>

    $(document).ready(function () {
        $(document).on('click', '#submit', function (event) {
            event.preventDefault();
            let login = $('#login').val();
            let password = $('#password').val();
            let remember_me = $('#remember_me').is(':checked') ? 1 : 0;

            $.ajax({
                type: 'post',
                url: site + '/login',
                data: {login, password, remember_me},
                success: (answer) => {
                    console.log(answer);
                    /* if (window.location.pathname == '/login')
                         window.location.href = site;
                     else
                         window.location.reload();*/
                },
                error: (e) => {
                    let response = JSON.parse(e.responseText);
                    alert(response.message);
                }
            });
        });
    });

</script>
</body>
</html>