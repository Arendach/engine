$(document).ready(function () {
    var $body = $('body');

    $body.on('click', '#search', function (event) {
        event.preventDefault();
        var data = {};
        var client = $('#client_id').val();
        data['client'] = client;
        $('form .search').each(function () {
            if ($(this).val() != '')
                data[$(this).attr('name')] = $(this).val();
        });

        data.action = 'search_orders';

        $.ajax({
            type: 'post',
            url: url('clients'),
            data: data,
            success: function (a) {
                $('table .order_row').remove();
                $('table .recommended').remove();
                if(a.length > 10) {
                    $('table.search tbody').append(a);
                    $('#save').css('display', 'block');
                } else {
                    $('#save').css('display', 'none');
                    $('table.search tbody').append('<tr class="order_row"><td colspan="5"><h4 class="centered">Не знайдено, або вже прикріплено! </h4></td></tr>');
                }
            }
        });
    });
    $(document).on('click', '#save', save);

    function save(event) {
        event.preventDefault();
        var client = $('#client_id').val();
        var orders = [];
        $('.selected').each(function () {
            orders.push($(this).attr('data-id'));
        });

        $.ajax({
            type: 'post',
            url: url('clients'),
            data: {
                client: client,
                orders: orders,
                action: 'save_orders'
            },
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    }


    $(document).on('click', '.order_row', function () {
        $(this).toggleClass('selected');
    });

});
