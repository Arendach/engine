<?php include parts('head'); ?>


    <table class="table table-bordered">
        <tr>
            <th>Назва</th>
            <th>Мерчант</th>
            <th class="action-2">Дії</th>
        </tr>
        <?php if (my_count($items) > 0) { ?>
            <?php foreach ($items as $item) { ?>
                <tr>
                    <td>
                        <?= $item->name ?>
                    </td>
                    <td>
                        <?= isset($merchants[$item->merchant_id]) ? $merchants[$item->merchant_id]->name : 'Немає' ?>
                    </td>
                    <td class="action-2">
                        <button data-type="get_form"
                                data-uri="<?= uri('settings') ?>"
                                data-action="pay_form_update"
                                data-post="<?= params(['id' => $item->id]) ?>"
                                class="btn btn-primary btn-xs">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </button>
                        <button data-type="delete"
                                data-action="pay_delete"
                                data-uri="<?= uri('settings') ?>"
                                data-id="<?= $item->id ?>"
                                class="btn btn-danger btn-xs">
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
            <input type="hidden" name="action" value="pay_create">

            <div class="form-group">
                <label for="name"><span class="text-danger">*</span> Назва</label>
                <input id="name" name="name" class="form-control">
            </div>

            <div class="form-group">
                <button class="btn btn-primary">Нова оплата</button>
            </div>

        </form>
    </div>

<?php include parts('foot') ?>