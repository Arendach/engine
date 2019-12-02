<?php $rand32 = rand32() ?>

<?php foreach ($products as $product) { ?>
    <tr class="product">
        <td class="product_name">
            <a target="_blank" href="<?= uri('product', ['section' => 'update', 'id' => $product->id]) ?>">
                <?= $product->name ?>
            </a>
        </td>

        <td>
            <select name="products[<?= $rand32 ?>][storage]" id="" class="form-control">
                <?php foreach ($product->storage_list as $item) { ?>
                    <option value="<?= $item->storage->id ?>">
                        <?= $item->count ?>: <?= $item->storage->name ?>
                    </option>
                <?php } ?>
            </select>
        </td>

        <td>
            <input name="products[<?= $rand32 ?>][amount]" class="amount form-control" value="1" data-inspect="integer">
        </td>

        <td>
            <input name="products[<?= $rand32 ?>][price]" class="price form-control"
                   value="<?= round($product->costs) ?>" data-inspect="decimal">
        </td>

        <td style="width: 71px">
            <input style="width: 54px" disabled class="sum form-control" value="<?= round($product->costs) ?>">
        </td>

        <td class="attributes">
            <?php foreach ($product->attributes as $key => $attr) { ?>
                <div>
                    <span><?= $key ?></span>
                    <select class="attributes" data-key="<?= $key ?>">
                        <?php foreach ($attr as $k => $v) { ?>
                            <option value="<?= $v ?>"><?= $v ?></option>
                        <?php } ?>
                    </select>
                </div>
            <?php } ?>
        </td>

        <?php if ($type == 'sending') { ?>
            <td>
                <select name="products[<?= $rand32 ?>][place]" class="form-control">
                    <?php for ($i = 1; $i < 11; $i++) { ?>
                        <option value="<?= $i ?>"><?= $i ?></option>
                    <?php } ?>
                </select>
            </td>
        <?php } ?>

        <td style="width: 39px">
            <button class="btn btn-danger btn-xs drop_product" data-id="remove">
                <span class="glyphicon glyphicon-remove"></span>
            </button>
        </td>
    </tr>
<?php } ?>
