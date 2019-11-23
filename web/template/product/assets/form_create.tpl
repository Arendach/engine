<?php include parts('modal_head') ?>

    <form action="<?= uri('product') ?>" data-type="ajax">
        <input type="hidden" name="action" value="create_assets">

        <div class="form-group">
            <label><i class="text-danger">*</i> Назва</label>
            <input required name="name" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label>Ідентифікатор для складу</label>
            <input name="id_in_storage" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label>Опис</label>
            <textarea name="description" class="form-control input-sm"></textarea>
        </div>

        <div class="form-group">
            <label><i class="text-danger">*</i> Склад</label>
            <select required name="storage" class="form-control input-sm">
                <option value=""></option>
                <?php foreach ($storage as $item) { ?>
                    <option value="<?= $item->id ?>"><?= $item->name ?></option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label><i class="text-danger">*</i> Ціна</label>
            <input required name="price" class="form-control input-sm" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label><i class="text-danger">*</i> Курс</label>
            <input required name="course" class="form-control input-sm" data-inspect="decimal">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>