<?php include parts('head') ?>

    <form data-type="ajax" action="<?= uri('settings') ?>">
        <input type="hidden" name="action" value="black_dates_update">

        <div class="form-group">
            <label>Перерахуйте дати</label>
            <input class="form-control" name="dates" value="<?= $dates ?>">
            <div class="feedback" style="color: #ccc; font-size: 12px">
                Формат: 2000-01-01,2000-02-22
            </div>
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('foot') ?>