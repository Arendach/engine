<?php if (can()) { ?>
    <div class="right" style="margin-bottom: 15px;">
        <button data-type="get_form"
                data-uri="<?= uri('schedule') ?>"
                data-action="update_head_form"
                data-post="<?= params([
                    'year' => $data->year,
                    'month' => $data->month,
                    'user' => $data->user
                ]) ?>"
                class="btn btn-success">Редагувати
        </button>
    </div>
<?php } ?>

<table class="table-bordered table">
    <tr>
        <td>Коефіціент</td>
        <td><?= $data->coefficient; ?></td>
    </tr>

    <tr>
        <td>ЗП</td>
        <td><?= number_format($price_month - $hour_price * $up_working_hours * $data->coefficient, 2); ?> грн</td>
    </tr>

    <tr>
        <td>Бонуси за перепрацювання</td>
        <td><?= number_format($hour_price * $up_working_hours * $data->coefficient, 2); ?> грн</td>
    </tr>

    <tr>
        <td>Амортизація авто</td>
        <td><?= $data->for_car ?> грн</td>
    </tr>
    <tr>
        <td>Бонуси</td>
        <td><?= $data->bonus ?> грн</td>
    </tr>
    <tr>
        <td>Штрафи</td>
        <td><?= $data->fine ?> грн</td>
    </tr>
</table>

<table class="table table-bordered">
    <tr>
        <td>
            Нараховано:
            <i style="color: blue">
                <?= number_format($salary, 2) ?>грн
            </i>
        </td>

        <td class="centered">
            До виплати:
            <i style="color: red">
                <?= number_format(($salary) - $payouts_sum, 2) ?>грн
            </i>
        </td>

        <td class="right">
            Виплачено:
            <i style="color: green;">
                <?= number_format($payouts_sum, 2) ?>грн
            </i>
        </td>
    </tr>
</table>