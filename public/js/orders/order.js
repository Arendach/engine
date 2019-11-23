$(document).ready(function () {

    var $body = $('body');

    function check_price() {
        var sum = 0;
        $('.product').each(function () {
            var $this = $(this);
            var amount = $this.find('.el_amount').val();
            var price = $this.find('.el_price').val();

            var remained = +$('tr.product[data-id=' + $this.data('id') + ']').find('.count_on_storage').val();
            $('tr.product[data-id=' + $this.data('id') + ']').each(function () {
                remained += +$(this).find('.amount_in_order').val() - +$(this).find('.el_amount').val();
            });
            $this.find('.remained').html(remained);

            $this.find('.el_sum').val(+amount * +price);
            sum += (+amount * +price);
        });

        $('#sum').val(sum);
        $('#full_sum').val(+sum - +$('#discount').val() + +$('#delivery_cost').val());
    }

    function search_warehouses(city_id) {
        $.ajax({
            type: 'post',
            url: url('/api/search_warehouses'),
            data: {
                city: city_id
            },
            success: function (answer) {
                $('#warehouse').html(answer).removeAttr('disabled');
            }
        });
    }

    $body.on('change', '.search_product input', function () {
        $('.search_product input').val('');
    });

    function search_products(data) {
        data.type = type;
        data.storage = $('#storage').val()

        console.log(data);

        $.ajax({
            type: 'post',
            url: url('/orders'),
            data: data,
            success: function (data) {
                $('.new_product_block .products').html(data);
            }
        });
    }

    $body.on('keyup', '#search_ser_code', function (event) {
        event.preventDefault();

        var $this = $(this);

        if ($this.val().length < 3) return false;

        search_products({
            services_code: $this.val(),
            action: 'search_products'
        });

    });

    $body.on('keyup', '#search_name_product', function (event) {
        event.preventDefault();

        var $this = $(this);

        if ($this.val().length < 3) return false;

        search_products({
            name: $this.val(),
            action: 'search_products',
            type: type
        });
    });

    $body.on('change', '#categories_pr', function () {
        var $this = $(this);
        if (!$this.val()) {
            $('.new_product_block .products').html('');
            return false;
        }
        search_products({
            category_id: $this.val(),
            action: 'search_products'
        });
    });

    $body.on('click', '.clear', function () {
        $('#' + $(this).data('id')).val('');
    });

    $body.on('change', '#city_select', function () {
        var $selected = $(this);
        var text = $selected.find('option:selected').text(), value = $selected.val();
        $('#city_input').val(text);
        search_warehouses(value[0]);
        $('#city').attr('value', value);
    });

    $body.on('focus', '#city_input', function () {
        $('#city_select').parents('.form-group').css('display', 'block');
    });

    $body.on('keyup', '#city_input', function () {
        if ($('#city_input').val().length > 2) {
            $.ajax({
                type: 'post',
                url: url('/api/get_city'),
                data: {
                    key: '123',
                    str: $('#city_input').val()
                },
                success: function (a) {
                    $('#city_select').html(a);
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        }
    });

    $body.on('keyup', '#coupon', function () {
        if ($('#coupon').val().length > 0) {
            $.ajax({
                type: 'post',
                url: url('/api/search_coupon'),
                data: {
                    key: '123',
                    str: $('#coupon').val()
                },
                success: function (a) {
                    try {
                        var answer = JSON.parse(a);
                        $('#coupon_search').html('');
                        for (var data in answer) {
                            $('#coupon_search').prepend('<option value="' + answer[data]['code'] + '">' + answer[data]['code'] + '(' + answer[data]['name'] + ')</option>');
                        }
                    } catch (err) {
                        console.log('error parse');
                    }
                }
            });
        }
    });

    $body.on('change', '#coupon_search', function () {
        var val = $('#coupon_search :selected').val();
        $('#coupon').val(val);
        $('#coupon_search').html('');
        $('#coupon_search').parents('.form-group').css('display', 'none');
    });

    $body.on('focus', '#coupon', function () {
        $('#coupon_search').parents('.form-group').css('display', 'block');
    });

});