<?php include parts('head'); ?>


    <div class="right" style="margin-bottom: 15px">
        <button data-type="get_form" data-action="create_order_type_form" data-uri="<?= uri('settings') ?>"
                class="btn btn-primary">Новий тип
        </button>
    </div>

    <table class="table table-bordered table-responsive">
        <tr>
            <th>Назва</th>
            <th>Колір</th>
            <th class="action-2 centered">Дії</th>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr>
                <td><?= $item->name ?></td>
                <td>
                    <div style="width: 100%; background: #<?= $item->color ?>; text-align: center; padding: 5px">
                        <?= $item->color ?>
                    </div>
                </td>
                <td class="action-2 centered">
                    <button
                            data-type="get_form"
                            data-uri="<?= uri('settings') ?>"
                            data-action="update_order_type_form"
                            data-post="<?= params(['id' => $item->id]) ?>"
                            class="btn btn-xs btn-primary">
                        <i class="fa fa-pencil"></i>
                    </button>
                    <button
                            data-type="delete"
                            data-id="<?= $item->id ?>"
                            data-action="delete_order_type"
                            class="btn btn-xs btn-danger">
                        <i class="fa fa-remove"></i>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>

<?php include parts('foot') ?>