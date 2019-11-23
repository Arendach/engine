$(document).ready(function () {
    var $body = $('body');

    $body.on('change', '#type', function () {
        if ($(this).val() == '') {
            $('#status').html('<option selected value=""></option>').attr('disabled', 'disabled');
        } else {
            $('#status').html(Statuses[$(this).val()]).removeAttr('disabled');
        }
    });

    $body.on('click', '#filter', function () {
        var data = {};
        $('.search').each(function () {
            data[$(this).attr('name')] = $(this).val();
        });
        GET.setObject(data).unsetEmpty().go();
    });
});