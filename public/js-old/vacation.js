$(document).ready(function () {
    var $body = $('body');

    function change_field() {

        if (+$('#count_days').val() > 14) $('#count_days').val(14);

        if ($('#count_days').val() != '' && $('#with').val() != '') {
            $.ajax({
                type: 'post',
                url: url('/vacation'),
                responseType: 'json',
                data: {
                    count_days: $('#count_days').val(),
                    with: $('#with').val(),
                    action: 'check_vacation'
                },
                success: function (answer) {
                    $('#vacation_send').removeAttr('disabled');
                    $('#place_for_result').html(answer.message + '<br>');
                },
                error: function (answer) {
                    console.log(answer)
                    $('#vacation_send').attr('disabled', 'disabled');
                    $('#place_for_result').html(answer.responseJSON.message + '<br>');
                }
            });
        }
    }

    $body.on('click', '.vacation_add_form', function () {
        $.ajax({
            type: 'post',
            url: url('/vacation'),
            data: {action: 'get_add_form'},
            success: function (answer) {
                myModalOpen(answer);
            }
        });
    });

    $body.on('keyup', '.field', change_field);

    $body.on('change', '#with', change_field);

    $body.on('click', '#vacation_send', function (event) {
        event.preventDefault();
        $.ajax({
            type: 'post',
            url: url('/vacation'),
            data: {
                count_days: $('#count_days').val(),
                with: $('#with').val(),
                action: 'save_vacations'
            },
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

});