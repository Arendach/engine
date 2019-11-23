<?php include parts('head'); ?>

    <div class="right" style="margin-bottom: 15px">
        <button data-type="get_form" data-action="create_shop_form" data-uri="<?= uri('settings') ?>"
                class="btn btn-primary">Новий магазин
        </button>
    </div>

    <table class="table table-bordered table-responsive">
        <tr>
            <th>Назва</th>
            <th>Адреса</th>
            <th class="action-2 centered">Дії</th>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr>
                <td><?= $item->name ?></td>
                <td><?= $item->address ?></td>
                <td class="action-2 centered">
                    <button data-type="get_form"
                            data-uri="<?= uri('settings') ?>"
                            data-action="update_shop_form"
                            data-post="<?= params(['id' => $item->id]) ?>"
                            class="btn btn-xs btn-primary">
                        <i class="fa fa-pencil"></i>
                    </button>
                    <button data-type="delete"
                            data-uri="<?= uri('settings') ?>"
                            data-id="<?= $item->id ?>"
                            data-action="delete_shop"
                            class="btn btn-xs btn-danger">
                        <i class="fa fa-remove"></i>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>

<?php include parts('foot') ?>