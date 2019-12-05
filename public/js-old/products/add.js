$(document).ready(function () {
    var $body = $('body');

    $body.on('change', '[name=category]', function () {
        var $this = $(this);

        $.ajax({
            type: 'post',
            url: url('product'),
            data: {
                id: $this.val(),
                action: 'get_service_code'
            },
            success: function (answer) {
                var response = JSON.parse(answer);
                $('[name=services_code]').val(response.message);
                $('#fake-service-code').html(response.message);
                $('.service_code_container').show()
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });
});