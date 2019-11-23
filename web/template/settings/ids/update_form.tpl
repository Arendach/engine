<?php include parts('modal_head'); ?>

    <form data-type="ajax" action="<?= uri('settings') ?>">
        <input type="hidden" name="action" value="update_ids">
        <input type="hidden" name="id" value="<?= $ids->id ?>">

        <div class="form-group">
            <label for="value"><span class="text-danger">*</span> Значення</label>
            <input class="form-control input-sm" name="value" id="value" value="<?= $ids->level1 . '-' . $ids->level2 ?>">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-sm btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>