<?php include parts('head'); ?>

    <div class="right" style="margin: 15px 0;">
        <a href="<?= uri('access', ['section' => 'create']); ?>" class="btn btn-primary">
            Створити групу доступу
        </a>
    </div>

    <table class="table table-bordered">
        <tr>
            <th>Група</th>
            <th>Опис</th>
            <th class="action-2">Дії</th>
        </tr>
        <?php if (my_count($groups) > 0) {
            foreach ($groups as $item) { ?>
                <tr>
                    <td><?= $item['name']; ?></td>
                    <td><?= $item['description']; ?></td>
                    <td>
                        <a title="Редагувати" class="btn btn-primary btn-xs" href="<?= uri('access', [
                            'id' => $item->id,
                            'section' => 'update'
                        ]) ?>">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </a>
                        <button data-type="delete"
                                data-uri="<?= uri('access') ?>"
                                data-action="delete"
                                data-id="<?= $item->id; ?>"
                                title="Видалити"
                                class="btn btn-danger btn-xs">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                    </td>
                </tr>
            <?php }
        } else { ?>
            <tr>
                <td colspan="3">
                    <h4 class="centered">Тут пусто :(</h4>
                </td>
            </tr>
        <?php } ?>
    </table>

<?php include parts('foot'); ?>