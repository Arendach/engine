document.ElementsExists = true;

$(document).ready(function () {

    let $body = $('body');

    $body.on('click', '.select > .option', function () {
        $(this).toggleClass('active');
    });

    $body.on('click', '.checkbox', function () {
        $(this).toggleClass('active');
    });

    $body.on('click', '.check_all', function () {
        let active = false;
        if ($(this).hasClass('active')) active = true;

        let parent;
        if ($(this).data('parent') === undefined) parent = $(this).parent();
        else parent = $(this).parents($(this).data('parent'));

        parent.find('.checkbox').each(function () {
            if (active) $(this).addClass('active');
            else $(this).removeClass('active');
        });
    });

    window.Elements = {
        selectElement: {},
        select: function (e) {
            this.selectElement = $(e);
            return this;
        },
        getMultiSelected: function () {
            let data = [];
            this.selectElement.find('.active').each(function () {
                data.push($(this).data('value'));
            });
            return data;
        },
        getMultiSelectedWithData: function () {
            let data = [];
            this.selectElement.find('.active').each(function () {
                data.push($(this).data());
            });
            return data;
        },
        getCheckbox: function (e) {
            return $(e).hasClass('active') ? 1 : 0;
        },
        formSerialize: function (e) {
            let data = {};

            $(e).find('.checkbox').each(function () {
                let name = $(this).data('name');
                data[name] = $(this).hasClass('active') ? 1 : 0;
            });

            $(e).find('.select').each(function () {
                let name = $(this).data('name');
                if (!(name in data))
                    data[name] = [];

                $(this).find('.active').each(function () {
                    data[name].push($(this).data('value'));
                });
            });

            return data;
        },
        formSerializePush: function (e, data) {

        },
        getCheckedValues: function (e, n) {
            if (n === undefined) n = '.checkbox';
            let data = [];
            $(e).find(n).each(function () {
                if ($(this).hasClass('active'))
                    data.push($(this).data('value'));
            });

            return data;
        },
        customFormSerializePush: function (d, f) {

            $(f).find('.checkbox').each(function (i, v) {
                let $this = $(this);
                let name = $this.data('name'); // *
                let value = $this.data('value');
                let key = $this.data('key');
                let check = $this.hasClass('active');

                if (typeof name == "undefined") return;

                if (name.match(/\[\]$/)) {
                    if (check) {
                        name = name.replace(/\[\]$/, '');
                        if (!(name in d)) d[name] = [];
                        if (typeof value != "undefined") d[name].push(value);
                    }
                } else if (name.match(/\[\]\*$/)) {
                    name = name.replace(/\[\]\*$/, '');
                    if (!(name in d)) d[name] = {};
                    key = typeof key != "undefined" ? key : i;
                    value = typeof value != "undefined" ? value : (check ? 1 : 0);
                    d[name][key] = value;
                } else {
                    d[name] = typeof value == "undefined" ? check : value;
                }
            });

            $(f).find('.select').each(function () {
                let $this = $(this);
                let name = $this.data('name'); // *

                d[name] = [];

                $this.find('.option').each(function (i, v) {
                    if ($(this).hasClass('active'))
                        d[name].push($(this).data('value'));
                });
            });

            return d;
        }
    };
});