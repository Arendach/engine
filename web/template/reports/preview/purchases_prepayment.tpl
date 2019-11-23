<?php
/**
 * Предоплата закупки
 */
?>

<table class="table table-bordered">
    <tr>
        <td>
            Предоплачена закупка на суму <?= $report->sum ?> грн. (<?= diff_for_humans($report->date) ?>) <br>
            Ви можете переглянути тут
            <a href="<?= route('purchases_print', ['id' => $report->data]) ?>">
                детальніше
            </a>!
        </td>
    </tr>
</table>
