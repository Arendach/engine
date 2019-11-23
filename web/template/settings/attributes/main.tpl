<?php include parts('head'); ?>

<div class="right" style="margin-bottom: 15px">
    <button data-type="get_form"
            data-uri="<?= uri('settings') ?>"
            data-action="create_attribute_form"
            class="btn btn-primary">Новий атрибут
    </button>
</div>

<?php if (my_count($items) > 0) { ?>
    <table class="table table-bordered" style="margin-bottom: 0">
        <tr>
            <th>Назва</th>
            <th class="action-2">Дії</th>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr>
                <td><?= $item->name ?></td>
                <td class="action-2">
                    <button data-type="get_form"
                            data-uri="<?= uri('settings') ?>"
                            data-action="update_attribute_form"
                            data-post="<?= params(['id' => $item->id]) ?>"
                            class="btn btn-primary btn-xs"
                            title="Редагувати">
                        <span class="glyphicon glyphicon-pencil"></span>
                    </button>
                    <button data-type="delete"
                            data-action="attribute_delete"
                            data-uri="<?= uri('settings') ?>"
                            data-id="<?= $item->id ?>"
                            title="Видалити"
                            class="btn btn-danger btn-xs">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>

    <div class="centered" style="margin: -5px 0">
        <?php \Web\App\NewPaginate::display() ?>
    </div>

<?php } else { ?>
    <h4 class="centered">
        Тут пусто :(
    </h4>
<?php } ?>


<?php include parts('foot'); ?>
