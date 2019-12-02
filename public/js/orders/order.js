function checkPrice() {
    let sum = 0
    let discount = $('#discount').val();
    let delivery_cost = $('#delivery_cost').val();

    $('.product').each(function () {
        sum += +$(this).find('.sum').val();
    })

    $('#sum').val(sum)
    $('#full_sum').val(+sum - +discount + +delivery_cost)
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

$(document).on('keyup', '.amount, .price', function () {
    let $product = $(this).parents('.product')
    let amount = $product.find('.amount').val()
    let price = $product.find('.price').val()

    console.log(amount * price);
    $product.find('.sum').val(amount * price)

    checkPrice();
})

$(document).on('change keyup', '#search_field, #search_category', function () {
    let $this = $(this)

    let data = {
        search: $this.val(),
        type: $this.data('search')
    }

    $.post('/orders/search_products', data, res => $('.products').html(res))
})

$(document).on('click', '.searched', function () {
    let id = $(this).data('id')

    $.post('/orders/get_product', {type, id}, res => {
        $('#product-list tbody').append(res)
        checkPrice()
    })
})


$(document).on('change', '#city_select', function () {
    var $selected = $(this);
    var text = $selected.find('option:selected').text(), value = $selected.val();
    $('#city_input').val(text);
    search_warehouses(value[0]);
    $('#city').attr('value', value);
})

$(document).on('focus', '#city_input', function () {
    $('#city_select').parents('.form-group').css('display', 'block');
})

$(document).on('keyup', '#city_input', function () {
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
})

$(document).on('keyup', '#coupon', function () {
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
})

$(document).on('change', '#coupon_search', function () {
    var val = $('#coupon_search :selected').val();
    $('#coupon').val(val);
    $('#coupon_search').html('');
    $('#coupon_search').parents('.form-group').css('display', 'none');
})

$(document).on('focus', '#coupon', function () {
    $('#coupon_search').parents('.form-group').css('display', 'block');
})
