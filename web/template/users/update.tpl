<?php include parts('head'); ?>

    <ul class="nav nav-justified nav-pills">
        <li class="active"><a href="#main" data-toggle="tab">Загальна інформація</a></li>
        <li><a href="#password" data-toggle="tab">Пароль</a></li>
        <li><a href="#rate" data-toggle="tab">Ставка</a></li>
        <li><a href="#more" data-toggle="tab">Інше</a></li>
    </ul>

    <br>

    <div class="tab-content">

        <div class="tab-pane active" id="main">
            <form data-type="ajax" action="<?= uri('user') ?>">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<?= $manager->id ?>">

                <div class="form-group">
                    <label for="email">Електронна пошта</label>
                    <input id="email" name="email" type="email" class="form-control" value="<?= $manager->email ?>">
                </div>

                <div class="form-group">
                    <label for="first_name">Імя</label>
                    <input id="first_name" name="first_name" class="form-control" value="<?= $manager->first_name ?>">
                </div>

                <div class="form-group">
                    <label for="last_name">Прізвище</label>
                    <input id="last_name" name="last_name" class="form-control" value="<?= $manager->last_name ?>">
                </div>

                <div class="form-group">
                    <label for="name">Імя курєра(для списку)</label>
                    <input id="name" name="name" class="form-control" value="<?= $manager->name ?>">
                </div>

                <div class="form-group">
                    <label>Посада</label>
                    <select name="position" class="form-control">
                        <option value="0">Не вибрана</option>
                        <?php foreach ($positions as $position) { ?>
                            <option <?= $position->id == $manager->position ? 'selected' : '' ?> value="<?= $position->id ?>">
                                <?= $position->name ?>
                            </option>
                        <?php } ?>
                    </select>
                </div>


                <div class="form-group">
                    <label for="instruction">Посадова інструкція</label>
                    <textarea id="instruction" name="instruction"><?= $manager->instruction ?></textarea>
                </div>

                <script>CKEDITOR.replace('instruction')</script>

                <div class="form-group">
                    <label for="access">Група доступу</label>
                    <select id="access" class="form-control" name="access">
                        <?php if (can()) { ?>
                            <option <?= 9999 == $manager->access ? 'selected' : ''; ?> value="9999">ROOT</option>
                        <?php } ?>
                        <?php foreach ($access_groups as $group) { ?>
                            <option <?= $group->id == $manager->access ? 'selected' : ''; ?> value="<?= $group->id; ?>">
                                <?= $group->name; ?> (<?= $group->description; ?>)
                            </option>
                        <?php } ?>
                    </select>
                </div>

                <div class="form-group">
                    <button class="btn btn-primary">Зберегти</button>
                </div>

            </form>
        </div>

        <div class="tab-pane" id="password">
            <form action="<?= uri('user') ?>" data-type="ajax">
                <input type="hidden" name="action" value="update_password">
                <input type="hidden" name="id" value="<?= $manager->id ?>">

                <div class="form-group">
                    <label for="password">Новий пароль</label>
                    <input id="password" name="password" class="form-control" type="password">
                </div>

                <div class="form-group">
                    <label for="password_confirmation">Підтвердіть пароль</label>
                    <input id="password_confirmation" name="password_confirmation" class="form-control" type="password">
                </div>

                <div class="form-group">
                    <button class="btn btn-primary">Зберегти</button>
                </div>
            </form>
        </div>

        <div class="tab-pane" id="rate">
            <form action="<?= uri('user') ?>" data-type="ajax">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<?= $manager->id ?>">

                <div class="form-group">
                    <label>Ставка за місяць</label>
                    <input class="form-control" name="rate" value="<?= $manager->rate ?>" data-inspect="decimal">
                </div>

                <div class="form-group">
                    <button class="btn btn-primary">Зберегти</button>
                </div>

            </form>
        </div>

        <div class="tab-pane" id="more">
            <form action="<?= uri('user') ?>" data-type="ajax">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<?= $manager->id ?>">

                <div class="form-group">
                    <label>В архіві</label>
                    <select class="form-control" name="archive">
                        <option <?= !$manager->archive ? 'selected' : '' ?> value="0">Ні</option>
                        <option <?= $manager->archive ? 'selected' : '' ?> value="1">Так</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Показувати нагадування графіка роботи</label>
                    <select class="form-control" name="schedule_notice">
                        <option <?= !$manager->schedule_notice ? 'selected' : '' ?> value="0">Ні</option>
                        <option <?= $manager->schedule_notice ? 'selected' : '' ?> value="1">Так</option>
                    </select>
                </div>

                <div class="form-group">
                    <button class="btn btn-primary">Зберегти</button>
                </div>

            </form>
        </div>
    </div>


<?php include parts('foot'); ?>