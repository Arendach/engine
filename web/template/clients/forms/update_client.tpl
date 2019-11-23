<?php include parts('modal_head') ?>

    <form data-type="ajax" action="<?= uri('clients') ?>">

        <input type="hidden" name="id" value="<?= $client->id ?>">
        <input type="hidden" name="action" value="update">

        <div class="form-group">
            <label for="name">Імя</label>
            <input required name="name" id="name" value="<?= $client->name ?>" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label for="email">Електронна пошта</label>
            <input type="text" name="email" id="email" value="<?= $client->email ?>" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label for="phone">Телефон</label>
            <input required name="phone" id="phone" value="<?= $client->phone ?>" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label for="group">Група</label>
            <select id="group" name="group" class="form-control input-sm">
                <option value="<?= $client->group; ?>"
                        class="none"><?= $client->group != 0 ? $client->group_name : 'Без групи' ?></option>
                <option value="0">Без групи</option>
                <?php if (isset($groups) && count($groups) > 0) {
                    foreach ($groups as $group) {
                        echo '<option value="' . $group->id . '">' . $group->name . '</option>';
                    }
                } ?>
            </select>
        </div>

        <div class="form-group">
            <label for="manager">Відповідальний менеджер</label>
            <select name="manager" id="manager" class="form-control input-sm">
                <option value="0"></option>
                <?php foreach ($users as $item) { ?>
                    <option <?= $item->id == $client->manager ? 'selected' : '' ?> value="<?= $item->id ?>">
                        <?= $item->login ?>
                    </option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label for="percentage">% від замовлення</label>
            <input name="percentage" id="percentage" class="form-control input-sm" value="<?= $client->percentage ?>">
        </div>


        <div class="form-group">
            <label for="address">Адреса</label>
            <input type="text" name="address" id="address" value="<?= $client->address ?>" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label for="summernote">Додаткова інформація</label>
            <textarea name="info" id="summernote" class="summernote"><?= $client->info ?></textarea>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary">Зберегти</button>
        </div>

    </form>

    <script>
        CKEDITOR.replace('info');
        $('#phone').inputmask('999-999-99-99');
    </script>

<?php include parts('modal_foot') ?>