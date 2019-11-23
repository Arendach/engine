<div class="row">
    <div class="col-md-offset-4 col-md-5">
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
    </div>
</div>

<br>

<form action="<?= uri('product') ?>" data-type="ajax" class="form-horizontal">
    <input type="hidden" name="action" value="update_info">
    <input type="hidden" name="id" value="<?= $product->id ?>">

    <div class="tab-content">
        <?php foreach (['', 'ru'] as $item) { ?>
            <div class="tab-pane <?= $item == '' ? 'active' : '' ?>" id="<?= $item == '' ? 'uk' : 'ru' ?>">
                <div class="form-group">
                    <label for="name" class="col-md-4 control-label">
                        Назва <i class="text-danger">*</i>
                    </label>
                    <div class="col-md-5">
                        <input name="<?= $item == '' ? 'name' : 'name_ru' ?>" value="<?= $product->{$item == '' ? 'name' : 'name_ru'}; ?>" class="form-control">
                    </div>
                </div>

                <div class="form-group">
                    <label for="model" class="col-md-4 control-label">
                        Модель <i class="text-danger">*</i>
                    </label>
                    <div class="col-md-5">
                        <input value="<?= $product->{$item == '' ? 'model' : 'model_ru'} ?>" name="<?= $item == '' ? 'model' : 'model_ru' ?>" class="form-control">
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 0">
                    <label class="col-md-4 control-label">Опис</label>
                    <div class="col-md-5">
                        <textarea name="<?= $item == '' ? 'description' : 'description_ru' ?>" class="form-control"><?= $product->{$item == '' ? 'description' : 'description_ru'} ?></textarea>
                    </div>
                </div>
            </div>
        <?php } ?>
    </div>

    <div class="row"><div class="col-md-offset-4 col-md-5"><hr></div></div>

    <div class="form-group">
        <label for="articul" class="col-md-4 control-label">
            Артикул <i class="text-danger">*</i>
        </label>
        <div class="col-md-5">
            <input value="<?= $product->articul; ?>" name="articul" class="form-control " id="articul">
        </div>
    </div>


    <div class="form-group">
        <label for="services_code" class="col-md-4 control-label">
            Сервісний код <i class="text-danger">*</i>
        </label>
        <div class="col-md-5">
            <input value="<?= $product->services_code; ?>" name="services_code" class="form-control"
                   id="services_code">
        </div>
    </div>

    <div class="form-group">
        <label for="procurement_costs" class="col-md-4 control-label">
            Закупівельна вартість(в доларах) <i class="text-danger">*</i>
        </label>
        <div class="col-md-5">
            <input value="<?= $product->procurement_costs; ?>" name="procurement_costs"
                   class="form-control" id="procurement_costs" data-inspect="decimal">
        </div>
    </div>

    <?php if (!$product->combine) { ?>
        <div class="form-group">
            <label for="costs" class="col-md-4 control-label">
               Роздрібна вартість <i class="text-danger">*</i>
            </label>
            <div class="col-md-5">
                <input value="<?= $product->costs; ?>" name="costs" class="form-control" id="costs" data-inspect="decimal">
            </div>
        </div>
    <?php } ?>

    <br>

    <div class="form-group">
        <label for="category" class="col-md-4 control-label">Категорія</label>
        <div class="col-md-5">
            <select name="category" class="form-control" id="category">
                <option class="none" selected value="<?= $product->category; ?>"><?= $product->category_name ?></option>
                <?= isset($categories) ? $categories : ''; ?>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="manufacturer" class="col-md-4 control-label">Виробник</label>
        <div class="col-md-5">
            <select id="manufacturer" name="manufacturer" class="form-control">
                <?php if (isset($manufacturers)) {
                    foreach ($manufacturers as $m) { ?>
                        <option <?= $m->id == $product->manufacturer ? 'selected' : ''; ?>
                                value="<?php echo $m->id ?>"><?php echo $m->name ?></option>
                    <?php }
                } ?>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="identefire_storage" class="col-md-4 control-label">Ідентифікатор для складу</label>
        <div class="col-md-5">
            <div class="row">
                <div class="col-md-6">
                    <select class="form-control" name="level1">
                        <option class="none" value="<?= $product->level1 ?>"><?= $product->level1 ?></option>
                        <?php foreach ($ids as $l1 => $items) { ?>
                            <option value="<?= $l1 ?>"><?= $l1 ?></option>
                        <?php } ?>
                    </select>
                </div>

                <div class="col-md-6">
                    <select name="level2" class="form-control">
                        <option class="none" value="<?= $product->level2 ?>"><?= $product->level2 ?></option>
                        <?php foreach ($ids[$product->level1] as $item) { ?>
                            <option value="<?= $item ?>"><?= $item ?></option>
                        <?php } ?>

                    </select>
                </div>
            </div>

        </div>
    </div>

    <br>

    <div class="form-group">
        <label for="weight" class="col-md-4 control-label">Вага</label>
        <div class="col-md-5">
            <input value="<?= $product->weight; ?>" name="weight" class="form-control" id="weight" data-inspect="decimal">
        </div>
    </div>

    <div class="form-group">
        <label for="volume" class="col-md-4 control-label">Об'єм</label>
        <div class="col-md-5">

            <input style="width: calc(33.3% - 3px)" name="volume[]" value="<?= $volume[0] ?>" data-inspect="integer">
            <input style="width: calc(33.3% - 3px)" name="volume[]" value="<?= $volume[1] ?>" data-inspect="integer">
            <input style="width: calc(33.3% - 3px)" name="volume[]" value="<?= $volume[2] ?>" data-inspect="integer">
            <input style="margin-top: 15px" id="volume"
                   value="<?= ($volume[0] * $volume[1] * $volume[2]) / 1000000; ?>"
                   class="form-control"
                   disabled>
        </div>
    </div>

    <div class="form-group">
        <div class="col-md-offset-4 col-md-5">
            <button class="btn btn-primary">Оновити</button>
        </div>
    </div>
</form>

<script>
    var ids = <?= json($ids) ?>;

    $(document).ready(function () {
        CKEDITOR.replace('description');
        CKEDITOR.replace('description_ru');

        $(document).on('change', '[name=level1]', function () {
            var k = $(this).val();
            var result = '';
            ids[k].forEach(function (i) {
                result = result + '<option value="' + i + '">' + i + '</option>';
            });

            $('[name=level2]').html(result);
        });
    });
</script>