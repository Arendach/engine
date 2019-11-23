<?php include parts('modal_head') ?>

<form data-type="ajax" action="<?= uri('category') ?>">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="<?= $category['id'] ?>">

    <div class="form-group">
        <label for="name">Назва</label>
        <input name="name" id="name" value="<?= $category['name'] ?>" class="form-control input-sm">
    </div>

    <div class="form-group">
        <label for="service_code">Сервісний код</label>
        <input name="service_code" id="service_code" value="<?= $category['service_code'] ?>"
               class="form-control input-sm">
    </div>

    <div class="form-group">
        <label for="parent">Категорія</label>
        <select id="parent" name="parent" class="form-control input-sm">
            <option class="none" value="<?= $category['parent']; ?>"><?= $category['parent_name']; ?></option>
            <option value="0">Без категорії</option>
            <?= ($categories); ?>
        </select>
    </div>

    <div class="form-group" style="margin-bottom: 0;">
        <button class="btn btn-primary btn-sm">Зберегти</button>
    </div>
</form>

<?php include parts('modal_foot') ?>


