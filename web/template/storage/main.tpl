<?php include parts('head') ?>

    <div class="right" style="margin-bottom: 15px;">
        <button data-type="get_form"
                data-uri="<?= uri('storage') ?>"
                data-action="form_create"
                class="btn btn-primary">Додати
        </button>
    </div>

    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Назва складу</th>
            <th>Тип складу</th>
            <th>Сортування</th>
            <th>Додаткакова інформація</th>
            <th class="action-2">Дії</th>
        </tr>
        </thead>
        <tbody>
        <?php if (my_count($storage) > 0) { ?>
            <?php foreach ($storage as $item){ ?>
                <tr>
                    <td><?= $item->name ?></td>
                    <td><span style="color:red;"><?= $item->accounted ? '+/-' : 'const=0' ?></span></td>
                    <td><?= $item->sort ?></td>
                    <td><?= htmlspecialchars_decode($item->info) ?></td>
                    <td class="action-2">
                        <button data-type="get_form"
                                data-uri="<?= uri('storage') ?>"
                                data-action="form_update"
                                data-post="<?= params(['id' => $item->id]) ?>"
                                title="Редагувати"
                                class="btn btn-primary btn-xs">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </button>
                        <button data-type="delete"
                                data-uri="<?= uri('storage') ?>"
                                data-action="delete"
                                data-id="<?= $item->id ?>"
                                title="Видалити"
                                class="btn btn-danger btn-xs">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                    </td>
                </tr>
            <?php } ?>
        <?php } else { ?>
            <tr>
                <td colspan="5" class="centered">
                    <h4>Тут пусто :(</h4>
                </td>
            </tr>
        <?php } ?>
        </tbody>
    </table>

<?php include parts('foot'); ?>