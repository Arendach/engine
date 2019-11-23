<?php include parts('modal_head'); ?>

<form data-type="ajax" action="<?= uri('storage') ?>">
    <input type="hidden" name="id" value="<?= $storage->id ?>">
    <input type="hidden" name="action" value="update">

    <div class="form-group">
        <label>Показувати в замовленнях:</label>
        <table style="width: 100%">
            <tr>
                <td class="centered">
                    <input <?= $storage->sending == '1' ? 'checked' : '' ?> value="1" type="checkbox"
                                                                            name="sending"> Відправки
                </td>

                <td class="centered">
                    <input <?= $storage->self == '1' ? 'checked' : '' ?> value="1" type="checkbox" name="self">
                    Самовивіз
                </td>

                <td class="centered">
                    <input <?= $storage->delivery == '1' ? 'checked' : '' ?> value="1" type="checkbox"
                                                                             name="delivery"> Доставки
                </td>

                <td class="centered">
                    <input <?= $storage->shop == '1' ? 'checked' : '' ?> value="1" type="checkbox" name="shop">
                    Магазин
                </td>

            </tr>
        </table>
    </div>

    <div class="form-group">
        <label for="name">Назва</label>
        <input value="<?= $storage->name ?>" name="name" class="form-control" id="name">
    </div>

    <div class="form-group">
        <label for="sort">Сортування</label>
        <input value="<?= $storage->sort ?>" name="sort" class="form-control">
    </div>

    <div class="form-group">
        <label for="accounted">Тип</label>
        <select name="accounted" id="accounted" class="form-control">
            <option <?= $storage->accounted ? 'selected' : ''; ?> value="1">+/-</option>
            <option <?= !$storage->accounted ? 'selected' : ''; ?> value="0">const=0</option>
        </select>
    </div>

    <div class="form-group">
        <label for="info">Інформація</label>
        <textarea name="info" id="info"><?= $storage->info ?></textarea>
    </div>

    <script>
        CKEDITOR.replace('info');
    </script>

    <div class="form-group" style="margin-bottom: 0;">
        <button class="btn btn-primary">Зберегти</button>
    </div>

</form>
<?php include parts('modal_foot') ?>
