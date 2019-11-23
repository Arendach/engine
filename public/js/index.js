$(document).ready(function () {
    var $body = $('body');

    $body.on('click', '.close_notification', function () {
        var notification_id = $(this).data('id');
        $.ajax({
            type: 'post',
            url: url('notification'),
            data: {
                id: notification_id,
                action: 'close_notification'
            },
            success: function () {
                window.location.reload();
            },
            error: function (answer) {
                errorHandler(answer)
            }
        })
    });

    $body.on('click', '.close_task', function () {
        var id = $(this).data('id');
        var type = $(this).data('type');

        var data = {
            id: id,
            type: type,
            action: 'close_form'
        };

        $.ajax({
            type: 'post',
            url: url('/task'),
            data: data,
            success: function (answer) {
                myModalOpen(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('submit', '#close_task', function (event) {
        event.preventDefault();

        var data = $(this).serializeJSON();
        data.action = 'close';

        $.ajax({
            type: 'post',
            url: url('/task'),
            data: data,
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });
});