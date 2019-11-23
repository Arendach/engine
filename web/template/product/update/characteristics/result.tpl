<div class="characteristic" data-id="<?= $characteristic->characteristic_id ?? $characteristic->id ?>">
    <div class="row">
        <div class="col-md-6">
            <label><img src="<?= asset('icons/uk.ico') ?>">
                <?= $characteristic->name_uk ?>
            </label>
            <input class="form-control input-sm" name="<?= $characteristic->characteristic_id ?? $characteristic->id ?>[value_uk]" value="<?= $characteristic->value_uk ?>">
        </div>

        <div class="col-md-6">
            <label><img src="<?= asset('icons/ru.ico') ?>">
                <?= $characteristic->name_ru ?>
            </label>
            <input class="form-control input-sm" name="<?= $characteristic->characteristic_id ?? $characteristic->id ?>[value_ru]" value="<?= $characteristic->value_ru ?>">
        </div>
    </div>
    <button class="btn btn-danger btn-xs delete_characteristic">
        <i class="fa fa-remove"></i>
    </button>
</div>