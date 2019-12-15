$(document).ready(function () {

    var $body = $('body');

    $body.on('keyup', '#street', function () {
        var $this = $(this);
        if ($('#city').val() == 'Київ') {
            $('#street_select_container').show();
            $.ajax({
                type: 'post',
                url: url('/api/search_streets'),
                data: {
                    city: 'Київ',
                    street: $this.val()
                },
                success: function (answer) {
                    $('#street_select').html(answer);
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        }
    });

    $body.on('change', '#street_select', function () {
        $('#street').val($('#street_select :selected').text());
        $('#street_select_container').hide();
    });

    $body.on('keyup', '#city', function () {
        $('#city_select_container').show();
        var $this = $(this);
        $.ajax({
            type: 'post',
            url: url('/api/search_village'),
            data: {
                name: $this.val()
            },
            success: function (answer) {
                $('#city_select').html(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        })
    });

    $body.on('change', '#city_select', function () {
        $('#city').val($(this).find(':selected').val());
        $('#city_select_container').hide();
    });
});