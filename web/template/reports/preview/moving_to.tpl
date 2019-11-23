<?php
/**
 * Отримання коштів від ....
 */
?>
<table class="table table-bordered">
    <tr>
        <td>Отримав кошти в розмірі <?= $report->sum ?> грн від менеджера <?= user($report->data)->login ?> (<?= diff_for_humans($report->date) ?>)</td>
    </tr>
</table>