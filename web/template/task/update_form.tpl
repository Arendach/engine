<?php include parts('modal_head') ?>

    <form data-type="ajax" action="<?= uri('task') ?>">

        <input type="hidden" value="<?= $task->id ?>" name="id">
        <input type="hidden" name="action" value="update">

        <div class="form-group">
            <label for="type">Тип</label>
            <select id="type" class="form-control" name="type">
                <option <?= $task->type == 'info' ? 'selected' : '' ?> value="info">2-га черга</option>
                <option <?= $task->type == 'warning' ? 'selected' : '' ?> value="warning">1-ша черга</option>
                <option <?= $task->type == 'danger' ? 'selected' : '' ?> value="danger">ТЕРМІНОВО!</option>
                <option <?= $task->type == 'success' ? 'selected' : '' ?> value="success">Для виконаних</option>
            </select>
        </div>

        <div class="form-group">
            <label for="success">Статус</label>
            <select id="success" class="form-control" name="success">
                <option <?= $task->success == 0 ? 'selected' : '' ?> value="0">Чекає на виконання</option>
                <option <?= $task->success == 1 ? 'selected' : '' ?> value="1">Виконано</option>
                <option <?= $task->success == 2 ? 'selected' : '' ?> value="2">Не виконано</option>
            </select>
        </div>

        <div class="form-group">
            <label for="price1">Бюджет</label>
            <input name="price" id="price1" class="form-control" value="<?= $task->price ?>">
        </div>

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea class="form-control" name="comment" id="comment"><?= $task->comment ?></textarea>
        </div>

        <div class="form-group">
            <label for="content">Зміст задачі</label>
            <textarea id="ckeditor" name="content" class="form-control"><?= $task->content ?></textarea>
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