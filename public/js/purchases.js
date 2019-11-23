$(document).ready(function () {
    var $body = $('body');

    function search(data) {
        data.action = 'search_products';
        data.storage = purchase.storage;
        data.manufacturer = purchase.manufacturer;

        $.ajax({
            type: 'post',
            url: url('purchases'),
            data: data,
            success: function (answer) {
                $('#place_for_search').html(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        })
    }

    function check_sum() {
        var sum = 0;
        $('.product').each(function () {
            var temp = (+$(this).find('.amount').val() * +$(this).find('.price').val());
            $(this).find('.sum').val(temp);
            sum += temp;
        });
        $('#sum').val(sum);
    }

    function not() {
        var not = [];
        $('.product').each(function () {
            not.push($(this).data('id'));
        });
        return not;
    }

    $body.on('click', '[data-name=id]', function () {
        var $tr = $(this).parents('tr');

        if ($tr.hasClass('active-row'))
            $tr.removeClass('active-row');
        else
            $tr.addClass('active-row');
    });

    $body.on('click', '#update', function () {
        var data = {};
        data.products = [];
        data.sum = $('#sum').val();
        data.comment = $('#comment').val();

        $('.product').each(function () {
            var object = {};
            object.id = $(this).data('id');
            object.amount = $(this).find('.amount').val();
            object.price = $(this).find('.price').val();
            object.course = $(this).find('.course').val();
            data.products.push(object);
        });

        data.id = purchase.id;
        data.action = 'update';

        $.ajax({
            type: 'post',
            url: url('purchases'),
            data: data,
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });


    $body.on('click', '#create', function () {
        var data = {};
        data.products = [];
        data.manufacturer_id = purchase.manufacturer;
        data.storage_id = purchase.storage;
        data.sum = $('#sum').val();
        data.comment = $('#comment').val();
        data.action = 'create';

        $('.product').each(function () {
            var object = {};
            object.id = $(this).data('id');
            object.price = $(this).find('.price').val();
            object.amount = $(this).find('.amount').val();
            object.course = $(this).find('.course').val();
            data.products.push(object);
        });

        $.ajax({
            type: 'post',
            url: url('purchases'),
            data: data,
            success: function (answer) {
                successHandler(answer, function () {
                    redirect('/purchases');
                });
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    function filter_purchases() {
        var data = {};

        $('.filter').each(function () {
            data[$(this).data('column')] = $(this).val();
        });

        GET.setObject(data).unsetEmpty().go();
    }

    $body.on('click', '#filter', function () {
        filter_purchases();
    });

    $body.on('keyup', '.filter', function (e) {
        if (e.which == 13) filter_purchases();
    });

    $body.on('change', 'select.filter', function (e) {
        filter_purchases();
    });

    $body.on('change', '#categories_pr', function () {
        var id = $(this).val();

        search({
            field: 'category',
            data: id,
            not: not()
        });
    });

    $body.on('keyup', '#search_ser_code', function () {
        var data = $(this).val();

        if (data.length < 3) return false;

        search({
            field: 'service_code',
            data: data,
            not: not()
        });
    });

    $body.on('keyup', '#search_name', function () {
        var data = $(this).val();

        if (data.length < 3) return false;

        search({
            field: 'name',
            data: data,
            not: not()
        });
    });

    $body.on('click', '.product-item', function () {
        var $this = $(this);
        if ($this.hasClass('active-product')) {
            $this.removeClass('active-product');
        } else {
            $this.addClass('active-product');
        }
    });

    $body.on('click', '#select_products', function () {
        var products = [];
        $('.active-product').each(function () {
            products.push($(this).data('id'));
            $(this).remove();
        });

        $.ajax({
            type: 'post',
            url: url('purchases'),
            data: {
                action: 'get_products',
                products: products,
                storage: purchase.storage
            },
            success: function (answer) {
                $('table tbody').prepend(answer);
                check_sum();
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('keyup', '.price, .amount, .course', check_sum);

    $body.on('click', '.delete', function () {
        $(this).parents('tr').remove();
        check_sum();
    });
});