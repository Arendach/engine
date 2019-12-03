<div class="order_search_products">
    <div class="row">
        <div class="col-md-8">
            <input id="search_field" data-search="field" placeholder="Почніть вводити" class="form-control input-md">
        </div>
        <div class="col-md-4">
            <select id="search_category" data-search="category" class="col-md-4 form-control">
                <option value="0">Пошук по категорії</option>
                <?= $categories ?>
            </select>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div style="height: 200px" class="products select"></div>
        </div>
    </div>
</div>

<form data-type="ajax" action="<?= uri('orders/update_products') ?>" class="order_search_products">
    <input type="hidden" name="id" value="<?= $order->id ?>">

    <table id="product-list" class="table table-bordered">
        <tr>
            <th>Товар</th>
            <th>Склад</th>
            <th>Кількість</th>
            <th>Вартість</th>
            <th style="width: 71px">Сума</th>
            <th>Атрибути</th>
            <?php if ($type == 'sending') { ?>
                <th>Місце</th>
            <?php } ?>
            <th style="width: 39px;">Дії</th>
        </tr>
        <?php if ($order->products->count()) { ?>
            <?php foreach ($order->products as $product) { ?>
                <?php $rand = rand32() ?>
                <tr class="product">
                    <td class="product_name">
                        <a target="_blank" href="<?= uri('product/update', ['id' => $product->id]) ?>">
                            <?= $product->name ?>
                        </a>

                        <input type="hidden" name="products[<?= $rand ?>][id]" value="<?= $product->id ?>">
                        <input type="hidden" name="products[<?= $rand ?>][pto]" value="<?= $product->pivot->id ?>">
                    </td>

                    <td>
                        <select name="products[<?= $rand ?>][storage_id]" class="form-control">
                            <?php foreach ($product->storage_list as $storage) { ?>
                                <option <?= $storage->storage_id == $product->pivot->storage_id ? 'selected' : '' ?>
                                        value="<?= $storage->storage_id ?>">
                                    <?= $storage->count ?>: <?= $storage->storage->name ?>
                                </option>
                            <?php } ?>
                        </select>
                    </td>

                    <td>
                        <div class="input-group">
                            <input name="products[<?= $rand ?>][amount]"
                                   class="form-control amount"
                                   value="<?= $product->pivot->amount; ?>"
                                   data-inspect="integer">
                        </div>
                    </td>

                    <td>
                        <input class="form-control price"
                               name="products[<?= $rand ?>][price]"
                               value="<?= $product->pivot->price; ?>" data-inspect="decimal">
                    </td>

                    <td>
                        <input disabled class="form-control sum"
                               value="<?= $product->pivot->price * $product->pivot->amount; ?>">
                    </td>

                    <td class="attributes">
                        <div class="attr-edit">
                            <?php foreach ($product->attributes as $key => $attr) {
                                $rand = rand32(); ?>
                                <label><?= $key ?></label><br>
                                <input type="hidden"
                                       name="products[<?= $product->id ?>][attributes][<?= $rand ?>][key]"
                                       value="<?= $key ?>">
                                <select name="products[<?= $product->id ?>][attributes][<?= $rand ?>][value]"
                                        class="attr" data-key="<?= $key ?>">
                                    <?php foreach ($attr as $val) { ?>
                                        <option <?= isset($product->pivot->attributes[$key]) && $val == $product->pivot->attributes[$key] ? 'selected' : '' ?>
                                                value="<?= $val ?>">
                                            <?= $val ?>
                                        </option>
                                    <?php } ?>
                                </select><br>
                            <?php } ?>
                        </div>
                    </td>

                    <?php if ($type == 'sending') { ?>
                        <td>
                            <select data-name="place" class="form-control">
                                <?php for ($i = 1; $i < 11; $i++) { ?>
                                    <option <?= $product->pivot->place == $i ? 'selected' : '' ?>
                                            value="<?= $i ?>">
                                        <?= $i ?>
                                    </option>
                                <?php } ?>
                            </select>
                        </td>
                    <?php } ?>

                    <td>
                        <button type="button" class="btn btn-danger btn-xs drop_product delete"
                                data-order-id="<?= $order->id ?>"
                                data-pto="<?= $product->id; ?>">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                    </td>
                </tr>

            <?php } ?>
        <?php } ?>
    </table>

    <div class="form-horizontal" style="margin-top: 15px;">
        <div class="form-group">
            <label class="col-md-4 control-label">Вартість доставки</label>
            <div class="col-md-5">
                <input id="delivery_cost"
                       name="data[delivery_cost]"
                       class="form-control" value="<?= $order->delivery_cost ?>"
                       data-inspect="decimal">
            </div>
        </div>

        <div class=" form-group">
            <label for="discount" class="col-md-4 control-label">Знижка</label>
            <div class="col-md-5">
                <input id="discount"
                       name="data[discount]"
                       class="form-control"
                       value="<?= $order->discount ?>"
                       data-inspect="decimal">
            </div>
        </div>

        <div class="form-group">
            <label for="sum" class="col-md-4 control-label">Вартість товарів</label>
            <div class="col-md-5">
                <input disabled id="sum" class="form-control"
                       value="<?= $order->full_sum - $order->delivery_cost + $order->discount ?>">
            </div>
        </div>

        <div class="form-group">
            <label for="full_sum" class="col-md-4 control-label">Сума</label>
            <div class="col-md-5">
                <input disabled id="full_sum" class="form-control" value="<?= $order->full_sum ?>">
            </div>
        </div>

        <div class="form-group">
            <div class="col-md-offset-4 col-md-5">
                <button class="btn btn-primary">Зберегти</button>
            </div>
        </div>
    </div>
</form>