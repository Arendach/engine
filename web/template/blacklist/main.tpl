<?php include parts('head') ?>

    <div class="right" style="margin-bottom: 15px;">
        <button data-type="get_form"
                data-uri="<?= uri('blacklist') ?>"
                data-action="create_form"
                class="btn btn-primary">
            Додати номер
        </button>
    </div>

<?php if (my_count($items) > 0) { ?>
    <table class="table-bordered table">
        <tr>
            <th>Імя</th>
            <th>Телефон</th>
            <th>Коментар</th>
            <th class="action-2">Дії</th>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr>
                <td><?= $item->name ?></td>
                <td><?= $item->phone ?></td>
                <td><?= $item->comment ?></td>
                <td class="action-2">
                    <button class="btn btn-primary btn-xs">
                        <i class="fa fa-pencil"></i>
                    </button>

                    <button class="btn btn-danger btn-xs">
                        <i class="fa fa-remove"></i>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>

    <?= \Web\App\NewPaginate::display() ?>

<?php } else { ?>
    <h4>Тут пусто :)</h4>
<?php } ?>

<?php include parts('foot') ?>