<?php

function _dis($type)
{
    if ($type == '3' || $type == 2) return 'disabled'; else return '';
}

include parts('modal_head') ?>

<form data-type="ajax" action="<?= uri('schedule') ?>">

    <input type="hidden" name="id" value="<?= $wsd->id ?>">
    <input type="hidden" name="action" value="update_day">

    <div class="form-group" style="text-align: justify">
        <label style="width: 25%">
            <input <?= $wsd->type == '0' ? 'checked' : '' ?> type="radio" value="0" name="type">
            Вихідний
        </label>
        <label style="width: 25%">
            <input <?= $wsd->type == '1' ? 'checked' : '' ?> type="radio" value="1" name="type">
            Робочий
        </label>
        <label style="width: 25%">
            <input <?= $wsd->type == '2' ? 'checked' : '' ?> type="radio" value="2" name="type">
            Відпустка
        </label>
        <label>
            <input <?= $wsd->type == '3' ? 'checked' : '' ?> type="radio" value="3" name="type">
            Лікарняний
        </label>
    </div>
    <div class="form-group">
        <label for="turn_up">Вихід на роботу</label>
        <input class="form-control" name="turn_up" id="turn_up" <?= _dis($wsd->type) ?> value="<?= $wsd->turn_up ?>" data-inspect="integer">
    </div>

    <div class="form-group">
        <label for="went_away">Повернення додому</label>
        <input class="form-control" name="went_away" <?= _dis($wsd->type) ?> id="went_away" value="<?= $wsd->went_away ?>" data-inspect="integer">
    </div>

    <div class="form-group">
        <label for="work_day">Робочий день</label>
        <input class="form-control" name="work_day" id="work_day" <?= _dis($wsd->type) ?> value="<?= $wsd->work_day ?>" data-inspect="integer">
    </div>

    <div class="form-group">
        <label for="dinner_break">Обідня перерва </label>
        <input class="form-control" name="dinner_break" <?= _dis($wsd->type) ?> value="<?= $wsd->dinner_break ?>" id="dinner_break" data-inspect="integer">
    </div>

    <div class="form-group">
        <button class="btn btn-primary">Зберегти</button>
    </div>

</form>

<?php include parts('modal_foot') ?>
