<?php include parts('head') ?>

    <style>
        .result {
            padding: 10px;
            background-color: #000;
            min-height: 100px;
            margin-bottom: 20px;
        }

        .result > div {
            color: #fff;
        }
    </style>

    <div class="alert alert-info">
        <h3>Список доступних команд</h3>
        <?php foreach ($commands as $command => $handler) { ?>
            <div>
                <b class="text-danger"><?= $command ?></b> - <?= $handler::$handDesc ?>
            </div>
        <?php } ?>
    </div>

    <div class="result">
        <div>Cron Task Manager</div>
    </div>


    <form id="command">
        <input type="hidden" name="action" value="run">

        <div class="form-group">
            <label>Введіть команду</label>
            <input class="form-control" name="command">
        </div>

        <div class="form-group">
            <button class="btn btn-primary">
                Виконати
            </button>
        </div>
    </form>

    <script>
        $(document).on('submit', '#command', function (event) {
            event.preventDefault();
            var data = $(this).serializeJSON();

            var $form = $(this);
            $form.find('button').attr('disabled', 'disabled');

            $('.result').append('<div>Cron -> ' + data.command + '</div><div class="load">Load ...</div>');
            $.ajax({
                type: 'post',
                url: '<?= uri('commands') ?>',
                data: data,
                dataType: 'json',
                success: function (answer) {
                    $('.result').find('.load').remove();
                    $('.result').append(answer.message);
                    $('[name="command"]').val('');

                    $form.find('button').removeAttr('disabled');
                },
                error: function (answer) {
                    $('.result').find('.load').remove();
                    $('.result').append(answer.responseJSON.message);
                    $form.find('button').removeAttr('disabled');
                }
            });
        });
    </script>

<?php include parts('footer') ?>