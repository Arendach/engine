<?php include parts('modal_head') ?>

<form data-type="ajax" action="<?= uri('manufacturer') ?>">
    <input type="hidden" name="action" value="create">

    <div class="form-group">
        <label for="name">Назва</label>
        <input name="name" class="form-control input-sm" id="name">
    </div>

    <div class="form-group">
        <label for="groupe">Група виробників</label>
        <select name="groupe" class="form-control input-sm" id="groupe">
            <option value="0">Без групи виробників</option>
            <?php foreach ($groups as $item) { ?>
                <option value="<?= $item->id ?>"><?= $item->name ?></option>
            <?php } ?>
        </select>
    </div>

    <div class="form-group">
        <label for="address">Адреса</label>
        <input name="address" class="form-control input-sm" id="address">
    </div>

    <div class="form-group">
        <label for="phone">Телефон</label>
        <input name="phone" class="form-control input-sm" id="phone">
    </div>

    <div class="form-group">
        <label for="email">Е-майл</label>
        <input name="email" class="form-control input-sm" id="email">
    </div>

    <div class="form-group">
        <label for="info">Додаткова інформація</label>
        <textarea class="info" name="info" id="info"></textarea>
    </div>

    <script>
        CKEDITOR.replace('info');

        $('#phone').inputmask('999-999-99-99');
    </script>

    <div class="form-group" style="margin-bottom: 0">
        <button class="btn btn-primary btn-sm">Зберегти</button>
    </div>
</form>

<?php include parts('modal_foot') ?>


