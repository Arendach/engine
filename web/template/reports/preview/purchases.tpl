<?php
/**
 * Закупки
 */
$data = json_decode($report->data);
$id = $data->id;
?>

<table class="table table-bordered">
    <tr>
        <td>
            Закупив товару на суму <?= $report->sum ?> грн.
            <a href="<?= route('purchases_print', ['id' => $id]) ?>">
                Детальніше...
            </a>(<?= diff_for_humans($report->date) ?>)
        </td>
    </tr>
</table>
