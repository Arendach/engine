<?php include parts('head'); ?>

<?php include t_file('settings.buttons'); ?>

    <div class="right" style="margin-bottom: 20px">
        <button data-type="get_form"
                data-uri="<?= uri('sms') ?>"
                data-action="create_form"
                class="btn btn-primary">
            Новий шаблон
        </button>
    </div>

<?php include t_file('sms.marks') ?>


    <table class="table table-bordered">
        <tr>
            <td><b>Назва(для списку)</b></td>
            <td><b>Тип</b></td>
            <td><b>Текст повідомлення</b></td>
            <td class="action-2 centered"><b>Дії</b></td>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr data-id="<?= $item->id ?>">
                <td style="width: 150px">
                    <input type="text" name="name" class="form-control input-sm field" value="<?= $item->name ?>">
                </td>

                <td style="width: 150px">
                    <select class="form-control input-sm field" name="type">
                        <option <?= $item->type == 'sending' ? 'selected' : '' ?> value="sending">Відправки</option>
                        <option <?= $item->type == 'delivery' ? 'selected' : '' ?> value="delivery">Доставки</option>
                        <option <?= $item->type == 'self' ? 'selected' : '' ?> value="self">Самовивіз</option>
                        <option <?= $item->type == 'shop' ? 'selected' : '' ?> value="shop">Магазин</option>
                    </select>
                </td>
                <td>
                    <textarea class="form-control input-sm field" name="text"><?= trim($item->text) ?></textarea>
                </td>
                <td class="action-2 centered">
                    <button class="edit btn btn-xs btn-primary">
                        <span class="glyphicon glyphicon-floppy-disk"></span>
                    </button>
                    <button data-type="delete"
                            data-uri="<?= uri('sms') ?>"
                            data-action="delete"
                            data-id="<?= $item->id ?>"
                            class="btn btn-xs btn-danger">
                        <span class="glyphicon glyphicon-remove">

                        </span>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>

<?php include parts('foot') ?>