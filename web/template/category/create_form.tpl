<?php include parts('modal_head') ?>

<form data-type="ajax" action="<?= uri('category') ?>">
    <input type="hidden" name="action" value="create">

    <div class="form-group">
        <label for="name">Назва</label>
        <input name="name" id="name" class="form-control input-sm">
    </div>

    <div class="form-group">
        <label for="service_code">Сервісний код</label>
        <input name="service_code" id="service_code" class="form-control input-sm">
    </div>

    <div class="form-group">
        <label for="parent">Категорія</label>
        <select id="parent" name="parent" class="form-control input-sm">
            <option value="0">Без категорії</option>
            <?= ($categories); ?>
        </select>
    </div>

    <div class="form-group" style="margin-bottom: 0">
        <button class="btn btn-primary btn-sm">Зберегти</button>
    </div>
</form>

<?php include parts('modal_foot') ?>


