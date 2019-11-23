<?php

$users = \Web\Model\User::findAll('users', 'archive = 0');

?>

<?php include parts('head') ?>

    <form data-type="ajax" action="<?= uri('reports') ?>">

        <input type="hidden" name="action" value="reserve_funds_update">

        <div class="form-group">
            <label for="act">Дія</label>
            <select class="form-control" id="act" name="act" required>
                <option <?= $max_up <= 0 ? 'disabled' : '' ?> value="put">Поставити</option>
                <option <?= $max_down <= 0 ? 'disabled' : '' ?> value="take">Забрати</option>
            </select>
        </div>

        <div class="form-group">
            <label for="sum">Введіть суму</label>
            <input <?= $max_up <= 0 && $max_down <= 0 ? 'disabled' : '' ?> id="sum" name="sum" type="text" class="form-control" required data-inspect="decimal">
            <span style="font-size: 11px">
            Максимальна сума яку можна поставити в резерв <span
                        class="text-primary"><?= $max_up < 0 ? '0.00' : $max_up ?>грн</span>, максимальна сума яку можна забрати з резерву <span
                        class="text-primary"><?= $max_down ?>грн</span>
        </span>
        </div>

        <div class="form-group">
            <button <?= $max_up <= 0 && $max_down <= 0 ? 'disabled' : '' ?> class="btn btn-primary">Вперед</button>
        </div>
    </form>

<?php include parts('foot') ?>