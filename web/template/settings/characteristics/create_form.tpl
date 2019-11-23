<?php include parts('modal_head') ?>

    <form action="<?= uri('settings') ?>" data-type="ajax">
        <input type="hidden" name="action" value="create_characteristic">

        <!-- Nav tabs -->
        <ul class="nav nav-tabs nav-justified">
            <li class="active">
                <a href="#uk" data-toggle="tab">
                    <img src="<?= asset('icons/uk.ico') ?>">
                </a>
            </li>
            <li>
                <a href="#ru" data-toggle="tab">
                    <img src="<?= asset('icons/ru.ico') ?>">
                </a>
            </li>
        </ul>

        <br>

        <div class="tab-content">
            <?php foreach (['uk', 'ru'] as $item) { ?>
                <div class="tab-pane<?= $item == 'uk' ? ' active' : '' ?>" id="<?= $item ?>">
                    <div class="form-group">
                        <label><i class="text-danger">*</i> Назва</label>
                        <input required type="text" name="name_<?= $item ?>" class="form-control input-sm">
                    </div>

                    <div class="form-group">
                        <label>Префікс</label>
                        <input type="text" name="prefix_<?= $item ?>" class="form-control input-sm">
                    </div>

                    <div class="form-group">
                        <label>Постфікс</label>
                        <input type="text" name="postfix_<?= $item ?>" class="form-control input-sm">
                    </div>
                    <div class="form-group">
                        <label>Значення</label>
                        <input type="text" name="value_<?= $item ?>" class="form-control input-sm">
                    </div>
                </div>
            <?php } ?>
        </div>

        <div class="form-group">
            <label>Тип</label>
            <select name="type" class="form-control input-sm">
                <option value="slider">Слайдер</option>
                <option value="slider-diapason">Слайдер-діапазон</option>
                <option value="switch">Перемикач</option>
                <option value="flags">Прапорці</option>
            </select>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-sm btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>