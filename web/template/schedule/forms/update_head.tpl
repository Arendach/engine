<?php include parts('modal_head') ?>

<form data-type="ajax" action="<?= uri('schedule') ?>">

    <input type="hidden" name="id" value="<?= $data->id ?>">
    <input type="hidden" name="action" value="update_head">

    <div class="form-group">
        <label for="coefficient">Коефіціент</label>
        <input class="form-control input-sm" name="coefficient" id="coefficient" value="<?= $data->coefficient ?>" data-inspect="decimal">
    </div>

    <div class="form-group">
        <label for="price_month">Ставка за місяць</label>
        <input class="form-control input-sm" id="price_month" name="price_month" value="<?= $data->price_month ?>" data-inspect="decimal">
    </div>

    <div class="form-group" style="margin-bottom: 0;">
        <button class="btn btn-primary btn-sm">Зберегти</button>
    </div>
</form>

<?php include parts('modal_foot') ?>
