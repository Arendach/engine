<?php
/**
 * Витрати на доставку
 */
preg_match_all('/([a-z_]+):(.*)/', $report->data, $matches);
$data = array_combine($matches[1], $matches[2]);
?>
<table class="table table-bordered">
    <tr>
        <td class="right">Податки:</td>
        <td><?= number_format($data['taxes'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Інвестиції:</td>
        <td><?= number_format($data['investment'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Мобільний звязок:</td>
        <td><?= number_format($data['mobile'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Оренда:</td>
        <td><?= number_format($data['rent'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Соціальні програми:</td>
        <td><?= number_format($data['social'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Витратні матеріали:</td>
        <td><?= number_format($data['other'], 2) ?> грн</td>
    </tr>
</table>