<div class="row">
    <div class="col-md-3">
        <form id="load_photo" action="<?= uri('orders') ?>" enctype="multipart/form-data">
            <input type="hidden" name="action" value="load_photo">
            <input type="hidden" name="id" value="<?= $order->id ?>">

            <div class="form-group">
                <input type="file" name="photo">

            </div>

            <div class="form-group">
                <button class="btn btn-primary">Завантажити</button>

            </div>

        </form>
    </div>

    <style>
        a.file {
            position: relative;
            display: block;
            border: 1px dashed #ccc;
            padding: 10px;
            margin-bottom: 15px
        }

        a.file:hover {
            background: #eee;
            text-decoration: none;
        }

        .delete_image {
            position: absolute;
            top: 10px;
            right: 15px;
            color: red;
            display: block;
            width: 20px;
            height: 20px;
            text-align: center;
            font-size: 140%;
        }

    </style>

    <div class="col-md-9">
        <?php if (my_count($images) > 0) { ?>
            <?php foreach ($images as $image) { ?>
                <a class="file" href="<?= $image->path ?>">
                    <?php if (in_array(mb_strtolower(pathinfo($image->path)['extension']), ['png', 'gif', 'jpeg', 'jpg', 'bmp'])) { ?>
                        <img style="height: 150px;" src="<?= $image->path ?>">
                    <?php } else { ?>
                        <img style="height: 150px;"
                             src="<?= asset('images/formats/' . mb_strtolower(pathinfo($image->path)['extension']) . '.png'); ?>">
                    <?php } ?>
                    <div style="margin-left: 15px; display: inline-block">
                        <?= pathinfo($image->path)['basename'] ?> <br>
                        <?= date ("Y.m.d H:i", filemtime(ROOT .$image->path)); ?><br>
                        <?= my_file_size(filesize(ROOT . $image->path)) ?>
                    </div>

                    <span class="delete_image"
                          data-toggle="tooltip"
                          title="Видалити"
                          data-id="<?= $image->id ?>">
                        <i class="fa fa-remove"></i>
                    </span>
                </a>
            <?php } ?>
        <?php } ?>
    </div>

</div>

<script>
    $(document).ready(function () {
        var $body = $('body');
        var files;

        $('input[type=file]').on('change', function () {
            files = this.files;
        });

        $body.on('submit', '#load_photo', function (event) {
            event.preventDefault();

            if (typeof files == 'undefined') return;

            var data = new FormData();

            $.each(files, function (key, value) {
                data.append(key, value);
            });

            data.append('action', 'load_photo');
            data.append('id', $('[name="id"]').val());

            $.ajax({
                url: url('orders'),
                type: 'POST',
                data: data,
                cache: false,
                dataType: 'json',
                // отключаем обработку передаваемых данных, пусть передаются как есть
                processData: false,
                // отключаем установку заголовка типа запроса. Так jQuery скажет серверу что это строковой запрос
                contentType: false,
                // функция успешного ответа сервера
                success: function (answer) {
                    swal({
                        title: 'Успіх',
                        type: 'success',
                        text: answer.message
                    }, function () {
                        location.reload();
                    });
                },
                error: function (answer) {
                    errorHandler(answer);
                }
            });

        });

        $body.on('click', '.delete_image', function (event) {
            event.preventDefault();

            var $this = $(this);

            var data = {
                id: $this.data('id'),
                action: 'delete_image'
            };

            delete_on_click(function () {
                $.ajax({
                    url: url('orders'),
                    type: 'POST',
                    data: data,
                    dataType: 'json',
                    success: function (answer) {
                        swal({
                            title: 'Успіх',
                            type: 'success',
                            text: answer.message
                        });

                        $this.parents('a').remove();
                    },
                    error: function (answer) {
                        errorHandler(answer);
                    }
                });
            });
        });
    });
</script>