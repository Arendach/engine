<?php
/**
 * Витрати на доставку
 */
preg_match_all('/([a-z_]+):(.*)/', $report->data, $matches);
$data = array_combine($matches[1], $matches[2]);
?>
<table class="table table-bordered">
    <tr>
        <td class="right">Бензин:</td>
        <td><?= number_format($data['gasoline'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Проїзд:</td>
        <td><?= number_format($data['journey'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Транспортні компанії:</td>
        <td><?= number_format($data['transport_company'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Пакувальні матеріали:</td>
        <td><?= number_format($data['packing_materials'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Амортизація авто:</td>
        <td><?= number_format($data['for_auto'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Зарплата курєрам:</td>
        <td><?= number_format($data['salary_courier'], 2) ?> грн</td>
    </tr>
    <tr>
        <td class="right">Витратні матеріали(інше):</td>
        <td><?= number_format($data['supplies'], 2) ?> грн</td>
    </tr>
</table>