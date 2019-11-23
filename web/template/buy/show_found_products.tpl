<?php foreach ($products as $product) { ?>
    <tr data-id="<?= $product->id ?>" class="product" data-pto="0" data-hash="<?= rand32() ?>">

        <td class="product_name">
            <a target="_blank" href="<?= uri('product', ['section' => 'update', 'id' => $product->id]) ?>">
                <?= $product->name ?>
            </a>
        </td>

        <td>
            <?= $product->identefire_storage ?>
        </td>

        <td>
            <?= $product->storage_name ?>
            <input type="hidden" class="storage" value="<?= $product->storage_id ?>">
        </td>

        <td>
            <?= $product->articul ?>
        </td>

        <td class="price">
            <div class="input-group">
                <span class="input-group-addon remained">
                    <?php if ($product->combine) { ?>
                        n
                    <?php } else { ?>
                        <?= $product->accounted ? $product->count_on_storage : 'n' ?>
                    <?php } ?>
                </span>
                <input class="el_amount count form-control product_field" value="0" data-name="amount" data-inspect="integer">
                <input type="hidden" value="<?php if ($product->combine) {
                    echo 'n';
                } else {
                    echo $product->accounted ? $product->count_on_storage : 'n';
                } ?>"
                       class="count_on_storage">
                <input type="hidden" class="amount_in_order" value="0">
            </div>
        </td>

        <td class="price">
            <input class="el_price count form-control product_field" data-name="price" value="<?= $product->costs ?>" data-inspect="decimal">
        </td>

        <td class="price">
            <input disabled class="el_sum count form-control" value="0">
        </td>

        <td class="attributes">
            <?php if (my_count(json_decode($product->attributes, 1)) > 0) {
                foreach (json_decode($product->attributes, 1) as $key => $attr) { ?>
                    <div>
                        <span><?= $key ?></span>
                        <select class="attributes" data-key="<?= $key ?>">
                            <?php foreach ($attr as $k => $v) { ?>
                                <option value="<?= $v ?>"><?= $v ?></option>
                            <?php } ?>
                        </select>
                    </div>
                <?php }
            } ?>
        </td>

        <?php if ($type == 'sending') { ?>
            <td>
                <select class="place product_field" data-name="place">
                    <?php for ($i = 1; $i < 11; $i++) { ?>
                        <option value="<?= $i ?>"><?= $i ?></option>
                    <?php } ?>
                </select>
            </td>
        <?php } ?>

        <td>
            <button class="btn btn-danger btn-xs drop_product" data-id="remove">
                <span class="glyphicon glyphicon-remove"></span>
            </button>
        </td>

    </tr>
<?php } ?>
