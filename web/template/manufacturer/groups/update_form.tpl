<?php include parts('modal_head') ?>
<form data-type="ajax" action="<?= uri('manufacturer_groups') ?>">
    <input value="<?= $group->id ?>" name="id" type="hidden">
    <input value="update" name="action" type="hidden">

    <div class="form-group">
        <label for="name">Назва</label>
        <input value="<?= $group->name ?>" name="name" class="form-control input-sm" id="name">
    </div>

    <div class="form-group" style="margin-bottom: 0">
            <button class="btn btn-primary btn-sm">Зберегти</button>
    </div>
</form>

<?php include parts('modal_foot') ?>


