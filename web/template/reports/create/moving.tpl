<?php

$users = \Web\Model\User::findAll('users', 'archive = 0');

?>

<?php include parts('head') ?>

    <form data-type="ajax" action="<?= uri('reports') ?>">

        <input type="hidden" name="action" value="create_moving">

        <div class="form-group">
            <label for="user"><i class="text-danger">*</i> Менеджер</label>
            <select name="user" id="user" class="form-control" required>
                <option value=""></option>
                <?php foreach ($users as $user) { ?>
                    <?php if ($user->id != user()->id) { ?>
                        <option value="<?= $user->id ?>"><?= $user->login ?></option>
                    <?php } ?>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label for="sum"><i class="text-danger">*</i> Сума</label>
            <input type="text" class="form-control" id="sum" name="sum" required  data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="name_operation"><i class="text-danger">*</i> Назва операції</label>
            <input required class="form-control" id="name_operation" name="name_operation" value="Передача коштів ">
        </div>

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea class="form-control" id="comment" name="comment"></textarea>
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Перемістити</button>

        </div>

    </form>

    <script>
        $(document).ready(function () {
            var $body = $('body');

            $body.on('change', '#user', function () {
                $('#name_operation').val('Передача коштів ' + $(this).find(':selected').text());
            });

        });
    </script>


<?php include parts('foot') ?>