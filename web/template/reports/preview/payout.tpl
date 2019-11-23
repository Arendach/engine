<table class="table table-bordered">
    <tr>
        <td class="right">Сума виплати:</td>
        <td><?= number_format($report->sum, 2) ?> грн</td>
    </tr>

    <tr>
        <td class="right">Дата:</td>
        <td><?= $report->date ?></td>
    </tr>
</table>