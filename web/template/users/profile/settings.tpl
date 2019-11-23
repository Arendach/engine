<?php include parts('head'); ?>

    <form action="<?= uri('user') ?>" data-type="ajax">
        <input type="hidden" name="action" value="update_my_settings">

        <div class="form-group">
            <label for="language"><?= l('d.language') ?></label>
            <select class="form-control" name="language" id="language">
                <option <?= user()->lang == 'ua' ? 'selected' : '' ?> value="ua"><?= l('d.ua_lang') ?></option>
                <option <?= user()->lang == 'ru' ? 'selected' : '' ?> value="ru"><?= l('d.ru_lang') ?></option>
            </select>
        </div>

        <div class="form-group">
            <button class="btn btn-primary"><?= l('d.save') ?></button>
        </div>

    </form>

<?php include parts('foot') ?>