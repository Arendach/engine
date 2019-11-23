<?php
$s = isset($_GET['status']) ? true : false;
include parts('head')
?>

    <table class="table table-bordered">
        <tr>
            <td>Початкова дата</td>
            <td>Кінцева дата</td>
            <td>Показувати</td>
            <td>Тип</td>
            <td>Статус</td>
            <td class="right">Дії</td>
        </tr>
        <tr>
            <td>
                <input class="search" name="date_with" type="date" value="<?= get('date_with') ?>">
            </td>

            <td>
                <input class="search" name="date_to" type="date" value="<?= get('date_to') ?>">
            </td>

            <td>
                <select class="search" name="display">
                    <option value=""></option>
                    <option <?= get('display') == 'year' ? 'selected' : '' ?> value="year">Роки</option>
                    <option <?= get('display') == 'month' ? 'selected' : '' ?> value="month">Місяці</option>
                    <option <?= get('display') == 'week' ? 'selected' : '' ?> value="week">Тижні</option>
                    <option <?= get('display') == 'day' ? 'selected' : '' ?> value="day">Дні</option>
                </select>
            </td>

            <td>
                <select class="search" id="type" name="type">
                    <option value=""></option>
                    <option <?= get('type') == 'delivery' ? 'selected' : '' ?> value="delivery">Доставка</option>
                    <option <?= get('type') == 'shop' ? 'selected' : '' ?> value="shop">Магазин</option>
                    <option <?= get('type') == 'sending' ? 'selected' : '' ?> value="sending">Відправка</option>
                    <option <?= get('type') == 'self' ? 'selected' : '' ?> value="self">Самовивіз</option>
                </select>
            </td>

            <td>
                <?php if (get('type')) { ?>
                    <select class="search" id="status" name="status">
                        <option value=""></option>
                        <?php foreach (\Web\Model\OrderSettings::statuses(get('type')) as $k => $status) {
                            if ($s === true) $selected = get('status') == $k ? 'selected' : ''; else $selected = ''; ?>
                            <option <?= $selected ?> value="<?= $k ?>"><?= $status->text ?></option>
                        <?php } ?>
                    </select>
                <?php } else { ?>
                    <select class="search" id="status" disabled name="status">
                        <option value=""></option>
                    </select>
                <?php } ?>
            </td>

            <td rowspan="2" class="right">
                <button id="filter" class="btn btn-primary">Фільтр</button>
            </td>
        </tr>
    </table>

    <hr>

    <table class="table table-bordered">
        <tr>
            <td>Дата</td>
            <td>Ціна доставки</td>
            <td>Знижка</td>
            <td>Закупка</td>
            <td>Дохід</td>
            <td>Сума</td>
            <td>Замовлень</td>
        </tr>
        <?php foreach ($data as $item) { ?>
            <tr>
                <td>
                    <?= $item['start'] . " / " . $item['finish'] ?>
                </td>
                <td>
                    <?= number_format($item['delivery_cost'], 2) ?> грн
                </td>

                <td>
                    <?= number_format($item['discount'], 2) ?> грн
                </td>

                <td>
                    <?= number_format($item['procurement_costs'], 2) ?> грн
                </td>

                <td>
                    <?= number_format($item['full_sum'] - $item['procurement_costs'] - $item['discount'] + $item['delivery_cost'] , 2) ?> грн
                </td>

                <td>
                    <?= number_format($item['full_sum'], 2) ?> грн
                </td>

                <td>
                    <?= $item['count'] ?></td>
            </tr>
        <?php } ?>
    </table>

<?php include parts('foot') ?>