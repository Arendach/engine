<?php include parts('modal_head'); ?>

<form data-type="ajax" action="<?= uri('manufacturer') ?>">
    <input type="hidden" name="id" value="<?= $manufacturer->id ?>">
    <input type="hidden" name="action" value="update">
    <div class="form-group">
        <input value="<?= $id ?>" name="id" type="hidden">
        <label for="name">Назва</label>
        <input value="<?= $manufacturer->name ?>" name="name" class="form-control input-sm" id="name">
    </div>

    <div class="form-group">
        <label for="groupe">Група виробників</label>
        <select name="groupe" class="form-control input-sm" id="groupe">
            <option value="0">Не вибрано</option>
            <?php foreach ($groups as $item) { ?>
                <option <?= $item->id == $manufacturer->groupe ? 'selected' : '' ?> value="<?= $item->id ?>">
                    <?= $item->name ?>
                </option>
            <?php } ?>
        </select>
    </div>

    <div class="form-group">
        <label for="address">Адреса</label>
        <input value="<?= $manufacturer->address ?>" name="address" class="form-control input-sm" id="address">
    </div>

    <div class="form-group">
        <label for="phone">Телефон</label>
        <input value="<?= $manufacturer->phone ?>" name="phone" class="form-control input-sm" id="phone">
    </div>

    <div class="form-group">
        <label for="email">Е-майл</label>
        <input value="<?= $manufacturer->email ?>" name="email" class="form-control input-sm" id="email">
    </div>

    <div class="form-group">
        <label for="info">Додаткова інформація</label>
        <textarea name="info" class="info" id="info"><?= $manufacturer->info ?></textarea>
    </div>

    <script>
        CKEDITOR.replace('info');

        $('#phone').inputmask('999-999-99-99');

    </script>

    <div class="form-group" style="margin-bottom: 0">
        <button class="btn btn-primary btn-sm">Зберегти</button>
    </div>

</form>

<?php include parts('modal_foot'); ?>
