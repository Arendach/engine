<?php
/**
 * Прибутки
 */
?>
<table class="table table-bordered">
    <tr>
        <td>
            Прибуток в сумі <?= $report->sum ?> грн (<?= diff_for_humans($report->date) ?>)
        </td>
    </tr>
</table>