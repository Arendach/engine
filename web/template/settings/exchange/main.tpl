<?php include parts('head'); ?>

<?php include t_file('settings.buttons'); ?>

    <form data-type="ajax" action="<?= uri('settings') ?>">
        <input type="hidden" name="action" value="update_currency">
        <?php foreach ($items as $item){ ?>
            <div class="form-group">
                <label for="<?= $item->code ?>"><?= $item->name ?></label>
                <input name="<?= $item->id ?>" id="<?= $item->code ?>" class="form-control" value="<?= $item->currency ?>">
            </div>
        <?php } ?>

        <div class="form-group">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('foot') ?>