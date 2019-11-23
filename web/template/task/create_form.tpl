<?php include parts('modal_head') ?>

    <form data-type="ajax" action="<?= uri('task') ?>">

        <input type="hidden" name="action" value="create">

        <div class="form-group">
            <label for="user">Менеджер</label>
            <select class="form-control" name="user" id="user">
                <?php foreach ($users as $user) { ?>
                    <option <?= $user->id == $user_id ? 'selected' : '' ?> value="<?= $user->id ?>">
                        <?= $user->login ?>
                    </option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label for="price1">Бюджет</label>
            <input name="price" id="price1" class="form-control">
        </div>

        <div class="form-group">
            <label for="type">Тип</label>
            <select name="type" id="type" class="form-control">
                <option value="info">2-га черга</option>
                <option value="warning">1-ша черга</option>
                <option value="danger">ТЕРМІНОВО!</option>
                <option value="success">Для виконаних</option>
            </select>
        </div>

        <div class="form-group">
            <label for="content">Зміст</label>
            <textarea name="content" id="ckeditor" class="form-control"></textarea>
        </div>

        <script>
            $(document).ready(function () {
                CKEDITOR.replace('ckeditor');
            });

        </script>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>
