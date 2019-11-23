<?php include parts('head'); ?>


<?php if ($purchases->type == 0) { ?>
    <form data-type="ajax" action="<?= uri('purchases') ?>" class="type_block" style="padding: 15px">
        <input type="hidden" name="action" value="update_type">
        <input type="hidden" name="id" value="<?= $purchases->id ?>">

        <div class="form-group">
            <label>Тип предзамовлення</label>
            <select name="type" class="form-control">
                <option <?= $purchases->type == 0 ? 'selected' : '' ?> value="0">Потрібно закупити</option>
                <option <?= $purchases->type == 1 ? 'selected' : '' ?> value="1">Прийнято на облік</option>
            </select>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>
<?php } ?>

<? if ($purchases->status != 2) { ?>
    <div class="type_block" style="padding: 15px">

        <div class="right" style="margin-bottom: 15px;">
            <button data-type="get_form"
                    data-uri="<?= uri('purchases') ?>"
                    data-action="payment_create_form"
                    data-post="<?= params(['id' => $purchases->id]) ?>"
                    class="btn btn-primary btn-success">Нова проплата
            </button>
        </div>

        <?php if (my_count($payments) > 0) { ?>
            <table class="table table-bordered">
                <tr>
                    <th>Менеджер</th>
                    <th>Дата</th>
                    <th>Сума($)</th>
                    <th>Курс</th>
                    <th>В гривнях</th>
                </tr>

                <?php foreach ($payments as $item) { ?>
                    <tr>
                        <td><?= user($item->user_id)->login ?></td>
                        <td><?= date_for_humans($item->date) ?></td>
                        <td><?= $item->sum ?></td>
                        <td><?= $item->course ?></td>
                        <td><?= $item->course * $item->sum ?></td>
                    </tr>
                <?php } ?>
            </table>
        <?php } else { ?>
            <h4 class="centered">Тут пусто :(</h4>
        <?php } ?>
    </div>

    <br>

<?php } ?>

<?php include t_file('purchases.add_product') ?>
    <div class="type_block" style="padding: 15px">
        <table class="table table-bordered" style="background-color: #fff">
            <thead>
            <th>Товар</th>
            <th>На складі</th>
            <th>Кількість</th>
            <th>Закупівельна вартість($)</th>
            <th>Сума($)</th>
            <th class="action-1">Дія</th>
            </thead>
            <tbody>
            <?php foreach ($items as $item) { ?>
                <tr class="product" data-id="<?= $item->product_id ?>">
                    <td>
                        <a href="<?= uri('product', ['section' => 'update', 'id' => $item->product_id]) ?>">
                            <?= $item->name ?>
                        </a>
                    </td>
                    <td><?= $item->count_on_storage == '' ? '<b style="color: red">Не числиться</b>' : $item->count_on_storage ?></td>
                    <td>
                        <input class="form-control amount" <?= $purchases->type == 1 ? 'disabled' : '' ?> value="<?= $item->amount ?>">
                    </td>
                    <td><input class="form-control price" value="<?= $item->price ?>"></td>
                    <td><input class="form-control sum" disabled
                               value="<?= number_format($item->price * $item->amount, 2) ?>"></td>
                    <td class="action-1">
                        <button class="btn btn-danger btn-xs">
                            <span class="glyphicon glyphicon-remove delete"></span>
                        </button>
                    </td>
                </tr>
            <?php } ?>
            </tbody>
        </table>

        <div class="form-group">
            <label for="sum">Сума</label>
            <input type="text" class="form-control" id="sum" value="<?= $purchases->sum ?>">
        </div>

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea class="form-control" id="comment"><?= $purchases->comment ?></textarea>
        </div>

        <div class="form-group">
            <button class="btn btn-primary" id="update">Зберегти</button>
        </div>
    </div>

    <script>
        var purchase = <?= json([
            'storage' => $purchases->storage_id,
            'manufacturer' => $purchases->manufacturer,
            'id' => $purchases->id]) ?>;
    </script>

<?php include parts('foot'); ?>