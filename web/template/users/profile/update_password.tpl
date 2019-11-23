<?php include parts('head'); ?>

    <div class="type_block">
        <form action="<?= uri('user') ?>" data-type="ajax">
            <input type="hidden" name="id" value="<?= user()->id ?>">
            <input type="hidden" name="action" value="update_password">

            <div class="form-group">
                <label for="password">Новий пароль</label>
                <input id="password" required name="password" class="form-control" type="password" minlength="6">
            </div>

            <div class="form-group">
                <label for="password_confirmation">Підтвердіть пароль</label>
                <input id="password_confirmation" required name="password_confirmation" class="form-control"
                       type="password" minlength="6">
            </div>

            <div class="form-group">
                <button class="btn btn-primary">Зберегти</button>
            </div>
        </form>
    </div>

    <br>

    <div class="type_block">
        <form action="<?= uri('user') ?>" data-type="ajax">
            <input type="hidden" name="id" value="<?= user()->id ?>">
            <input type="hidden" name="action" value="update_pin">

            <div class="form-group">
                <label for="pin">Новий пін-код</label>
                <input required name="pin" maxlength="3" id="pin" class="form-control" type="password">
            </div>

            <div class="form-group">
                <label for="password_confirmation">Підтвердіть пін-код</label>
                <input maxlength="3" required name="pin_confirmation" id="pin_confirmation" class="form-control"
                       type="password">
            </div>

            <div class="form-group">
                <button class="btn btn-primary">Зберегти</button>
            </div>
        </form>
    </div>

<?php include parts('foot'); ?>