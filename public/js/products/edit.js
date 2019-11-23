$(document).ready(function () {
    var button = $('#image_upload');
    new AjaxUpload(button, {
        action: url('/products/upload_image'),
        name: 'image_upload',
        data: {id: id},
        onComplete: function (file, a) {
            try {
                var answer = JSON.parse(a);
                if (answer.status == '1') {
                    $('.thumbnail_img').append(
                        '<div class="img_wrap">' +
                        '<img src="' + answer.url + '" class="img-thumbnail" height="200px">' +
                        '<span data-path="' + answer.url + '" class="deleteImg">X</span>' +
                        '</div>');
                    swal({
                        title: "Виконано",
                        type: "success",
                        text: answer.message
                    });
                } else {
                    swal({
                        title: "Помилка",
                        type: "error",
                        text: answer.message
                    });
                }
            } catch (err) {
                swal({
                    title: "Невідома помилка!",
                    type: "error"
                });
            }
        }
    });

    $(document).on('click', '.delete_image', function () {
        var src = $(this).attr('data-src');

        swal({
            title: "Дійсно видалити?",
            text: "Відмінити дію буде неможливо!",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Видалити!",
            closeOnConfirm: false,
            html: false
        }, function () {
            $.ajax({
                type: 'post',
                url: url('/delete_temp_file'),
                data: {
                    path: src
                },
                success: function (answer) {
                    successHandler(answer)
                },
                error: function (answer) {
                    errorHandler(answer)
                }
            });
        });
    });

    $(document).on('click', '#update-attribute', function (event) {
        event.preventDefault();
        var attribute = {};

        $('input.attribute').each(function () {
            var name = $(this).attr('data-name');
            if (Array.isArray(attribute[name])) {
                attribute[name].push($(this).val());
            } else {
                attribute[name] = [];
                attribute[name].push($(this).val());
            }
        });

        $.ajax({
            type: 'post',
            url: url('/products/update'),
            data: {
                id: id,
                method: 'attribute',
                data: attribute
            },
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $(document).on('keyup', '#search_characteristic', function () {
        var value = $(this).val();
        if (value == '') return $('.characteristic_search_result').html('');

        var not = [];
        $('.characteristic').each(function () {
           not.push($(this).data('id'));
        });

        $.ajax({
            type: 'post',
            url: url('product'),
            data: {
                action: 'search_characteristics',
                name: value,
                not: not
            },
            success: function (answer) {
                $('.characteristic_search_result').html(answer);
            }
        })
    });

    $(document).on('click', '.get_searched_characteristic', function () {
        var $this = $(this);

        $.ajax({
            type: 'post',
            url: url('product'),
            data: {
                action: 'get_searched_characteristic',
                id: $this.data('id')
            },
            success: function (answer) {
                $('.characteristics').prepend(answer);
                $this.remove();
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $(document).on('click', '.delete_characteristic', function () {
        $(this).parents('.characteristic').fadeOut().remove();
    });

    $(document).on('click', '.close_characteristic_search_result', function () {
        $('#search_characteristic').val('');
        $('.characteristic_search_result').html('');
    });


});
