<?php $toJs = ['type' => $type] ?>

<?php include parts('head') ?>

    <div class="content-section">

        <div>
            <div class="pull-right">
                <?php if ($type == 'sending') { ?>
                    <button class="btn btn-success" id="more_filters">Додаткові фільтра</button>
                    <button class="btn btn-success" id="export_xml">Експортувати XML</button>
                    <a href="<?= uri('orders/create', ['type' => $type]) ?>" class="btn btn-success">Нове замовлення</a>
                <?php } else if ($type == 'delivery') { ?>
                    <button class="btn btn-success" id="more_filters">Додаткові фільтра</button>
                    <button class="btn btn-success" id="route_list">Маршрутний лист</button>
                    <a href="<?= uri('orders/create', ['type' => $type]) ?>" class="btn btn-success">Нове замовлення</a>
                <?php } else { ?>
                    <button class="btn btn-success" id="more_filters">Додаткові фільтра</button>
                    <button class="btn btn-success" id="route_list">Маршрутний лист</button>
                    <a href="<?= uri('orders/create', ['type' => $type]) ?>" class="btn btn-success">Нове замовлення</a>
                <?php } ?>
            </div>

            <div class="pull-left">
                <div class="btn-group" style="margin: 0 0 15px">
                    <a href="<?= uri('orders/view', ['type' => 'delivery']) ?>" class="<?= $type == 'delivery' ? 'btn-primary' : '' ?> btn btn-default type-btn">
                        Доставки
                    </a>
                    <a href="<?= uri('orders/view', ['type' => 'self']) ?>" class="<?= $type == 'self' ? 'btn-primary' : '' ?> btn btn-default type-btn">
                        Самовивози
                    </a>
                    <a href="<?= uri('orders/view', ['type' => 'sending']) ?>" class="<?= $type == 'sending' ? 'btn-primary' : '' ?> btn btn-default type-btn">
                        Відправки
                    </a>
                </div>
            </div>
        </div>

        <div class="clearfix"></div>

        <?php
        $filter_array = ['site', 'atype', 'hint_id', 'pay_method', 'items'];
        $none = true;
        foreach ($filter_array as $k) if (get($k)) $none = false;
        ?>

        <div class="filter_more <?= !$none ?: 'none' ?>">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="items">Кількість пунктів на сторінку</label>
                        <input id="items" class="search form-control" value="<?= get('items') ?>">
                    </div>
                    <div class="form-group">
                        <label for="site">Сайт</label>
                        <select id="site" class="search form-control">
                            <option value=""></option>
                            <?php foreach (\Web\Model\Orders::getAll('sites') as $item) { ?>
                                <option <?= request()->selected('site', $item->id) ?> value="<?= $item->id ?>">
                                    <?= $item->name ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>
                    <?php if ($type != 'sending') { ?>
                        <div class="form-group">
                            <label>Тип замовлення</label>
                            <select id="order_professional_id" class="search form-control">
                                <option value=""></option>
                                <?php foreach (\Web\Eloquent\OrderProfessional::all() as $item) { ?>
                                    <option <?= $item->id != get('order_professional_id') ?: 'selected' ?>
                                            value="<?= $item->id ?>">
                                        <?= $item->name ?>
                                    </option>
                                <?php } ?>
                            </select>
                        </div>
                    <?php } ?>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label>Підказка</label>
                        <select id="hint_id" class="search form-control">
                            <option value=""></option>
                            <?php foreach (\Web\Eloquent\OrderHint::whereIn('type', [0, $type])->get() as $item) { ?>
                                <option <?= $item->id != get('hint_id') ?: 'selected' ?> value="<?= $item->id ?>">
                                    <?= $item->description ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>
                    <?php if ($type == 'delivery') { ?>
                        <div class="form-group">
                            <label>Спосіб оплати</label>
                            <select id="pay_id" class="search form-control">
                                <option value=""></option>
                                <?php foreach (\Web\Eloquent\Pay::all() as $item) { ?>
                                    <option <?= $item->id != get('pay_id') ?: 'selected' ?>
                                            value="<?= $item->id ?>">
                                        <?= $item->name ?>
                                    </option>
                                <?php } ?>
                            </select>
                        </div>
                    <?php } ?>
                </div>
            </div>
        </div>

        <div style="border: 1px solid #ccc; margin-bottom: 15px; padding: 10px">
            <span class="text-info">Сума всіх замовлень: </span><b><?= number_format($full, 0) ?></b>
        </div>

        <?php include t_file("buy.view.$type") ?>

        <?php $orders->links('parts.paginator') ?>

    </div>

<?php include parts('foot') ?>