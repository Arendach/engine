$(document).ready(function () {
    var $body = $('body');

    $body.on('click', '.edit', function () {
        var data = {
            action: 'update',
            id: $(this).parents('tr').data('id')
        };

        $(this).parents('tr').find('.field').each(function () {
            data[$(this).attr('name')] = $(this).val();
        });

        $.ajax({
            type: 'post',
            url: url('/sms'),
            data: data,
            success: function (answer) {
                successHandler(answer)
            },
            error: function (answer) {
                errorHandler(answer)
            }
        })
    });
});