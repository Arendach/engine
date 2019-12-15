$(document).ready(function () {
    var $body = $('body');

    $body.on('change', '#type_coupon', function (event) {
        event.preventDefault();

        var form = $(this).val() === '1' ? 'cumulative' : 'stationary';

        $.ajax({
            type: 'post',
            url: url('coupon'),
            data: {
                action: form + '_form'
            },
            success: function (a) {
                $('#for-form').html(a);
            }

        });
    });

    $body.on('submit', '#update_coupon', function (event) {
        event.preventDefault();
        var data = $(this).serializeJSON();

        if (data.type == 0) {
            data.type = 'stationary';
        } else {
            data.type = 'cumulative';
            data.cumulative = [];
            $('.rows').each(function () {
                var id = $(this).attr('id');
                var obj = {};
                $('#' + id + ' .cumulative').each(function () {
                    obj[$(this).data('name')] = $(this).val();
                });
                data.cumulative.push(obj);
            });
        }

        data.action = 'update';

        $.ajax({
            type: 'post',
            url: url('coupon'),
            data: data,
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('mouseenter', '[data-toggle="tooltip"]', function () {
        $('[data-toggle="tooltip"]').tooltip();
    });

    $body.on('submit', '#create_coupon', function (event) {
        event.preventDefault();

        var data = $(this).serializeJSON();

        data.cumulative = [];
        $('.rows').each(function () {
            var id = $(this).attr('id');
            var obj = {};
            $('#' + id + ' .field2').each(function () {
                obj[$(this).attr('name')] = $(this).val();
            });
            data.cumulative.push(obj);
        });

        data.action = 'create';

        $.ajax({
            type: 'post',
            url: url('coupon'),
            data: data,
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('click', '.plus', function (event) {
        event.preventDefault();
        var $last_child = $('#asd > tbody > tr:last-child');
        if ($last_child.attr('id') !== undefined) {
            var id = 'row' + (+str_to_int($last_child.attr('id')) + 1);
        } else {
            var id = 'row1';
        }

        $('#asd > tbody').append(' <tr class="rows" id="' + id + '">' +
            '            <td><input class="field2" name="sum"></td>' +
            '            <td>' +
            '                <select name="operator" class="field2">' +
            '                    <option value="0"><</option>' +
            '                    <option value="1">=</option>' +
            '                    <option value="2">></option>' +
            '                </select>' +
            '            </td>' +
            '            <td>' +
            '                <input class="field2" name="discount">' +
            '            </td>' +
            '            <td>' +
            '                <select class="field2" name="type">' +
            '                    <option value="0">%</option>' +
            '                    <option value="1">грн</option>' +
            '                </select>' +
            '            </td>' +
            '            <td>' +
            '                <button class="del_row btn btn-danger btn-xs del">' +
            '                    <span class="glyphicon glyphicon-remove"></span>' +
            '                </button>' +
            '            </td>' +
            '        </tr>');
    });


    $body.on('click', '.del_row', function (event) {
        event.preventDefault();
        var $parent = $(this).parents('.rows');
        $parent.remove();
    });
});
