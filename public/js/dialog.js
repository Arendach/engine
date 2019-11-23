$(document).ready(function () {

        var wrap = $('#message-wrap');
    wrap.height(+$(window).height() - 150);

    $(window).resize(function () {
        var wrap = $('#message-wrap');
        wrap.height(+$(window).height() - 150);
    });

    var $body = $('body');

    $body.on('click', '.dialog-media', function () {
        window.location.href = $(this).attr('href');
    });

    $body.on('submit', '#send_text_message', function (event) {
        event.preventDefault();

        var data = $(this).serializeJSON();

        data.action = 'send_text_message';

        $.ajax({
            type: 'post',
            url: url('/dialog'),
            data: data,
            success: function (answer) {
                var a = JSON.parse(answer);

                $('#message-wrap').prepend(a.message);
                $('textarea[name=message]').val('');
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('submit', '#send_youtube_message', function (event) {
        event.preventDefault();

        var data = $(this).serializeJSON();

        data.action = 'send_youtube_message';

        $.ajax({
            type: 'post',
            url: url('/dialog'),
            data: data,
            success: function (answer) {
                var a = JSON.parse(answer);

                $('#message-wrap').prepend(a.message);
                $('input[name=link]').val('');
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    if (typeof dialog_id != "undefined") {
        setInterval(function () {
            var data = {
                last_message: $('#message-wrap :first-child').data('id'),
                dialog_id: dialog_id,
                action: 'search_new_message'
            };

            $.ajax({
                type: 'post',
                url: url('/dialog'),
                data: data,
                success: function (answer) {
                    if (answer.length > 0) {
                        $('<audio id="chatAudio">' +
                            '<source src="public/notification.mp3" type="audio/mpeg">' +
                            '</audio>').appendTo('body');
                        $('#chatAudio')[0].play();
                    }

                    $('#message-wrap').prepend(answer);
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        }, 4000);
    }

    $body.on('click', '.switch', function () {
        $('#form_crete_dialog').toggleClass('none');
    });

    $body.on('submit', '#form_crete_dialog', function (event) {
        event.preventDefault();

        var data = $(this).serializeJSON();
        data.action = 'create_dialog';
        data.users = Elements.select('.select').getMultiSelected();

        $.ajax({
            type: 'post',
            url: url('/dialog'),
            data: data,
            success: function (answer) {
                var a = JSON.parse(answer);
                window.location.href = url('/dialog?section=view&dialog_id=' + a.id);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('click', '.tab_head', function () {
        $('.tab_body').hide();
        $('.tab_head').css('background-color', '#fff');
        $(this).css('background-color', '#eee');
        $('#' + $(this).data('id')).show();
    });

    $body.on('click', '.tab_close', function () {
        $(this).parents('.tab_body').hide();
        $('.tab_head').css('background-color', '#fff');
    });

    $('#drop a').click(function () {
        $(this).parent().find('input').click();
    });

    $('#upload_file').fileupload({
        dropZone: $('#drop'),
        add: function (e, data) {
            data.submit();
        },
        progress: function (e, data) {
            // dd(data);
        },
        fail: function (e, data) {
            error_popup('Файл не завантажено!');
        },
        done: function (e, data) {
            try {
                var answer = data.jqXHR.responseText;
                var a = JSON.parse(answer);
                $('#message-wrap').prepend(a.message);
            } catch (err) {
                error_popup('Файл не завантажено!');
            }
        }
    });

    $('#upload_photo').fileupload({
        dropZone: $('#drop'),
        add: function (e, data) {
            data.submit();
        },
        progress: function (e, data) {
            // dd(data);
        },
        fail: function (e, data) {
            error_popup('Файл не завантажено!');
        },
        done: function (e, data) {
            try {
                var answer = data.jqXHR.responseText;
                var a = JSON.parse(answer);
                $('#message-wrap').prepend(a.message);
            } catch (err) {
                error_popup('Файл не завантажено!');
            }
        }
    });

    $(document).on('drop dragover', function (e) {
        e.preventDefault();
    });

});
