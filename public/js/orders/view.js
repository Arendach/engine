$(document).ready(function () {

    var $body = $('body');

    $body.on('click', '#search', function () {
        filter_orders();
    });

    $body.on('keyup', '.search', function (e) {
        if (e.which == 13) filter_orders();
    });

    $body.on('change', 'select.search', function (e) {
        filter_orders();
    });

    $('.search#phone').inputmask('999-999-99-99');

    function filter_orders() {
        var data = {};

        $('.search').each(function () {
            data[$(this).attr('id')] = $(this).val();
        });

        GET.setObject(data).unsetEmpty().unset('page').go();
    }

    $body.on('click', '#export_xml', function () {
        var array = [];
        $('.order_check:checked').each(function () {
            array.push($(this).data('id'));
        });

        if (array.length == 0) {
            swal({
                type: 'error',
                title: 'Помилка!',
                text: 'Ви не позначили жодного замовлення для експотування!'
            });
            return false;
        }

        $.ajax({
            type: 'post',
            url: url('orders'),
            data: {
                ids: array,
                action: 'export'
            },
            success: function (answer) {
                successHandler(answer);
            }
        });
    });

    $body.on('click', '.print_button', function () {
        var $this = $(this),
            $print = $($this.data('id'));
        $('.buttons:not(.buttons' + $this.data('id') + ')').hide();

        if ($print.css('display') == 'none')
            $print.show();
        else
            $print.hide();
    });

    $(document).on('change', '.courier', function () {
        let order_id = $(this).parents('tr').attr('id');
        let courier_id = $(this).find(':selected').val();

        $.ajax({
            type: 'post',
            url: url('orders/update_courier'),
            data: {order_id, courier_id},
            success: answer => successHandler(answer, true),
            error: answer => errorHandler(answer)
        });
    });

    $body.on('click', '.preview', function () {
        let id = $(this).parents('tr').attr('id');

        function ajax() {
            $.ajax({
                type: 'post',
                url: url('orders/preview'),
                data: {id},
                success: function (answer) {
                    $('#preview_' + id).html(answer);
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        }

        let isSet = false;

        $('.preview_container').each(function () {
            if ($(this).html() != '')
                isSet = true;
        });

        if (!isSet) {
            ajax();
        } else {
            if ($('#preview_' + id).html() != '') {
                $('.preview_container').html('');
            } else {
                $('.preview_container').html('');
                ajax();
            }
        }
    });

    $body.on('click', '#route_list', function () {
        var url = '';
        $('.order-row').each(function () {
            url += url == '' ? $(this).attr('id') : ':' + $(this).attr('id');
        });

        window.open('/orders?section=route_list&ids=' + url, '_blank');
    });

    $body.on('click', '#more_filters', function () {
        $('.filter_more').toggleClass('none');
    });

});