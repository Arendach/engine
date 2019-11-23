<?php include parts('head') ?>

    <form data-type="ajax" action="<?= uri('reports') ?>">

        <input type="hidden" name="action" value="create_profits">

        <div class="form-group">
            <label for="sum"><i class="text-danger">*</i> Сума</label>
            <input required type="text" class="form-control" id="sum" name="sum"   data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="name_operation"><i class="text-danger">*</i> Назва операції</label>
            <input required type="text" class="form-control" id="name_operation" name="name_operation"
                   value="Прибуток за <?= date_for_humans() ?>">
        </div>

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea class="form-control" id="comment" name="comment"></textarea>
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Прийняти</button>
        </div>

    </form>

<?php include parts('foot') ?>