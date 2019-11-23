<?php include parts('modal_head'); ?>

<form data-type="ajax" action="<?= uri('clients_group') ?>">

    <input type="hidden" name="action" value="create">

    <div class="form-group">
        <label for="name">Імя</label>
        <input required type="text" id="name" name="name" class="form-control input-sm">
    </div>

    <div class="form-group" style="margin-bottom: 0;">
        <button class="btn btn-primary btn-sm">Зберегти</button>
    </div>

</form>

<?php include parts('modal_foot'); ?>

