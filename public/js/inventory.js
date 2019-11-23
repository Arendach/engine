$(document).ready(function () {
    var $body = $("body");

    $body.on("click", "#find_products", function () {

        let manufacturer = $('#manufacturer').val();
        let storage = $('#storage').val();
        let category = $('#category').val();

        if (manufacturer == '') return alert('Виберіть виробника!');

        if (storage == '') return alert('Виберіть склад!');

        $.ajax({
            type: 'post',
            url: url('inventory'),
            data: {
                action: 'get_products',
                manufacturer: manufacturer,
                storage: storage,
                category: category
            },
            success: function (answer) {
                $('#place_for_products').html(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        })
    });

    $body.on("submit", "#inventory_create", function (event) {
        event.preventDefault();

        var products = {};

        $('.amount').each(function () {
            var $this = $(this);
            if ($this.val() != '')
                products[$this.parents('tr').data('id')] = $(this).val();
        });

        $.ajax({
            type: 'post',
            url: url('inventory'),
            data: {
                action: 'create',
                products: products,
                manufacturer: $('#manufacturer').val(),
                storage: $('#storage').val(),
                comment: $('#comment').val()
            },
            success: function (answer) {
                successHandler(answer);
            },
            error: function (answer) {
                errorHandler(answer);
            }
        });
    });
});