document.ElementsExists = false;
document.inputCache = '';

String.prototype.replaceAll = function (search, replace) {
    return this.split(search).join(replace);
};

$(document).ready(function () {

    var $body = $('body');

    $('[data-toggle="tooltip"]').tooltip();
    $('[data-toggle="popover"]').popover();

    $('input').attr('autocomplete', 'off');


    // Валідація поля типу decimal
    $body.on('focus', '[data-inspect]', function () {
        document.inputCache = $(this).val();
    });

    $body.on('focusout', '[data-inspect]', function () {
        document.inputCache = '';
    });

    $body.on('keyup', '[data-inspect="decimal"]', function () {
        var value = $(this).val();
        if (value != '') {
            value = value.replaceAll(/\,/, '.');
            value = value.replaceAll(/\s/, '');
            value = value.replaceAll(/[a-zA-Zа-яА-Я]/, '');
            value = value.replaceAll(/[\!\@\#\$\%\^\&\*\(\)\=\_\`\~\'\\\|\/\+\:\;\>\<\?]/, '.');

            var point_counter = value.match(/(\.)/g) === null ? 0 : value.match(/(\.)/g).length;

            if (point_counter == 1) {
                var split = value.split('.', 2);
                if (split[1].length > 2) value = document.inputCache;
            } else if (point_counter > 1) {
                value = document.inputCache;
            }

            document.inputCache = value;

            $(this).val(value);
        }
    });

    $body.on('keyup', '[data-inspect="integer"]', function () {
        var value = $(this).val();

        var minus = (value.match(/\-/));

        if (value != '') {
            value = value.replaceAll(/\D/, '');

            if (minus) value = "-" + value;

            $(this).val(value);
        }
    });


    $body.on('submit', '[data-type="ajax"]', function (event) {
        event.preventDefault();
        var data = $(this).serializeJSON();
        var url = $(this).attr('action');
        var redirect_url = $(this).data('url');
        var success = $(this).data('success');

        if (document.ElementsExists) data = Elements.customFormSerializePush(data, this);

        var $form = $(this);
        $form.find('button').attr('disabled', 'disabled');

        function ajax_send123() {
            $.ajax({
                type: 'post',
                url: url,
                data: data,
                success: function (answer) {
                    if (success == 'redirect') {
                        successHandler(answer, function () {
                            redirect(redirect_url);
                        });
                    } else {
                        successHandler(answer);
                    }
                    $form.find('button').removeAttr('disabled');
                },
                error: function (answer) {
                    errorHandler(answer);
                    $form.find('button').removeAttr('disabled');
                }
            });
        }

        if ($(this).data('pin_code') !== undefined)
            pin_code(function () {
                ajax_send123();
            });
        else
            ajax_send123();
    });

    $body.on('click', '[data-type="delete"]', function (event) {
        event.preventDefault();

        var id = $(this).data('id');
        var uri = $(this).data('uri');
        var action = $(this).data('action');
        var post = $(this).data('post');

        if (post !== undefined)
            var data = post + '&action=' + action;
        else
            var data = {id: id, action: action};

        delete_on_click(function () {
            $.ajax({
                type: 'post',
                url: uri,
                data: data,
                success: function (answer) {
                    successHandler(answer);
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });
        });
    });

    $body.on('click', '[data-type="get_form"]', function (event) {
        event.preventDefault();
        var uri = $(this).data('uri');
        var action = $(this).data('action');
        var post = $(this).data('post');
        var data = post == undefined ? 'action=' + action : post + '&action=' + action;
        var $this = $(this);

        $this.attr('disabled', 'disabled');

        $.ajax({
            type: 'post',
            url: uri,
            data: data,
            success: function (answer) {
                myModalOpen(answer);
                $this.removeAttr('disabled');
            },
            error: function (answer) {
                errorHandler(answer);
                $this.removeAttr('disabled');
            }
        });
    });

    $body.on('click', '[data-type="ajax_request"]', function (event) {
        event.preventDefault();

        var uri = $(this).data('uri');
        var data = $(this).data('post');
        var action = $(this).data('action');

        data = data + '&action=' + action;

        $.ajax({
            type: 'post',
            url: uri,
            data: data,
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });

    $body.on('click', '#map-signs', function (event) {
        event.preventDefault();
        var left_bar = $('#left_bar');
        var content = $('#content');

        if (left_bar.hasClass('mini-bar')) {
            left_bar.toggleClass('navigation', true);
            left_bar.toggleClass('mini-bar', false);
            $.cookie('left_bar_template_class', 'navigation', {expires: 5});
        } else {
            left_bar.toggleClass('navigation', false);
            left_bar.toggleClass('mini-bar', true);
            $.cookie('left_bar_template_class', 'mini-bar', {expires: 5});
        }

        if (content.hasClass('content-mini')) {
            content.toggleClass('content-big', true);
            content.toggleClass('content-mini', false);
            $.cookie('content_template_class', 'content-big', {expires: 5});
        } else {
            content.toggleClass('content-big', false);
            content.toggleClass('content-mini', true);
            $.cookie('content_template_class', 'content-mini', {expires: 5});

        }
    });

    $body.on('click', '.hiden', function () {
        var id = '#' + $(this).data('id');
        $(id).hide();
    });

    $body.on('click', '#clean', function (event) {
        event.preventDefault();
        $.ajax({
            type: 'post',
            url: url('/api/clean'),
            success: function () {
                alert('Кеш та тимчасові файли вдало видалено!');
            }
        })
    });

    $body.on('hide.bs.modal', '.modal', function () {
        $(this).remove();
    });

    var url = document.location.toString();
    if (url.match('#')) {
        $('.nav-pills a[href="#' + url.split('#')[1] + '"]').tab('show');
    }

    $('.nav-pills a').on('shown.bs.tab', function (e) {
        window.location.hash = e.target.hash;
    });

    $('a[data-type="pin_code"]').on('click', function () {
        var href = $(this).data('href');
        pin_code(function () {
            window.location.href = href;
        });
    });
});

/**
 * @param str
 * @returns {string|XML|void}
 */
function str_to_int(str) {
    return str.replace(/\D+/g, "");
}


/**
 * @returns {*}
 */
function getParameters() {
    var Pattern = /[\?][\w\W]+/;
    var getParameters = document.location.href.match(Pattern);
    return getParameters !== null ? getParameters : '';
}

/**
 * @param type
 * @param description
 */
function log(type, description) {
    $.ajax({
        type: 'post',
        url: url('/log'),
        data: {
            type: type,
            desc: description,
        }
    });
}

/**
 * @param desc
 */
function elog(desc) {
    log('error_in_javascript_file', desc);
}

/**
 * @param str
 * @returns {boolean}
 */
function dd(str) {
    console.log(str);
    return false;
}

/**
 * @param url
 */
function redirect(url) {
    window.location.href = url;
}

/**
 * @param path
 * @returns {*}
 */
function url(path) {
    path = path.replace(/^\//, '');
    return my_url + '/' + path;
}


/**
 * @param attribute, default = name
 * @returns {{}}
 */
function get_fields(attribute) {
    var data = {};
    $('.field').each(function () {
        if (attribute === undefined)
            data[$(this).attr('name')] = $(this).val();
        else
            data[$(this).attr(attribute)] = $(this).val();
    });

    return data;
}