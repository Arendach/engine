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

    $(document).on('click', '#save_price', function (event) {
        event.preventDefault()

        let data = {}

        data.products = []
        data.data = {}

        $('#list_products .product').each(function () {
            let object = {}
            let $this = $(this)
            object['id'] = $this.data('id')
            object['pto'] = $this.data('pto')
            object['storage'] = $this.find('.storage').val()
            object['attributes'] = {}

            $this.find('.product_field').each(function () {
                object[$(this).data('name')] = $(this).val()
            })

            $this.find('.attributes select').each(function () {
                let key = $(this).attr('data-key')
                object.attributes[key] = $(this).find(':selected').val()
            })
            data.products.push(object)
        })

        data.data.delivery_cost = $('#delivery_cost').val()
        data.data.discount = $('#discount').val()

        data.id = id

        $.ajax({
            type: 'post',
            url: url('orders/update_products'),
            data,
            success: answer => successHandler(answer),
            error: answer => errorHandler(answer)
        })
    });

    $(document).on('click', '.drop_product', function (event) {
        event.preventDefault()
        let $this = $(this)

        if ($this.data('id') == 'remove') {
            $this.parents('tr').remove()
            check_price()
            return false
        }

        delete_on_click(function () {
            $.ajax({
                type: 'post',
                url: url('orders/drop_product'),
                data: {
                    pto: $this.parents('tr').data('pto'),
                    order_id: $this.data('order-id')
                },
                success(answer) {
                    successHandler(answer, true)
                    $this.parents('tr').remove()
                    check_price()
                },
                error: answer => errorHandler(answer)
            })
        })
    })

    $(document).on('click', '#select_products', function () {
        let products = Elements.select('#products').getMultiSelectedWithData()

        if (products.length == 0) return false

        $.ajax({
            type: 'post',
            url: url('orders/get_products'),
            data: {products, type},
            dataType: 'html',
            success(answer) {
                $('#list_products tbody').append(answer)
                $('#price').css('display', 'block')
            }
        })
    })


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

        let url, success

        let data = $(this).serializeJSON()

        pin_code(function () {
            if (data.status != 4 || closed_order == 1) {
                url = '/orders/update_status'
                success = answer => successHandler(answer)
            } else {
                url = '/orders/close_form'
                success = answer => myModalOpen(answer)
            }

            $.ajax({
                type: 'post',
                url, data, success,
                error: answer => errorHandler(answer)
            })
        })
    })

    $(document).on('change', '#storage', function () {
        $('#products').html('');
    });
});