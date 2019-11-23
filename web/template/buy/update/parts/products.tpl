<!-- Button -->

<div class="open-product-block">
    <div class="but">Додати товар</div>
</div>

<!-- Search products form -->

<div class="new_product_block form-group none">
    <div class="search_product">

        <div class="mini-block row" style="margin-bottom: 10px">

            <div style="padding: 10px 15px">
                <select class="form-control" name="storage" id="storage">
                    <?php foreach ($storage as $item) { ?>
                        <option value="<?= $item->id ?>"><?= $item->name ?></option>
                    <?php } ?>
                </select>
            </div>

            <div class="col-md-4">
                <input id="search_ser_code" placeholder="Сервісний код" class="form-control input-md">
            </div>

            <div class="col-md-4">
                <label for="categories_pr"></label>
                <select id="categories_pr" class="col-md-4 form-control">
                    <option value="0"></option>
                    <?= $categories ?>
                </select>
            </div>

            <div class="col-md-4">
                <input id="search_name_product" placeholder="Назва" class="form-control input-md">
            </div>

        </div>

        <div class="mini-block row">
            <div class="col-md-12">
                <div style="height: 200px" id="products" class="products select form-control"></div>
            </div>
        </div>

    </div>

    <button class="btn btn-primary" id="select_products">Вибрати</button>
</div>


<div class="products-order">
    <table id="list_products" class="table table-bordered">
        <tr>
            <td>Назва товару</td>
            <td>ID складу</td>
            <td>Склад</td>
            <td>Артикул</td>
            <td>Кількість</td>
            <td>Вартість</td>
            <td>Сума</td>
            <td>Атрибути</td>
            <?php if ($type == 'sending') { ?>
                <td>Номер місця</td>
            <?php } ?>
            <td style="width: 36px;">Дії</td>
        </tr>
        <?php if (isset($products) && my_count($products) > 0) {
            foreach ($products as $p) {
                $p = (object)$p; ?>
                <tr data-id="<?= $p->id; ?>" class="product" data-pto="<?= $p->pto ?>">

                    <td class="product_name">
                        <a target="_blank" href="<?= uri('product', ['section' => 'update', 'id' => $p->id]) ?>">
                            <?= $p->name ?>
                        </a>
                    </td>

                    <td><?= $p->identefire_storage ?></td>

                    <td>
                        <?= $p->storage_name ?>
                        <input type="hidden" class="storage" value="<?= $p->storage_id ?>">
                    </td>

                    <td><?= $p->articul ?></td>

                    <td class="price">
                        <div class="input-group">
                            <span class="input-group-addon remained">
                                <?= !$p->accounted || $p->combine ? 'n' : $p->count_on_storage ?>
                            </span>
                            <input data-name="amount" class="form-control el_amount count product_field"
                                   value="<?= $p->amount; ?>" data-inspect="integer">
                            <input type="hidden" class="count_on_storage"
                                   value="<?= !$p->accounted || $p->combine ? 'n' : $p->count_on_storage ?>">
                            <input type="hidden" class="amount_in_order" value="<?= $p->amount; ?>">
                        </div>
                    </td>

                    <td class="price">
                        <input data-name="price" class="form-control el_price count product_field"
                               value="<?= $p->price; ?>" data-inspect="decimal">
                    </td>

                    <td class="price">
                        <input disabled class="form-control el_sum" value="<?= $p->price * $p->amount; ?>">
                    </td>

                    <td class="attributes">
                        <div class="attr-edit">
                            <?php
                            $attributes = json_decode($p->attr);
                            $attr = in_array($p->attributes, ['null', '[]', '']) ? [] : with_json($p->attributes);

                            foreach ($attr as $key => $attr) { ?>
                                <label><?php echo $key; ?></label>
                                <select class="attr" data-key="<?php echo $key; ?>">
                                    <?php foreach ($attr as $val) { ?>
                                        <option <?= isset($attributes->$key) && $val == $attributes->$key ? 'selected' : ''; ?>
                                                value="<?= $val; ?>"><?= $val; ?></option>
                                    <?php } ?>
                                </select><br>
                            <?php } ?>
                        </div>
                    </td>

                    <?php if ($type == 'sending') { ?>
                        <td>
                            <select data-name="place" class="product_field">
                                <?php for ($i = 1; $i < 11; $i++) { ?>
                                    <option <?= $p->place == $i ? 'selected' : '' ?>
                                            value="<?= $i ?>"><?= $i ?></option>
                                <?php } ?>
                            </select>
                        </td>
                    <?php } ?>

                    <td>
                        <button type="button" class="btn btn-danger btn-xs drop_product delete"
                                data-id="<?= $p->id; ?>">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                    </td>
                </tr>

            <?php } ?>
        <?php } ?>
    </table>
</div>

<div class="form-horizontal" style="margin-top: 15px;">

    <div class="form-group">
        <label for="delivery_cost" class="col-md-4 control-label">Ціна за доставку</label>
        <div class="col-md-5">
            <input <?= $pay->is_cashless ? 'disabled' : '' ?> id="delivery_cost" class="form-control count" value="<?= $order->delivery_cost ?>" data-inspect="decimal">
        </div>
    </div>

    <div class=" form-group">
        <label for="discount" class="col-md-4 control-label">Знижка</label>
        <div class="col-md-5">
            <input <?= $pay->is_cashless ? 'disabled' : '' ?> id="discount" class="form-control count" value="<?= $order->discount ?>" data-inspect="decimal">
        </div>
    </div>

    <div class="form-group">
        <label for="sum" class="col-md-4 control-label">Ціна за товари</label>
        <div class="col-md-5">
            <input disabled id="sum" class="form-control"
                   value="<?= $order->full_sum - $order->delivery_cost + $order->discount ?>">
        </div>
    </div>

    <div class="form-group">
        <label for="full_sum" class="col-md-4 control-label">Сума</label>
        <div class="col-md-5">
            <input disabled id="full_sum" class="form-control"
                   value="<?= $order->full_sum ?>">
        </div>
    </div>

    <div class="form-group">
        <div class="col-md-offset-4 col-md-5">
            <button class="btn btn-primary" id="save_price">Зберегти зміни</button>
        </div>
    </div>

</div>