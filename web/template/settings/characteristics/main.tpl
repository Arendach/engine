<?php include parts('head'); ?>

    <div class="right" style="margin-bottom: 15px">
        <button data-type="get_form" data-action="create_characteristic_form" data-uri="<?= uri('settings') ?>"
                class="btn btn-primary">Нова характеристика
        </button>
    </div>

    <table class="table table-bordered table-responsive">
        <tr>
            <th>Назва</th>
            <th>Префікс</th>
            <th>Значення</th>
            <th>Постфікс</th>
            <th class="action-2 centered">Дії</th>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr>
                <td><?= $item->name_uk ?></td>
                <td><?= $item->prefix_uk ?></td>
                <td><?= $item->value_uk ?></td>
                <td><?= $item->postfix_uk ?></td>
                <td class="action-2 centered">
                    <button data-type="get_form"
                            data-uri="<?= uri('settings') ?>"
                            data-action="update_characteristic_form"
                            data-post="<?= params(['id' => $item->id]) ?>"
                            class="btn btn-xs btn-primary">
                        <i class="fa fa-pencil"></i>
                    </button>
                    <button data-type="delete"
                            data-uri="<?= uri('settings') ?>"
                            data-id="<?= $item->id ?>"
                            data-action="delete_characteristic"
                            class="btn btn-xs btn-danger">
                        <i class="fa fa-remove"></i>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>

    <div class="centered">
        <? \Web\App\NewPaginate::display() ?>
    </div>

<?php include parts('foot') ?>