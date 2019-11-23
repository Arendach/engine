$(document).ready(function () {

    var $body = $('body');

    function add_margin() {
        if ($('.search_combine_result').length > 0) $('.search_combine_result').css('margin-bottom', '15px');
        else $('.search_combine_result').css('margin-bottom', '0px');
    }

    function change_sum() {
        var sum = 0;
        $('.combine_products_item').each(function () {
            var amount = $(this).find('.amount').val();
            var costs = $(this).find('.price').val();
            sum += +costs * +amount;
        });

        $('[name="costs"]').val(sum);

        add_margin();
    }

    add_margin();

    $body.on('input', '.combine_products_item input', change_sum);

    $body.on('click', '.delete_combine_product', function () {
        $(this).parents('.combine_products_item').remove();
        change_sum();
    });

    $body.on('click', '#close_search_combine_result', function () {
        $('.search_combine_result').html('');
        $('#search_products_to_combine').val('');
    });

    $body.on('change', '[name="combine"]', function () {
        var $wrap = $('.combine_wrapper');
        if ($(this).val()) $wrap.show(); else $wrap.hide();
    });

    $body.on('keyup', '#search_products_to_combine', function () {
        var value = $(this).val();
        var not = [];

        $('.combine_products_item').each(function () {
            not.push($(this).data('id'));
        });

        $.ajax({
            type: 'post',
            url: url("product"),
            data: {
                value: value,
                action: 'search_products_to_combine',
                not: not
            },
            success: function (answer) {
                $('.search_combine_result').html(answer);
            }
        });
    });

    $body.on('click', '.get_product_to_combine', function (event) {
        event.preventDefault();

        var id = $(this).data('id');
        var $this = $(this);

        $.ajax({
            type: 'post',
            url: url("product"),
            data: {
                id: id,
                action: 'get_product_to_combine'
            },
            success: function (answer) {
                $('.combine_products_list').prepend(answer);
                $this.remove();
                change_sum();
            }
        });
    });

    function filter_products() {
        var data = {};
        $('[data-action=search]').each(function () {
            data[$(this).data('column')] = $(this).val();
        });

        GET.setObject(data).unset('page').unsetEmpty().go();
    }

    $body.on('click', '#search', function () {
        filter_products();
    });

    $body.on('keyup', '[data-action=search]', function (e) {
        if (e.which == 13) filter_products();
    });

    $body.on('change', 'select[data-action=search]', function (e) {
        filter_products();
    });

    $body.on('click', '.sort', function (event) {
        event.preventDefault();
        GET.set('order_field', $(this).data('field')).set('order_by', $(this).data('by')).go();
    });


    $body.on('click', '.copy', function (event) {
        event.preventDefault();
        var amount = prompt('Ведіть кількість копій!', '1');
        $.ajax({
            type: 'post',
            url: url('product'),
            data: {
                id: id,
                amount: amount,
                action: 'copy'
            },
            success: function (answer) {
                successHandler(answer, function () {
                    window.location.href = url('product');
                });
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });


    $body.on('keyup', '#search_attribute', function () {
        var $this = $(this);

        if ($this.val().length == 0 || $this.val() == ' ') {
            $('.attribute_search_result').html('');
            return;
        }

        $.ajax({
            type: 'post',
            url: url('product'),
            data: {
                value: $this.val(),
                action: 'search_attribute'
            },
            success: function (answer) {
                $('.attribute_search_result').html(answer);
            }
        });
    });

    $body.on('click', '.get_searched_attribute', function (e) {
        e.preventDefault();

        var $this = $(this);

        $.ajax({
            type: 'post',
            url: url('product'),
            data: {
                id: $this.data('id'),
                action: 'get_searched_attribute'
            },
            success: function (answer) {
                $('#attribute_list').prepend(answer);
                $this.remove();
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('click', '.delete_attribute_variant', function () {
        if ($(this).parents('.row').parent().find('.row').length > 2)
            $(this).parents('.row').remove();
    });

    $body.on('click', '.add_attribute_value', function (event) {
        event.preventDefault();
        var $input = $(this).parents('.panel-body').find('.row').last();
        var $clone = $input.clone(true, true);
        $input.after($clone);
    });

    $body.on('click', '.close_attribute_search_result', function () {
        $('.attribute_search_result').html('');
        $('#search_attribute').val('');
    });

    $body.on('click', '.delete_attribute', function () {
        $(this).parents('.attribute_item').remove();
    });

    $body.on('keyup', '[name="volume[]"]', function () {
        var sum = 1;
        $('[name="volume[]"]').each(function () {
            sum *= +$(this).val();
        });
        $('#volume').val(sum / 1000000);
    });


    $body.on('click', '.print_products', function () {
        var url = {};
        $('[data-action=search]').each(function () {
            url[$(this).data('column')] = $(this).val();
        });

        url.section = 'print';

        GET.setObject(url).unsetEmpty().setDomain('/product').redirect();
        $(this).blur();
    });

    $body.on('click', '.pts_more', function () {
        var id = $(this).data('id');

        $.ajax({
            type: 'post',
            url: url('product'),
            data: {
                action: 'pts_more',
                id: id
            },
            success: function (answer) {
                $('.pts_more_' + id).html(answer).show();
            }
        });
    });

    $body.on('click', ':not(.pts_more_item)', function () {
        $('.pts_more_item').hide();
    });

    $body.on('click', '.more', function () {
        $('.filters').toggleClass('none');
    });

    $body.on('click', '.filters_ok', function () {
        GET.set('items', $('[name=items]').val()).go();
    });

    $body.on('click', '.print_tick', function () {
        let selected = Elements.getCheckedValues('table', '.product_item');

        GET.setObject({
            section: 'print_tick',
            ids: selected.toString()
        }).redirect();
    });

    $body.on('click', '.print_stickers', function () {
        let selected = Elements.getCheckedValues('table', '.product_item');

        GET.setObject({
            section: 'print_stickers',
            ids: selected.toString()
        }).redirect();
    });
});