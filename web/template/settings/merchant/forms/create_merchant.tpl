<?php include parts('modal_head') ?>

    <form action="<?= uri('settings') ?>" data-type="ajax">
        <input type="hidden" name="action" value="create_merchant">

        <div class="form-group">
            <label><i class="text-danger">*</i> Імя</label>
            <input required name="name" class="form-control">
        </div>

        <div class="form-group">
            <label><i class="text-danger">*</i> Пароль</label>
            <input required name="password" class="form-control">
        </div>

        <div class="form-group">
            <label><i class="text-danger">*</i> Ідентифікатор</label>
            <input required name="merchant_id" class="form-control">
        </div>

        <div class="form-group" style="margin-bottom: 0">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>