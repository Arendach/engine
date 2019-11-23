$(document).ready(function () {
    var $body = $('body');

    $body.on('click', '#submit', function (event) {
        event.preventDefault();
        var login = $('#login').val();
        var password = $('#password').val();
        var remember_me = $('#remember_me').is(':checked') ? 1 : 0;

        $.ajax({
            type: 'post',
            url: site + '/login',
            data: {
                login: login,
                password: password,
                remember_me: remember_me
            },
            success: function () {
                if (window.location.pathname == '/login')
                    window.location.href = site;
                else
                    window.location.reload();
            },
            error: function (e) {
                var response = JSON.parse(e.responseText);
                alert(response.message);
            }
        });
    });

    $body.on('click', '.reset', function (event) {
        event.preventDefault();

        $.ajax({
            type: 'post',
            url: site + '/reset_password',
            data: {
                email: $('#email').val()
            },
            success: function (answer) {
                window.location.href = '/login';
            },
            error: function (e) {
                var response = JSON.parse(e.responseText);
                alert(response.message);
            }
        });
    });
});