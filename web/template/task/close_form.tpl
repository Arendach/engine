<?php $title = 'Завершити задачу'; ?>
<?php include parts('modal_head') ?>
    <form id="close_task">

        <input type="hidden" value="<?= $type ?>" name="type">

        <input type="hidden" value="<?= $id ?>" name="id">

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea name="comment" id="comment" class="form-control"></textarea>
        </div>

        <div class="form-group">
            <button class="btn btn-<?= $type ?>">Завершити</button>
        </div>

    </form>

<?php include parts('modal_foot') ?>