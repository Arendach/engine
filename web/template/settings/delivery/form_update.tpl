<?php include parts('modal_head'); ?>

    <form data-type="ajax" action="<?= uri('settings') ?>">

        <input type="hidden" name="id" value="<?= $item->id; ?>">
        <input type="hidden" name="action" value="delivery_update">

        <div class="form-group">
            <label for="name"><span class="text-danger">*</span> Назва</label>
            <input name="name" id="name" class="form-control" value="<?= $item->name; ?>">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary">Зберегти</button>
        </div>

    </form>

<?php include parts('modal_foot'); ?>