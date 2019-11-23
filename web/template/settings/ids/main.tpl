<?php include parts('head'); ?>

    <style>
        .e:hover {
            background-color: #eee;
            padding: 5px
        }

        .e {
            padding: 5px;
        }
    </style>

    <div class="right" style="margin-bottom: 15px">
        <button type="button" class="btn btn-danger delete_selected_ids"> Видалити вибрані</button>

        <button data-type="get_form" data-action="create_ids_form" data-uri="<?= uri('settings') ?>"
                class="btn btn-primary">Новий ідентифікатор
        </button>
    </div>

    <div class="panel-group" id="accordion">
        <?php $i = 0;
        foreach ($items as $k => $keys) {
            $rand32 = rand32();
            ?>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#<?= $rand32 ?>">
                            <b style="color: blue"><?= $k ?></b>
                        </a>
                    </h4>
                </div>
                <div id="<?= $rand32 ?>" class="panel-collapse collapse<?= $i == 0 ? ' in' : '' ?>">
                    <div class="panel-body">
                        <?php foreach ($keys as $item) { ?>
                            <div class="row e">
                                <div class="col-md-10">
                                    <span data-value="<?= $item->id ?>" class="checkbox"> <?= $item->value ?></span>
                                </div>
                                <div class="col-md-2 right">
                                    <button
                                            data-type="get_form"
                                            data-uri="<?= uri('settings') ?>"
                                            data-action="update_ids_form"
                                            data-post="<?= params(['id' => $item->id]) ?>"
                                            class="btn btn-xs btn-primary">
                                        <i class="fa fa-pencil"></i>
                                    </button>
                                    <button
                                            data-type="delete"
                                            data-id="<?= $item->id ?>"
                                            data-action="delete_ids"
                                            class="btn btn-xs btn-danger">
                                        <i class="fa fa-remove"></i>
                                    </button>
                                </div>
                            </div>
                        <?php } ?>
                    </div>
                </div>
            </div>
            <?php $i++;
        } ?>
    </div>

    <script>
        $(document).ready(function () {
            var $body = $('body');

            $body.on('click', '.delete_selected_ids', function () {
                var data = {
                    id: Elements.getCheckedValues('div'),
                    action: 'delete_ids'
                };

                delete_on_click(function () {
                    $.ajax({
                        type: 'post',
                        url: url('settings'),
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
        });
    </script>

<?php include parts('foot') ?>