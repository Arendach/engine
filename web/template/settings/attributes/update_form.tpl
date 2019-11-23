<?php include parts('modal_head'); ?>

    <form data-type="ajax" action="<?= uri('settings') ?>">

        <input type="hidden" name="id" value="<?= $attribute->id ?>">
        <input type="hidden" name="action" value="update_attribute">

        <div class="form-group">
            <label><i class="text-danger">*</i> Назва</label>

            <div class="row">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-addon">
                            <img src="<?= asset('icons/uk.ico') ?>">
                        </span>
                        <input class="form-control input-sm" name="name"  value="<?= $attribute->name ?>">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-addon">
                            <img src="<?= asset('icons/ru.ico') ?>">
                        </span>
                        <input class="form-control input-sm" name="name_ru"  value="<?= $attribute->name_ru ?>">
                    </div>
                </div>
            </div>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot'); ?>