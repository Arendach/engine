<?php include parts('head'); ?>

<?php include t_file('settings.buttons') ?>

    <form action="<?= uri('settings') ?>" data-type="ajax">
        <input type="hidden" name="action" value="update_tardiness">

        <div class="form-group">
            <label for="tardiness"><?= l('users.time_tardiness') ?></label>
            <input type="text" class="form-control" name="tardiness" value="<?= setting('tardiness') ?>">
        </div>

        <div class="form-group">
            <button class="btn btn-primary"><?= l('d.save') ?></button>
        </div>
    </form>

<?php include parts('footer') ?>