<?php include parts('modal_head'); ?>

    <form data-type="ajax" action="<?= uri('settings') ?>">

        <input type="hidden" name="action" value="update_site">
        <input type="hidden" name="id" value="<?= $site->id ?>">

        <div class="form-group">
            <label for="name"><span class="text-danger">*</span> Назва</label>
            <input required class="form-control input-sm" name="name" id="name" value="<?= $site->name ?>">
        </div>

        <div class="form-group">
            <label for="url"><span class="text-danger">*</span> URL</label>
            <input required class="form-control input-sm" name="url" id="url" value="<?= $site->url ?>">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>

    </form>

<?php include parts('modal_foot') ?>