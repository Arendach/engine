<?php include parts('modal_head') ?>

    <form action="<?= uri('settings') ?>" data-type="ajax">
        <input type="hidden" name="action" value="create_shop">

        <div class="form-group">
            <label><span class="text-danger">*</span> Назва</label>
            <div class="row">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-addon">
                            <img src="<?= asset('icons/uk.ico') ?>">
                        </span>
                        <input required name="name" class="form-control input-sm">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-addon">
                            <img src="<?= asset('icons/ru.ico') ?>">
                        </span>
                        <input required name="name_ru" class="form-control input-sm">
                    </div>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label><span class="text-danger">*</span> Адреса</label>

            <div class="row">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-addon">
                            <img src="<?= asset('icons/uk.ico') ?>">
                        </span>
                        <input required name="address" class="form-control input-sm">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-addon">
                            <img src="<?= asset('icons/ru.ico') ?>">
                        </span>
                        <input required name="address_ru" class="form-control input-sm">
                    </div>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label>Адреса маршруту(URL)</label>
            <input required name="url_path" class="form-control input-sm">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-sm btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>