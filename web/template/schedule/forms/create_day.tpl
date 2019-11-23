<?php include parts('modal_head') ?>

<form data-type="ajax" action="<?= uri('schedule') ?>">

    <input type="hidden" name="action" value="create_day">
    <input type="hidden" name="year" value="<?= $year ?>">
    <input type="hidden" name="month" value="<?= $month ?>">
    <input type="hidden" name="day" value="<?= $day ?>">
    <input type="hidden" name="user" value="<?= $user ?>">

    <div class="form-group" style="text-align: justify">
        <label style="width: 25%"><input type="radio" value="0" name="type"> Вихідний</label>
        <label style="width: 25%"><input checked type="radio" value="1" name="type"> Робочий</label>
        <label style="width: 25%"><input type="radio" value="2" name="type"> Відпустка</label>
        <label><input type="radio" value="3" name="type"> Лікарняний</label>
    </div>
    <div class="form-group">
        <label for="turn_up">Вихід на роботу</label>
        <input class="form-control input-sm time" id="turn_up" name="turn_up" data-inspect="integer">
    </div>

    <div class="form-group">
        <label for="went_away">Повернення додому</label>
        <input class="form-control input-sm time" id="went_away" name="went_away" data-inspect="integer">
    </div>

    <div class="form-group">
        <label for="dinner_break">Обідня перерва </label>
        <input class="form-control input-sm time" id="dinner_break" name="dinner_break" data-inspect="integer">
    </div>

    <div class="form-group">
        <label for="work_day">Робочий день</label>
        <input class="form-control input-sm time" id="work_day" name="work_day" data-inspect="integer">

    </div>

    <div class="form-group" style="margin-bottom: 0;">
        <button class="btn btn-primary btn-sm">Зберегти</button>
    </div>

</form>

<?php include parts('modal_foot') ?>

