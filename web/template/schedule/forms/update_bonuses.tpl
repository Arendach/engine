<?php include parts('modal_head') ?>

    <form data-type="ajax" action="<?= uri('schedule') ?>">

        <input type="hidden" name="id" value="<?= $data->id ?>">
        <input type="hidden" name="action" value="update_bonuses">

        <div class="form-group">
            <label for="for_car">За машину</label>
            <input class="form-control input-sm" name="for_car" id="for_car" value="<?= $data->for_car; ?>" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="bonus">Бонус</label>
            <input class="form-control input-sm" name="bonus" id="bonus" value="<?= $data->bonus;  ?>" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="fine">Штраф</label>
            <input class="form-control input-sm" name="fine" id="fine" value="<?= $data->fine;  ?>" data-inspect="decimal">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>