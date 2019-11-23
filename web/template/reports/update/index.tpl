<?php include parts('modal_head'); ?>

    <form data-type="ajax" action="<?= uri('reports') ?>">

        <input type="hidden" value="<?= $report->id ?>" name="id">
        <input type="hidden" name="action" value="update_comment">

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea class="form-control input-sm" name="comment" id="comment"><?= htmlspecialchars($report->comment) ?></textarea>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary btn-sm">Оновити</button>
        </div>
    </form>

<?php include parts('modal_foot'); ?>