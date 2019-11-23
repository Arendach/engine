<form action="<?= uri('orders') ?>" data-type="ajax">
    <input type="hidden" name="action" value="update_order_type">
    <input type="hidden" name="id" value="<?= $order->id ?>">

    <div class="form-group">
        <label for="atype">Тип замовлення</label>
        <select class="form-control" id="atype" name="atype">
            <option value=""></option>
            <?php foreach (\Web\Model\OrderSettings::getAll('order_type') as $item) { ?>
                <option <?= $order->atype == $item->id ? 'selected' : '' ?> value="<?= $item->id ?>">
                    <?= $item->name ?>
                </option>
            <?php } ?>
        </select>
    </div>

    <div class="form-group">
        <label for="liable">Відповідальний менеджер</label>
        <select <?= $order->atype == 0 ? 'disabled' : '' ?> class="form-control" id="liable" name="liable">
            <option value=""></option>
            <?php foreach (\Web\Model\OrderSettings::findAll('users', 'archive = 0') as $item) { ?>
                <option <?= $order->liable == $item->id ? 'selected' : '' ?> value="<?= $item->id ?>">
                    <?= $item->login ?>
                </option>
            <?php } ?>
        </select>
    </div>

    <div class="form-group">
        <button class="btn btn-primary" <?= $order->liable != 0 && cannot() ? 'disabled' : '' ?>>Зберегти</button>
    </div>

    <script>
        $('body').on('change', '#atype', function () {
            if ($(this).val() == '0'){
                $('#liable').attr('disabled', 'disabled');
                $('#liable option:selected').removeAttr('selected');
                $('#liable option[value="0"]').attr('selected', '');
            } else {
                $('#liable').removeAttr('disabled');
            }
        });
    </script>

</form>