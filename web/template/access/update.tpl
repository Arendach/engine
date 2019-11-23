<?php include parts('head'); ?>

    <form id="update_access_group">
        <input type="hidden" name="id" value="<?= $group['id'] ?>">

        <div class="form-group">
            <label for="name">Назва</label>
            <input required id="name" class="form-control" name="name" value="<?= $group['name'] ?>">
        </div>

        <div class="form-group">
            <label for="description">Опис</label>
            <input required id="description" class="form-control" name="description" value="<?= $group['description'] ?>">
        </div>

        <?php if (my_count($access) > 0) {
            foreach ($access as $k => $item) { ?>
                <h4><input type="checkbox" id="<?= md5($k) ?>" class="check_input"> <?= $k ?></h4>
                <div style="margin-left: 30px">
                    <?php foreach ($item as $item2) { ?>
                        <input class="<?= md5($k) ?> ch" <?= $item2['checked'] ? 'checked' : ''; ?> type="checkbox"
                               value="<?= $item2['access'] ?>">
                        <span>
                    <?= $item2['name'] ?>
                            <?php if (!empty($item2['description'])) { ?>
                                <span class="hint" title="<?= $item2['description'] ?>" data-toggle="tooltip">?</span>
                            <?php } ?>
                </span>
                        <br>
                    <?php } ?>
                </div>
            <?php }
        } ?>

        <div class="form-group" style="margin-top: 20px">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>

    <script>
        $(document).ready(function () {
            var $body = $('body');

            $body.on('change', '.check_input', function () {
                var $this = $(this);
                var $input_class = '.' + $this.attr('id');
                if (this.checked)
                    $($input_class).prop('checked', true);
                else
                    $($input_class).prop('checked', false);
            });

            (function () {
                var data = [];
                $('.check_input').each(function () {
                    data.push($(this).attr('id'));
                });

                for (var i = 0; i < data.length; i++) {
                    var check = true;
                    var $class = $('.' + data[i]);
                    $class.each(function () {
                        if (!this.checked)
                            check = false;
                    });

                    $('#' + data[i]).prop('checked', check);
                }
            })(jQuery);

            $body.on('submit', '#update_access_group', function (event) {
                event.preventDefault();

                var data = $(this).serializeJSON();
                data.action = 'update';
                data.keys = [];

                $('.ch').each(function () {
                    if ($(this).is(':checked'))
                        data.keys.push($(this).val());
                });

                $.ajax({
                    type: 'post',
                    url: url('access'),
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

    </script>

<?php include parts('foot'); ?>