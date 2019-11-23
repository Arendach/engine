<table class="table table-bordered">
    <tr>
        <td><b>ІД</b></td>
        <td><b>Назва</b></td>
        <td><b>Артикул</b></td>
        <td><b>Модель</b></td>
        <td><b>На складі</b></td>
        <td style="width: 250px"><b>+/-</b></td>
    </tr>
    <?php foreach ($products as $item) { ?>

        <tr data-id="<?= $item->id ?>">
            <td>
                <?= $item->id ?>
            </td>

            <td>
                <a href="<?= uri('product', ['section' => 'update', 'id' => $item->id]) ?>">
                    <?= $item->name ?>
                </a>
            </td>

            <td>
                <?= $item->articul ?>
            </td>

            <td>
                <?= $item->model ?>
            </td>

            <td>
                <?= $item->count_on_storage ?>
            </td>

            <td>
                <input style="width: 100%" class="amount" data-inspect="integer">
            </td>
        </tr>

    <?php } ?>
</table>

<div class="form-group">
    <label for="comment">Коментар</label>
    <textarea id="comment" class="form-control"></textarea>
</div>

<div class="form-group">
   <button class="btn btn-primary">Прийняти</button>
</div>