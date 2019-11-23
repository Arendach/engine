<?php include parts('head') ?>

<div class="right" style="margin-bottom: 15px;">
    <button data-type="get_form"
            data-uri="<?= uri('settings') ?>"
            data-action="create_merchant_form"
            class="btn btn-primary">Новий мерчант</button>
</div>

<?php if (my_count($items) > 0) { ?>
    <table class="table table-bordered">
        <tr>
            <th>Імя</th>
            <th>Ідентифікатор</th>
            <th>Пароль</th>
            <th class="action-3 centered">Дії</th>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr>
                <td><?= $item->name ?></td>
                <td><?= $item->merchant_id ?></td>
                <td><?= $item->password ?></td>
                <td class="action-3 centered">
                    <a href="<?= uri('settings', ['section' => 'merchant_card', 'id' => $item->id]) ?>"
                       title="Карточки"
                       class="btn btn-success btn-xs">
                        <i class="fa fa-credit-card-alt"></i>
                    </a>

                    <button data-type="get_form"
                            data-uri="<?= uri('settings') ?>"
                            data-action="update_merchant_form"
                            data-post="<?= params(['id' => $item->id]) ?>"
                            title="Редагувати"
                            class="btn btn-primary btn-xs">
                        <i class="fa fa-pencil"></i>
                    </button>

                    <button data-type="delete"
                            data-uri="<?= uri('settings') ?>"
                            data-action="delete_merchant"
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