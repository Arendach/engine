<?php
/**
 * Предоплата закупки
 */
?>

<table class="table table-bordered">
    <tr>
        <td>
            Предоплата замовлення на суму <?= $report->sum ?> грн. (<?= diff_for_humans($report->date) ?>) <br>
            Ви можете переглянути тут
            <a href="<?= route('order_update', ['id' => $report->data]) ?>">
                детальніше
            </a>!
        </td>
    </tr>
</table>
