<?php include parts('modal_head') ?>

    <form action="<?= uri('settings') ?>" data-type="ajax">
        <input type="hidden" name="action" value="create_merchant_card">
        <input type="hidden" name="merchant_id" value="<?= $merchant_id ?>">
        
        <div class="form-group">
            <label><i class="text-danger">*</i> Номер</label>
            <input required name="number" class="form-control">
        </div>

        <div class="form-group" style="margin-bottom: 0">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>