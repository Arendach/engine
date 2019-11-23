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

    $body.on('change', '.courier', function () {
        var id = $(this).parents('tr').attr('id');
        var courier = $(this).find(':selected').val();

        var data = {
            id: id,
            courier: courier,
            action: 'update_courier'
        };

        $.ajax({
            type: 'post',
            url: url('orders'),
            data: data,
            success: function (answer) {
                successHandler(answer, true);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('click', '.preview', function () {
        var id = $(this).parents('tr').attr('id');

        function ajax() {
            $.ajax({
                type: 'post',
                url: url('orders'),
                data: {id: id, action: 'preview'},
                success: function (answer) {
                    $('#preview_' + id).html(answer);
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        }

        var is_set = false;

        $('.preview_container').each(function () {
            if ($(this).html() != '')
                is_set = true;
        });

        if (!is_set) {
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