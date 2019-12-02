$(document).ready(function () {

    var $body = $('body');

    $('#phone').inputmask("999-999-99-99");  //static mask
    $('#phone2').inputmask("999-999-99-99");  //static mask

    function get_products() {
        var data = [];
        $('.product').each(function () {
            var object = {};
            var $this = $(this);
            object['id'] = $this.data('id');
            object['amount'] = $this.find('.el_amount').val();
            object['price'] = $this.find('.el_price').val();
            object['place'] = $this.find('.place').val();
            object['storage'] = $this.find('.storage').val();
            var attributes = object['attributes'] = {};
            $this.find('.attributes select').each(function () {
                var $select = $(this);
                attributes[$select.data('key')] = $select.find(':selected').val();
            });
            data.push(object);
        });
        return data;
    }

    $body.on('click', '#select_products', function (event) {
        event.preventDefault();

        var arr_products = Elements.select('#products').getMultiSelectedWithData();

        if (arr_products.length == 0) return false;

        $.ajax({
            type: 'post',
            url: url('orders'),
            data: {
                products: arr_products,
                type: type,
                action: 'get_products'
            },
            success: function (answer) {
                $('#list_products tbody').append(answer);
                check_price();
            }
        });

        return false;
    });

    $(document).on('submit', '#create_order', function (event) {
        event.preventDefault()

        let data = $(this).serializeJSON()

        $.ajax({
            type: 'post',
            url: '/orders/create_' + type,
            data,
            //success: answer => //window.location.href = answer.location,
            error: answer => errorHandler(answer)
        })
    });

    $body.on('click', '.drop_product', function () {
        $(this).parents('tr').remove();
        check_price();
    });

    $body.on('change', '#delivery', function () {
        if ($(this).val() == 'НоваПошта') {
            $('#address_container').html(' <div class="form-group">\n' +
                '            <label class="col-md-4 control-label" for="city_input">Місто <span class="text-danger">*</span></label>\n' +
                '            <div class="col-md-5">\n' +
                '                <div class="input-group">\n' +
                '                    <input class="form-control" placeholder="Введіть 3 символи" id="city_input">\n' +
                '                    <span class="input-group-addon pointer clear" data-id="city_input">X</span>\n' +
                '                </div>\n' +
                '            </div>\n' +
                '        </div>\n' +
                '\n' +
                '        <input type="hidden" name="city" id="city" class="form-control">\n' +
                '        \n' +
                '        <div class="form-group none" id="city_select_container">\n' +
                '            <label class="col-md-4 control-label" for="city_select"></label>\n' +
                '            <div class="col-md-5">\n' +
                '                <select id="city_select" class="form-control" multiple></select>\n' +
                '                <span class="btn btn-danger btn-xs hiden close_multiple" data-id="city_select_container">X</span>\n' +
                '            </div>\n' +
                '        </div>\n' +
                '        \n' +
                '        <div class="form-group">\n' +
                '            <label class="col-md-4 control-label" for="warehouse">\n' +
                '                Відділення <span class="text-danger">*</span>\n' +
                '            </label>\n' +
                '            <div class="col-md-5">\n' +
                '                <select disabled id="warehouse" name="warehouse" class="form-control"></select>\n' +
                '            </div>\n' +
                '        </div>\n' +
                '        \n' +
                '        <div class="form-group none">\n' +
                '            <label class="col-md-4 control-label" for="warehouse_search"></label>\n' +
                '            <div class="col-md-5">\n' +
                '                <select id="warehouse_search" name="warehouse_search" class="form-control" multiple></select>\n' +
                '            </div>\n' +
                '        </div>');
        } else {
            $('#address_container').html('<div class="form-group">\n' +
                '    <label class="col-md-4 control-label" for="city">Місто <span class="text-danger">*</span></label>\n' +
                '    <div class="col-md-5">\n' +
                '        <input class="form-control" name="city" id="city">\n' +
                '    </div>\n' +
                '</div>\n' +
                '\n' +
                '<div class="form-group">\n' +
                '    <label class="col-md-4 control-label" for="warehouse">\n' +
                '        Відділення <span class="text-danger">*</span>\n' +
                '    </label>\n' +
                '    <div class="col-md-5">\n' +
                '        <input id="warehouse" name="warehouse" class="form-control">\n' +
                '    </div>\n' +
                '</div>');
        }
    });

    $body.on('keyup', '#phone', function () {
        $('[name="client_id"]').remove();
    });

    $body.on('keyup', '#fio', function () {
        var $this = $(this);

        $('[name="client_id"]').remove();

        if ($this.val().length > 2) {
            $.ajax({
                type: 'post',
                url: url('orders'),
                data: {
                    fio: $this.val(),
                    action: 'search_clients'
                },
                success: function (answer) {
                    $('.search_clients').html(answer);
                },
                error: function (answer) {
                    errorHandler(answer)
                }
            })
        } else {
            $('.search_clients').html('');
        }
    });

    $body.on('click', '.client', function () {
        var $this = $(this);
        $('#create_order').prepend('<input name="client_id" type="hidden" value="' + $this.data('value') + '">');
        $('#fio').val($this.text());
        $('#phone').val($this.data('phone'));
        $('.search_clients').html('');
    });

    function cashless(is_cashless) {
        if (is_cashless) {
            $('#discount').attr('disabled', 'disabled').val('');
            $('#delivery_cost').attr('disabled', 'disabled').val('');
        } else {
            $('#discount').removeAttr('disabled');
            $('#delivery_cost').removeAttr('disabled');
        }

        check_price();
    }

    cashless($('[name="pay_method"] option:selected').data('is_cashless'));

    $(document).on('change', '[name="pay_method"]', function () {
        let is_cashless = $(this).find('option:selected').data('is_cashless');

        cashless(is_cashless);
    });


});
