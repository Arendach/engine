<?php include parts('modal_head') ?>
<form>
    <table class="table table-bordered search">
        <tr>
            <td>№ замовлення</td>
            <td>Імя</td>
            <td>Телефон</td>
            <td>Дата</td>
            <td rowspan="2" class="vertical-centered">
                <button id="search" class="btn btn-primary">
                    <span class="glyphicon glyphicon-search"></span>
                </button>
            </td>
        </tr>
        <tr>
            <td><input class="search form-control input-sm" name="id"></td>
            <td><input class="search form-control input-sm" name="name"></td>
            <td><input class="search form-control input-sm" name="phone"></td>
            <td><input class="search form-control input-sm" type="date" name="date"></td>
        </tr>
        <?php if (my_count($recommended) > 0) { ?>
            <tr class="recommended">
                <td colspan="5">
                    <h4 class="centered">Рекомендовані</h4>
                </td>
            </tr>
            <?php foreach ($recommended as $item) { ?>
                <tr class="order_row" data-id="<?= $item->id; ?>">
                    <td><?= $item->id; ?></td>
                    <td><?= $item->fio; ?></td>
                    <td><?= $item->phone; ?></td>
                    <td colspan="2"><?= date_for_humans($item->date) ?></td>
                </tr>
            <?php } ?>
        <?php } ?>
    </table>

    <div id="place_search"></div>
    <button id="save" style="margin-top: 10px; <?= my_count($recommended) == 0 ? 'display: none' : '' ?>" class="btn btn-success">
        Зберегти
    </button>
</form>
<?php include parts('modal_foot') ?>
