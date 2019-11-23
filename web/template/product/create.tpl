<?php include parts('head') ?>

<form class="form-horizontal" data-type="ajax" action="<?= uri('product') ?>">
    <input type="hidden" name="action" value="create">

    <div class="form-group">
        <label class="col-md-4 control-label">Назва <i class="text-danger">*</i></label>
        <div class="col-md-5">
            <input required name="name" class="form-control">
        </div>
    </div>

    <div class="form-group">
        <label class="col-md-4 control-label">Артикул <i class="text-danger">*</i></label>
        <div class="col-md-5">
            <input required name="articul" class="form-control">
        </div>
    </div>

    <div class="form-group">
        <label class="col-md-4 control-label">Модель <i class="text-danger">*</i></label>
        <div class="col-md-5">
            <input required name="model" class="form-control">
        </div>
    </div>

    <br>

    <div class="form-group">
        <label class="col-md-4 control-label">Ідентифікатор для складу <i class="text-danger">*</i></label>
        <div class="col-md-5">
            <div class="row">
                <div class="col-md-6">
                    <select required class="form-control" name="level1">
                        <option value=""></option>
                        <?php foreach ($ids as $k => $item) { ?>
                            <option value="<?= $k ?>"><?= $k ?></option>
                        <?php } ?>
                    </select>
                </div>
                <div class="col-md-6">
                    <select disabled name="level2" class="form-control"></select>
                </div>
            </div>
        </div>
    </div>

    <div class="form-group">
        <label class="col-md-4 control-label">Виробник <i class="text-danger">*</i></label>
        <div class="col-md-5">
            <select required name="manufacturer" class="form-control">
                <option value=""></option>
                <?php foreach ($manufacturers as $item) { ?>
                    <option value="<?= $item->id ?>"><?= $item->name ?></option>
                <?php } ?>
            </select>
        </div>
    </div>


    <div class="form-group">
        <label class="col-md-4 control-label">Тип <i class="text-danger">*</i></label>
        <div class="col-md-5">
            <select required name="combine" class="form-control">
                <option value="0">Одиничний</option>
                <option value="1">Комбінований</option>
            </select>
        </div>
    </div>

    <br>


    <div class="form-group">
        <label class="col-md-4 control-label">Вага</label>
        <div class="col-md-5">
            <input value="0" name="weight" class="form-control" data-inspect="decimal">
        </div>
    </div>

    <div class="form-group">
        <label class="col-md-4 control-label">Об'єм</label>
        <div class="col-md-5">
            <input style="width: calc(33.3% - 3px)" name="volume[]" value="0" data-inspect="integer">
            <input style="width: calc(33.3% - 3px)" name="volume[]" value="0" data-inspect="integer">
            <input style="width: calc(33.3% - 3px)" name="volume[]" value="0" data-inspect="integer">
            <input style="margin-top: 15px" id="volume"
                   value="0"
                   class="form-control"
                   disabled>
        </div>
    </div>

    <br>

    <div class="form-group">
        <label class="col-md-4 control-label">
            Закупівельна вартість<b style="color: #f00;">($)</b><i class="text-danger">*</i>
        </label>
        <div class="col-md-5">
            <input required name="procurement_costs" class="form-control" data-inspect="decimal">
        </div>
    </div>

    <div class="form-group">
        <label for="costs" class="col-md-4 control-label">
            Роздрібна вартість <i class="text-danger">*</i>
        </label>
        <div class="col-md-5">
            <input required name="costs" class="form-control" id="costs" data-inspect="decimal">
        </div>
    </div>

    <br>

    <div class="form-group">
        <label class="col-md-4 control-label">Категорія <i class="text-danger">*</i></label>
        <div class="col-md-5">
            <select required name="category" class="form-control">
                <option value=""></option>
                <?= $categories ?>
            </select>
        </div>
    </div>

    <div class="form-group service_code_container none">
        <label for="services_code" class="col-md-4 control-label">Сервісний код</label>
        <div class="col-md-5">
            <div disabled id="fake-service-code" class="fake-input">0</div>
            <input type="hidden" name="services_code" value="0">
        </div>
    </div>

    <br>

    <div class="form-group">
        <label class="col-md-4 control-label">Опис</label>
        <div class="col-md-5">
            <textarea class="form-control" name="description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <div class="col-sm-offset-4 col-md-5">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </div>

</form>

<script>
    var ids = <?= json($ids) ?>;

    $(document).ready(function () {
        CKEDITOR.replace('description');

        $(document).on('change', '[name=level1]', function () {
            var k = $(this).val();

            if (k == ''){
                $('[name=level2]').attr('disabled', 'disabled').html('');
                return;
            }

            var result = '';
            ids[k].forEach(function (i) {
                result = result + '<option value="' + i + '">' + i + '</option>';
            });

            $('[name=level2]').html(result).removeAttr('disabled');
        });
    });
</script>

<?php include parts('foot') ?>
