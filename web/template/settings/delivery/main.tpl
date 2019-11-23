<?php include parts('head'); ?>

<?php include t_file('settings.buttons') ?>

    <table class="table table-bordered">
        <tr>
            <th>Назва компанії</th>
            <th class="action-2">Дії</th>
        </tr>
        <?php if (my_count($items) > 0) {
            foreach ($items as $item) { ?>
                <tr>
                    <td>
                        <?= $item->name ?>
                    </td>
                    <td class="action-2">
                        <button data-type="get_form"
                                data-uri="<?= uri('settings') ?>"
                                data-post="<?= params(['id' => $item->id]) ?>"
                                data-action="delivery_form_update"
                                class="btn btn-primary btn-xs">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </button>
                        <button data-type="delete"
                                data-uri="<?= uri('settings') ?>"
                                data-id="<?= $item->id ?>"
                                data-action="delivery_delete"
                                class="delete btn btn-danger btn-xs">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                    </td>
                </tr>
            <?php } ?>
        <?php } else { ?>
            <tr>
                <td class="centered" colspan="2">
                    <h4>Тут пусто :(</h4>
                </td>
            </tr>
        <?php } ?>
    </table>

    <div class="type_block" style="padding: 10px">
        <form data-type="ajax" action="<?= uri('settings') ?>">

            <input type="hidden" name="action" value="delivery_create">

            <div class="form-group">
                <label for="name"><span class="text-danger">*</span> Назва</label>
                <input id="name" name="name" class="form-control">
            </div>

            <div class="form-group">
                <button class="btn btn-primary">Нова компанія</button>
            </div>

        </form>
    </div>

<?php include parts('foot') ?>