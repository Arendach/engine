<?php include parts('modal_head') ?>

    <form action="<?= uri('settings') ?>" data-type="ajax">
        <input type="hidden" name="action" value="update_characteristic">
        <input type="hidden" name="id" value="<?= $characteristic->id ?>">

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
                        <input value="<?= $characteristic->{"name_$item"} ?>" required type="text" name="name_<?= $item ?>" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Префікс</label>
                        <input value="<?= $characteristic->{"prefix_$item"} ?>" type="text" name="prefix_<?= $item ?>" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Постфікс</label>
                        <input value="<?= $characteristic->{"postfix_$item"} ?>" type="text" name="postfix_<?= $item ?>" class="form-control">
                    </div>
                    <div class="form-group">
                        <label>Значення</label>
                        <input value="<?= $characteristic->{"value_$item"} ?>" type="text" name="value_<?= $item ?>" class="form-control">
                    </div>
                </div>
            <?php } ?>
        </div>

        <div class="form-group">
            <label>Тип</label>
            <select name="type" class="form-control input-sm">
                <option <?= $characteristic->type == 'slider' ? 'selected' : '' ?> value="slider">
                    Слайдер
                </option>

                <option <?= $characteristic->type == 'slider-diapason' ? 'selected' : '' ?> value="slider-diapason">
                    Слайдер-діапазон
                </option>

                <option <?= $characteristic->type == 'switch' ? 'selected' : '' ?> value="switch">
                    Перемикач
                </option>

                <option <?= $characteristic->type == 'flags' ? 'selected' : '' ?> value="flags">
                    Прапорці
                </option>
            </select>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-sm btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>