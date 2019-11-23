<?php
/**
 * Переміщення коштів
 */

list($user, $status) = explode(':', $report->data);

?>

<table class="table table-bordered">
    <tr>
        <td>
            <?php if ($status) { ?>
                Передано кошти в сумі <?= $report->sum ?> грн менеджеру <?= user($user)->login ?> (<?= diff_for_humans($report->date) ?>)
            <?php } else { ?>
                Чекає на підтвердження від <?= user($user)->login ?> про отримання коштів у розмірі  <?= $report->sum ?> грн (<?= diff_for_humans($report->date) ?>)
            <?php } ?>
        </td>
    </tr>
</table>