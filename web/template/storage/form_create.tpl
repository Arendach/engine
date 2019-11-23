<?php include parts('modal_head') ?>

<form data-type="ajax" action="<?= uri('storage') ?>">

    <input type="hidden" name="action" value="create">

    <div class="form-group">
        <label for="name">Назва</label>
        <input name="name" class="form-control" id="name">
    </div>

    <div class="form-group">
        <label for="sort">Сортування</label>
        <input name="sort" class="form-control">
    </div>

    <div class="form-group">
        <label for="accounted">Тип</label>
        <select id="accounted" name="accounted" class="form-control">
            <option value="0">const=0</option>
            <option value="1">+/-</option>
        </select>
    </div>

    <div class="form-group">
        <label for="info">Додаткова інформація</label>
        <textarea name="info" id="info"></textarea>
    </div>

    <script>
        CKEDITOR.replace('info');
    </script>

    <div class="form-group" style="margin-bottom: 0;">
        <button class="btn btn-primary">Зберегти</button>
    </div>

</form>

<?php  include parts('modal_foot') ?>
