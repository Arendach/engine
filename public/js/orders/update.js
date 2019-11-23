$(document).ready(function () {

    var $body = $('body');

    $('#phone').inputmask("999-999-99-99");  //static mask
    $('#phone2').inputmask("999-999-99-99");  //static mask
    $('#phone_number').inputmask("+380999999999");  //static mask

    /**
     * Товари
     */
    if ($('.product').length > 0) $('#price').show();

    function check_price() {
        var sum = 0;
        $('.product').each(function () {
            var $this = $(this);
            var amount = $this.find('.el_amount').val();
            var price = $this.find('.el_price').val();

            var remained = $('tr.product[data-id=' + $this.data('id') + ']').find('.count_on_storage').val();

            if (remained != 'n') {
                $('tr.product[data-id=' + $this.data('id') + ']').each(function () {
                    remained = +remained;
                    remained += +$(this).find('.amount_in_order').val() - +$(this).find('.el_amount').val();
                });
            }

            $this.find('.remained').html(remained);

            $this.find('.el_sum').val(+amount * +price);
            sum += (+amount * +price);
        });

        $('#sum').val(sum);
        $('#full_sum').val(+sum - +$('#discount').val() + +$('#delivery_cost').val());
    }

    $body.on('keyup', '.count', check_price);

    $body.on('click', '.but', function () {
        $('.new_product_block').toggleClass('none');
    });

    $body.on('click', '#save_price', function (event) {
        event.preventDefault();

        var data = {};
        data.products = [];
        data.data = {};
        $('#list_products .product').each(function () {
            var object = {};
            var $this = $(this);
            object['id'] = $this.data('id');
            object['pto'] = $this.data('pto');
            object['storage'] = $this.find('.storage').val();
            object['attributes'] = {};

            $this.find('.product_field').each(function () {
                object[$(this).data('name')] = $(this).val();
            });

            $this.find('.attributes select').each(function () {
                var key = $(this).attr('data-key');
                object.attributes[key] = $(this).find(':selected').val();
            });
            data.products.push(object);
        });

        data.data.delivery_cost = $('#delivery_cost').val();
        data.data.discount = $('#discount').val();

        data.id = id;
        data.action = 'update_products';

        $.ajax({
            type: 'post',
            url: url('orders'),
            data: data,
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('click', '.drop_product', function (event) {
        event.preventDefault();

        var $this = $(this);

        if ($this.data('id') == 'remove') {
            $this.parents('tr').remove();
            check_price();
            return false;
        }

        delete_on_click(function () {
            $.ajax({
                type: 'post',
                url: url('orders'),
                data: {pto: $this.parents('tr').data('pto'), action: 'drop_product'},
                success: function (answer) {
                    successHandler(answer, true);
                    $this.parents('tr').remove();
                    check_price();
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        });
    });

    $body.on('click', '#select_products', function () {
        var arr_products = Elements.select('#products').getMultiSelectedWithData();
        var has_id = [];
        $.each($('#list_products tr.product'), function (index, value) {
            has_id.push($(this).data('id'));
        });

        if (arr_products.length == 0) return false;

        $.ajax({
            url: url('orders'),
            data: {
                products: arr_products,
                type: type,
                action: 'get_products'
            },
            dataType: 'html',
            method: 'post',
            success: function (answer) {
                $('#list_products tbody').append(answer);
                $('#price').css('display', 'block');
            }
        });
    });


    /**
     * СМС розсилка
     */
    $body.on('change', '#sms_template', function () {
        var data = {
            order_id: id,
            template_id: $(this).val(),
            action: 'prepare_template'
        };

        $.ajax({
            type: 'post',
            url: url('sms'),
            data: data,
            success: function (answer) {
                $('#text').html(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    /**
     * Постійний клієнт
     */
    $body.on('keyup', '#search_name', function () {
        var name = $(this).val();
        if (name.length > 2) {
            $.ajax({
                type: 'post',
                url: url('/clients'),
                data: {
                    action: 'search_clients',
                    name: name
                },
                success: function (answer) {
                    if (answer.length == '') {
                        $('#place_for_search_result').html('');
                        $('#add_order_to_client').attr('disabled', 'disabled');
                    } else {
                        $('#place_for_search_result').html(answer);
                    }
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        }
    });

    $body.on('click', '#add_order_to_client', function () {
        var client_id = $('.active_client_item').data('id');

        $.ajax({
            type: 'post',
            url: url('clients'),
            data: {
                action: 'add_order_to_client',
                client_id: client_id,
                order_id: id
            },
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('click', '.client_item', function () {
        $('.client_item').removeClass('active_client_item');
        $(this).addClass('active_client_item');
        $('#add_order_to_client').removeAttr('disabled');
    });

    $body.on('click', '#close_clients_search', function () {
        $('#place_for_search_result').html('');
        $('#add_order_to_client').attr('disabled', 'disabled');
        $('#search_name').val("");
        $('#add_order_to_client').attr('disabled', 'disabled');
    });

    $body.on('submit', '[data-type=update_order_status]', function (event) {
        event.preventDefault();

        var data = $(this).serializeJSON();

        var close_status = data.type == 'shop' ? 2 : 4;

        function update_status(data) {
            data.action = 'update_status';

            $.ajax({
                type: 'post',
                url: url('orders'),
                data: data,
                success: function (answer) {
                    successHandler(answer, function () {
                        // swal.close();
                    });
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        }

        function get_close_form(data) {
            data.action = 'close_form';

            $.ajax({
                type: 'post',
                url: url('orders'),
                data: data,
                success: function (answer) {
                    myModalOpen(answer);
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        }

        pin_code(function () {
            if (data.status != close_status) {
                update_status(data);
            } else {
                data = {id: data.id, status: data.status, action: ''};
                closed_order == 1 ? update_status(data) : get_close_form(data);
            }
        });
    });

    $(document).on('change', '#storage',  function () {
        $('#products').html('');
    });
});