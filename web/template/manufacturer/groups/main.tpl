<?php include parts('head')?>

    <div class="right">
        <button data-type="get_form"
                data-uri="<?= uri('manufacturer_groups') ?>"
                data-action="create_form"
                class="btn btn-primary">Створити групу</button>
    </div>

    <div class="table-responsive" style="margin-top: 15px">
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>Назва</th>
                <th style="width: 69px; text-align: center">Дії</th>
            </tr>
            </thead>
            <tbody>
            <?php if (my_count($groups) > 0) {
                foreach ($groups as $group): ?>
                    <tr>
                        <td><?= $group->name ?></td>
                        <td style="width: 69px;">
                            <button data-type="get_form"
                                    data-uri="<?= uri('manufacturer_groups') ?>"
                                    data-action="update_form"
                                    class="btn btn-primary btn-xs"
                                    data-post="<?= params(['id' => $group->id]) ?>"
                               title="Редагувати"><span class="glyphicon glyphicon-pencil"></span>
                            </button>
                            <button data-type="delete"
                                    data-uri="<?= uri('manufacturer_groups') ?>"
                                    data-action="delete"
                                    class="btn btn-danger btn-xs"
                                    data-id="<?= $group->id ?>"
                                    title="Видалити">
                                <span class="glyphicon glyphicon-remove"></span>
                            </button>
                        </td>
                    </tr>
                <?php endforeach;
            } else {
                echo '<tr><td class="centered" colspan="4"><h4>Тут пусто :(</h4></td></tr>';
            } ?>
            </tbody>
        </table>
    </div>

<?php include parts('foot') ?>