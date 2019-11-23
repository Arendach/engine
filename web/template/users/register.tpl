<?php include parts('head'); ?>

    <form data-type="ajax" action="<?= uri('user') ?>">

        <input type="hidden" name="action" value="register">
        <!-- Логін -->

        <div class="form-group">
            <label for="login"><span class="text-danger">*</span> Логін</label>
            <input id="login" required pattern="[a-zA-Z0-9]{3,16}" name="login" class="form-control">
        </div>

        <!-- Пароль -->

        <div class="form-group">
            <label for="password"><span class="text-danger">*</span> Пароль</label>
            <input id="password" name="password" class="form-control" required pattern="[0-9a-zA-Z]{6,18}">
        </div>

        <!-- Електронна пошта -->

        <div class="form-group">
            <label for="email"><span class="text-danger">*</span> Електронна пошта</label>
            <input id="email" name="email" type="email" class="form-control" required>
        </div>

        <!-- Імя -->

        <div class="form-group">
            <label for="first_name"><span class="text-danger">*</span> Імя</label>
            <input id="first_name" name="first_name" class="form-control" required>
        </div>

        <!-- Прізвище -->

        <div class="form-group">
            <label for="last_name"><span class="text-danger">*</span> Прізвище</label>
            <input id="last_name" name="last_name" class="form-control" required>
        </div>

        <!-- Імя курєра -->

        <div class="form-group">
            <label for="name"><span class="text-danger">*</span> Імя курєра(для списку)</label>
            <input id="name" name="name" class="form-control" required>
        </div>

        <div class="form-group">
            <label>Посада</label>
            <select name="position" class="form-control">
                <option value="0">Не вибрана</option>
                <?php foreach ($positions as $position) { ?>
                    <option value="<?= $position->id ?>">
                        <?= $position->name ?>
                    </option>
                <?php } ?>
            </select>
        </div>

        <!-- Група доступу -->

        <div class="form-group">
            <label for="access"><span class="text-danger">*</span> Група доступу</label>
            <select id="access" name="access" class="form-control">
                <?php if (can())
                    echo '<option value="9999">ROOT</option>';

                foreach ($access_groups as $group)
                    echo '<option value="' . $group->id . '">' . $group->name . ' (' . $group->description . ')</option>'; ?>
            </select>
        </div>

        <!-- Кнопка -->

        <div class="form-group">
            <button class="btn btn-primary">Реєструвати</button>
        </div>
    </form>

<?php include parts('foot'); ?>