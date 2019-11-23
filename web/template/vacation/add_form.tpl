<?php include parts('modal_head'); ?>

<?php if (my_count($errors) > 0) { ?>
    <ul>
        <?php foreach ($errors as $error) { ?>
            <li class="text-danger"><?= $error ?></li>
        <?php } ?>
    </ul>
<?php } else { ?>
    <form>

        <div class="form-group">
            <label for="with">Виберіть початкову дату</label>
            <input type="date" class="form-control input-sm field" id="with" placeholder="Виберіть початок" value="<?= date('Y-m-d') ?>">
        </div>

        <div class="form-group">
            <label for="count">Кількість днів</label>
            <input type="text" class="form-control input-sm field" id="count_days" placeholder="Кількість днів" data-inspect="integer">
        </div>

        <div id="place_for_result"></div>

        <div class="form-group" style="margin-bottom: 0;">
            <button disabled id="vacation_send" class="btn btn-primary btn-sm">Зберегти</button>
        </div>

    </form>
<?php } ?>

<?php include parts('modal_foot'); ?>