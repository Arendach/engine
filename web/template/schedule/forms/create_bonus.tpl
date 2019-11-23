<?php include parts('modal_head'); ?>

    <form action="<?= uri('schedule') ?>" data-type="ajax">
        <input type="hidden" name="action" value="create_bonus">
        <input type="hidden" name="year" value="<?= $year ?>">
        <input type="hidden" name="month" value="<?= month_valid($month) ?>">
        <input type="hidden" name="user" value="<?= $user ?>">

        <div class="form-group">
            <label for="sum"><i class="text-danger">*</i> Сума</label>
            <input required class="form-control form-control-sm" name="sum" id="sum" data-inspect="decimal">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-sm btn-primary">Зберегти</button>
        </div>

    </form>

<?php include parts('modal_foot') ?>