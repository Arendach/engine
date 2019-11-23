<?php foreach ($data as $item) { ?>
    <tr class="order_row" data-id="<?= $item->id; ?>">
        <td><?= $item->id; ?></td>
        <td><?= $item->fio; ?></td>
        <td><?= $item->phone; ?></td>
        <td colspan="2"><?= date_for_humans($item->date) ?></td>
    </tr>
<?php } ?>