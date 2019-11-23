<?php include parts('modal_head'); ?>

    <form action="<?= uri('schedule') ?>" data-type="ajax">
        <input type="hidden" name="action" value="update_bonus">
        <input type="hidden" name="id" value="<?= $bonus->id ?>">
        <input type="hidden" name="year" value="<?= $post->year ?>">
        <input type="hidden" name="month" value="<?= $post->month ?>">
        <input type="hidden" name="user" value="<?= $post->user ?>">

        <div class="form-group">
            <label for="sum"><i class="text-danger">*</i> Сума</label>
            <input required type="number" class="form-control form-control-sm" name="sum" id="sum" value="<?= $bonus->sum ?>" data-inspect="decimal">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-sm btn-primary">Зберегти</button>
        </div>

    </form>

<?php include parts('modal_foot') ?>