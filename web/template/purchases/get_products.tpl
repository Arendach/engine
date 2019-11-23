<?php foreach ($items as $item) { ?>
    <tr class="product" data-id="<?= $item->id ?>">
        <td>
            <a href="<?= uri('product', ['section' => 'update', 'id' => $item->id]) ?>">
                <?= $item->name ?>
            </a>
        </td>
        <td><?= $item->count_on_storage == '' ? '<b style="color: red">Не числиться</b>' : $item->count_on_storage ?></td>
        <td><input class="form-control amount" value="1" data-inspect="integer"></td>
        <td><input class="form-control price" value="<?= $item->procurement_costs ?>" data-inspect="decimal"></td>
        <td><input disabled class="form-control sum" value="<?= $item->procurement_costs ?>"></td>
        <td class="action-1">
            <button class="btn btn-danger btn-xs">
                <span class="glyphicon glyphicon-remove delete"></span>
            </button>
        </td>
    </tr>
<?php } ?>