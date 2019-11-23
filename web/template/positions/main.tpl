<?php include parts('head') ?>

    <div class="right" style="margin-bottom: 15px;">
        <button data-type="get_form"
                data-action="create_form"
                class="btn btn-primary">
            Нова посада
        </button>
    </div>

<?php if (my_count($positions) > 0) { ?>
    <table class="table table-bordered">
        <tr>
            <th>Назва</th>
            <th class="action-2">Дії</th>
        </tr>
        <?php foreach ($positions as $position) { ?>
            <tr>
                <td><?= $position->name ?></td>
                <td class="action-2">
                    <button data-type="get_form"
                            data-uri="<?= uri('position') ?>"
                            data-action="update_form"
                            data-post="<?= params(['id' => $position->id]) ?>"
                            class="btn btn-xs btn-primary">
                        <i class="fa fa-pencil"></i>
                    </button>

                    <button data-type="delete"
                            data-uri="<?= uri('position') ?>"
                            data-id="<?= $position->id ?>"
                            data-action="delete"
                            class="btn btn-xs btn-danger">
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