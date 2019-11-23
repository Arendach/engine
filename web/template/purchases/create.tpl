<?php include parts('head'); ?>

<?php if (get('manufacturer') != '' && get('manufacturer') != false) { ?>

    <script>
        var purchase = <?= json(['manufacturer' => get('manufacturer'), 'storage' => get('storage')]) ?>;
    </script>

    <h3><?= $manufacturer_name ?> => <?= $storage_name ?></h3>

    <?php include t_file('purchases.add_product') ?>

    <table class="table table-bordered">
        <thead>
        <th>Назва товару</th>
        <th style="width: 100px">На складі</th>
        <th>Кількість</th>
        <th>Закупівельна вартість($)</th>
        <th>Сума</th>
        <th></th>
        </thead>
        <tbody>

        </tbody>
    </table>

    <div class="form-group">
        <label for="sum">Сума</label>
        <input class="form-control" id="sum" data-inspect="decimal">
    </div>

    <div class="form-group">
        <label for="comment">Коментар</label>
        <textarea class="form-control" id="comment"></textarea>
    </div>

    <div class="form-group">
        <button class="btn btn-primary" id="create">Зберегти</button>
    </div>

<?php } else { ?>
    <form id="purchase_prepare">
        <div class="form-group"><label for="manufacturer">Виробник</label>
            <select required id="manufacturer" name="manufacturer" class="form-control">
                <option value=""></option>
                <?php foreach ($manufacturers as $manufacturer) {
                    if (!in_array($manufacturer->id, $opened)) { ?>
                        <option value="<?= $manufacturer->id ?>"><?= $manufacturer->name ?></option>
                    <?php }
                } ?>
            </select>
        </div>

        <div class="form-group">
            <label for="storage">Склад</label>
            <select required name="storage" id="storage" class="form-control">
                <?php foreach ($storage as $item) { ?>
                    <option value="<?= $item->id ?>"><?= $item->name ?></option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Дальше</button>
        </div>
    </form>

    <script>
        $(document).ready(function () {
            $('#purchase_prepare').on('submit', function (event) {
                event.preventDefault();

                var manufacturer = $(this).find('#manufacturer').val();
                var storage = $(this).find('#storage').val();

                GET.setObject({section: 'create', storage: storage, manufacturer: manufacturer}).go();
            });
        });
    </script>
<?php } ?>

<?php include parts('foot'); ?>