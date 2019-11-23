<?php include parts('modal_head'); ?>

<form data-type="ajax" data-action="<?= uri('manufacturer_groups') ?>">
    <input type="hidden" name="action" value="create">

    <div class="form-group">
        <label for="name">Назва</label>
        <input name="name" class="form-control" id="name" placeholder="Назва">
    </div>

    <div class="form-group" style="margin-bottom: 0">
        <button class="btn btn-primary">Зберегти</button>
    </div>
</form>

<?php include parts('modal_foot'); ?>

