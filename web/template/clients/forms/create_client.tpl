<?php include parts('modal_head') ?>

<form data-type="ajax" action="<?= uri('clients') ?>">

    <input type="hidden" name="action" value="create">

    <div class="form-group">
        <label for="name">Імя</label>
        <input required name="name" id="name" class="form-control input-sm">
    </div>

    <div class="form-group">
        <label for="email">Електронна пошта</label>
        <input name="email" id="email" type="email" class="form-control input-sm">
    </div>

    <div class="form-group">
        <label for="phone">Телефон</label>
        <input name="phone" required id="phone" class="form-control input-sm">
    </div>

    <div class="form-group">
        <label for="group">Група</label>
        <select id="group" name="group" class="form-control input-sm">
            <option value="0">Без групи</option>
            <?php foreach ($groups as $item) { ?>
                <option value="<?= $item->id ?>"><?= $item->name ?></option>
            <?php } ?>
        </select>
    </div>

    <div class="form-group">
        <label for="manager">Відповідальний менеджер</label>
        <select name="manager" id="manager" class="form-control input-sm">
            <option value="0"></option>
            <?php foreach ($users as $item) { ?>
                <option value="<?= $item->id ?>"><?= $item->login ?></option>
            <?php } ?>
        </select>
    </div>

    <div class="form-group">
        <label for="percentage">% від замовлення</label>
        <input name="percentage" id="percentage" class="form-control input-sm" value="1">
    </div>

    <div class="form-group">
        <label for="address">Адреса</label>
        <input name="address" id="address" class="form-control input-sm">
    </div>

    <div class="form-group">
        <label for="summernote">Додаткова інформація</label>
        <textarea name="info" id="summernote"></textarea>
    </div>


    <div class="form-group" style="margin-bottom: 0;">
        <button class="btn btn-primary btn-sm">Зберегти</button>
    </div>

</form>

<script>
    $(document).ready(function () {
        CKEDITOR.replace('info');

        $('#phone').inputmask('999-999-99-99');
    });
</script>

<?php include parts('modal_foot') ?>
