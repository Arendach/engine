<?php include parts('modal_head') ?>

    <form action="<?= uri('settings') ?>" data-type="ajax">
        <input type="hidden" name="action" value="create_ids">

        <div class="form-group">
            <label for="value">
                <span class="text-danger">*</span> Значення
                <span class="hint" data-toggle="tooltip" title="Значення можна перераховувати через кому, всі вони збережуться в базі як окремі пункти">?</span>
            </label>
            <input name="value" id="value" class="form-control input-sm">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-sm btn-primary">Зберегти</button>
        </div>
    </form>


    <script>
        $(document).ready(function () {
            $('[data-toggle="tooltip"]').tooltip();
        });
    </script>

<?php include parts('modal_foot') ?>