<?php include parts('modal_head'); ?>

    <form data-type="ajax" action="<?= uri('settings') ?>">

        <input type="hidden" name="id" value="<?= $item->id; ?>">
        <input type="hidden" name="action" value="color_update">

        <div class="form-group">
            <label for="description"><span class="text-danger">*</span> Опис</label>
            <input name="description" id="description" class="form-control" value="<?= $item->description ?>">
        </div>

        <div class="form-group">
            <label for="type"><span class="text-danger">*</span> Тип</label>
            <select name="type" id="type" class="form-control">
                <option <?= $item->type == '0' ? 'selected' : '' ?> value="0">Загальний</option>
                <option <?= $item->type == 'self' ? 'selected' : '' ?> value="self">Самовивози</option>
                <option <?= $item->type == 'sending' ? 'selected' : '' ?> value="sending">Відправки</option>
                <option <?= $item->type == 'shop' ? 'selected' : '' ?> value="shop">Магазин</option>
                <option <?= $item->type == 'delivery' ? 'selected' : '' ?> value="delivery">Доставки</option>
            </select>
        </div>

        <div class="form-group">
            <label for="color_edit"><span class="text-danger">*</span> Колір</label>
            <input name="color" id="color_edit" class="form-control" value="<?= $item->color; ?>">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary">Зберегти</button>
        </div>

    </form>

<?php include parts('modal_foot'); ?>