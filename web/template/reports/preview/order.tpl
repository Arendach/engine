<table class="table table-bordered">
    <tr>
        <td>
            Закрито замовлення <a href="<?= route('order_update', ['id' => $report->data]) ?>">
                №<?= $report->data ?>
            </a> (<?= diff_for_humans($report->date) ?>)
        </td>
    </tr>
</table>