<?php include parts('head'); ?>

    <form id="create_access_group" style="margin-top: 15px;">
        <div class="form-group">
            <label for="name">Імя</label>
            <input required  id="name" name="name" class="form-control">
        </div>


        <div class="form-group">
            <label for="description">Опис</label>
            <input required id="description" name="description" class="form-control">
        </div>

        <?php if (my_count($access) > 0) {
            foreach ($access as $k => $item) { ?>
                <h4><input type="checkbox" id="<?= md5($k); ?>" class="check_input"> <?= $k ?></h4>
                <div style="margin-left: 30px">
                    <?php foreach ($item as $item2) { ?>
                        <input class="<?= md5($k) ?> ch_input" type="checkbox" value="<?= $item2['access'] ?>">
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

            $(document).on('submit', '#create_access_group', function (event) {
                event.preventDefault();

                var data = $(this).serializeJSON();

                data.keys = [];
                $('.ch_input').each(function () {
                    if ($(this).is(':checked'))
                        data.keys.push($(this).val());
                });

                data.action = 'create';

                $.ajax({
                    type: 'post',
                    url: url('access'),
                    data: data,
                    success: function (answer) {
                        successHandler(answer, function () {
                            redirect(url('access'));
                        });
                    },
                    error: function (answer) {
                        errorHandler(answer);
                    }
                });
            });

            $body.on('change', '.check_input', function () {
                var $this = $(this);
                var $input_class = '.' + $this.attr('id');
                if (this.checked)
                    $($input_class).prop('checked', true);
                else
                    $($input_class).prop('checked', false);
            });
        });
    </script>

<?php include parts('foot'); ?>