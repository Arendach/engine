<?php include parts('modal_head') ?>

<form action="<?= uri('position') ?>" data-type="ajax">
    <input type="hidden" name="action" value="create">

    <div class="form-group">
        <label>Назва</label>
        <input class="form-control" name="name">
    </div>

    <div class="form-group">
        <label>Опис</label>
        <textarea name="description"></textarea>
    </div>

    <div class="form-group" style="margin-bottom: 0;">
        <button class="btn btn-primary">Зберегти</button>
    </div>
</form>

<script>
    CKEDITOR.replace('description')
</script>

<?php include parts('modal_foot') ?>
