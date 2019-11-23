<?php include parts('head') ?>

    <div class="right" style="margin-bottom: 15px;">
        <button data-type="get_form"
                data-uri="<?= uri('settings') ?>"
                data-action="create_merchant_card_form"
                data-post="<?= params(['merchant_id' => get('id')]) ?>"
                class="btn btn-primary">
            Нова карта
        </button>
    </div>

<?php if (my_count($items) > 0) { ?>
    <table class="table table-bordered">
        <tr>
            <th>Номер</th>
            <th class="action-2 centered">Дії</th>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr>
                <td><?= $item->number ?></td>
                <td class="action-2 centered">
                    <button data-type="get_form"
                            data-uri="<?= uri('settings') ?>"
                            data-action="update_merchant_card_form"
                            data-post="<?= params(['id' => $item->id]) ?>"
                            title="Редагувати" 
                            class="btn btn-primary btn-xs">
                        <i class="fa fa-pencil"></i>
                    </button>

                    <button data-type="delete" 
                            data-uri="<?= uri('settings') ?>" 
                            data-action="delete_merchant_card"
                            data-id="<?= $item->id ?>"
                            title="Видалити" 
                            class="btn btn-danger btn-xs">
                        <i class="fa fa-remove"></i>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>
<?php } else { ?>
    <h4 class="centered">Тут пусто :(</h4>
<?php } ?>

<?php include parts('foot') ?>