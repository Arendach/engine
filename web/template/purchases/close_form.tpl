<?php include parts('modal_head') ?>

    <form action="<?= uri('purchases') ?>" data-type="ajax">
        <input type="hidden" name="id" value="<?= $p->id ?>">
        <input type="hidden" name="action" value="close">
        <div class="form-group">
            <label for="name_operation">Назва операції</label>
            <input class="form-control" id="name_operation" name="name_operation"
                   value='Закупка по виробнику "<?= $p->manufacturer_name ?>"'>
        </div>

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea class="form-control" name="comment" id="comment"></textarea>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary" id="close">Зберегти</button>
        </div>
    </form>


<?php include parts('modal_foot') ?>