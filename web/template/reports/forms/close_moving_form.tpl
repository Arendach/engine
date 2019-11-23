<?php include parts('modal_head'); ?>

    <form data-type="ajax" action="<?= uri('reports') ?>">

        <input type="hidden" name="action" value="success_moving">
        <input type="hidden" value="<?= $report->id ?>" name="report_id">

        <div class="form-group">
            <label for="name_operation">Назва операції</label>
            <input class="form-control" id="name_operation" name="name_operation" required
                   value="Отримання коштів від <?= user($report->user)->login ?>">
        </div>

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea id="comment" class="form-control" name="comment"></textarea>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-success">Прийняти</button>
        </div>
    </form>

<?php include parts('modal_foot'); ?>