<?php
$title = 'Новий шаблон';
include parts('modal_head');
?>

<?php include t_file('sms.marks') ?>

    <form data-type="ajax" action="<?= uri('sms') ?>">
        <input type="hidden" name="action" value="create">

        <div class="form-group">
            <label for="name"><span class="text-danger">*</span> Назва шаблону</label>
            <input type="text" id="name" name="name" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label for="type"><span class="text-danger">*</span> Тип</label>
            <select id="type" name="type" class="form-control input-sm">
                <option value="sending">Відправки</option>
                <option value="delivery">Доставки</option>
                <option value="self">Самовивіз</option>
                <option value="shop">Магазин</option>
            </select>
        </div>

        <div class="form-group">
            <label for="text"><span class="text-danger">*</span> Текст</label>
            <textarea id="text" name="text" class="form-control input-sm"></textarea>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>
    </form>


<?php include parts('modal_foot'); ?>