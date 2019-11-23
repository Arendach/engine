<?php include parts('head') ?>

    <div class="content-section">
        <?php if ($type == 'sending') { ?>
            <button class="btn btn-success" id="more_filters" style="position: absolute;top: 116px;right: 322px;">
                Додаткові фільтра
            </button>
            <button class="btn btn-success" id="export_xml" style="position: absolute;top: 116px;right: 21px;">
                Експортувати XML
            </button>
            <a style="position: absolute;top: 116px;right: 172px;"
               href="<?= uri('orders', ['section' => 'create', 'type' => $type]) ?>" class="btn btn-success">
                Нове замовлення
            </a>
        <?php } else if ($type == 'delivery') { ?>
            <button class="btn btn-success" id="more_filters" style="position: absolute;top: 116px;right: 322px;">
                Додаткові фільтра
            </button>
            <button class="btn btn-success" id="route_list" style="position: absolute;top: 116px;right: 21px;">
                Маршрутний лист
            </button>
            <a style="position: absolute;top: 116px;right: 172px;"
               href="<?= uri('orders', ['section' => 'create', 'type' => $type]) ?>" class="btn btn-success">
                Нове замовлення
            </a>
        <?php } else if ($type == 'self') { ?>
            <button class="btn btn-success" id="more_filters" style="position: absolute;top: 116px;right:322px;">
                Додаткові фільтра
            </button>

            <button class="btn btn-success" id="route_list" style="position: absolute;top: 116px;right: 21px;">
                Маршрутний лист
            </button>
            <a style="position: absolute;top: 116px;right: 172px;"
               href="<?= uri('orders', ['section' => 'create', 'type' => $type]) ?>" class="btn btn-success">
                Нове замовлення
            </a>
        <?php } else { ?>
            <a style="position: absolute;top: 116px;right: 21px;"
               href="<?= uri('orders', ['section' => 'create', 'type' => $type]) ?>" class="btn btn-success">
                Нове замовлення
            </a>
        <?php } ?>
        <div class="btn-group" style="margin: 0 0 15px">
            <a href="<?= uri('orders', ['type' => 'delivery']) ?>"
               class="<?= $type == 'delivery' ? 'btn-primary' : '' ?> btn btn-default type-btn">
                Доставка
            </a>
            <a href="<?= uri('orders', ['type' => 'shop']) ?>"
               class="<?= $type == 'shop' ? 'btn-primary' : '' ?> btn btn-default type-btn">
                Магазин
            </a>
            <a href="<?= uri('orders', ['type' => 'self']) ?>"
               class="<?= $type == 'self' ? 'btn-primary' : '' ?> btn btn-default type-btn">
                Самовивіз
            </a>
            <a href="<?= uri('orders', ['type' => 'sending']) ?>"
               class="<?= $type == 'sending' ? 'btn-primary' : '' ?> btn btn-default type-btn">
                Відправка
            </a>
        </div>

        <?php
        $filter_array = ['site', 'atype', 'hint', 'pay_method', 'items'];
        $none = true;

        foreach ($filter_array as $k)
            if (get($k)) $none = false;
        ?>


        <?php if ($type != 'shop') { ?>
            <div class="filter_more <?= !$none ?: 'none' ?>">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="items">Кількість пунктів на сторінку</label>
                            <input id="items" class="search form-control" value="<?= get('items') ? get('items') : ITEMS ?>">
                        </div>
                        <div class="form-group">
                            <label for="site">Сайт</label>
                            <select id="site" class="search form-control">
                                <option value=""></option>
                                <?php foreach (\Web\Model\Orders::getAll('sites') as $item) { ?>
                                    <option <?= $item->id != get('site') ?: 'selected' ?> value="<?= $item->id ?>">
                                        <?= $item->name ?>
                                    </option>
                                <?php } ?>
                            </select>
                        </div>
                        <?php if ($type != 'sending') { ?>
                            <div class="form-group">
                                <label for="atype">Тип замовлення</label>
                                <select id="atype" class="search form-control">
                                    <option value=""></option>
                                    <?php foreach (\Web\Model\Orders::getAll('order_type') as $item) { ?>
                                        <option <?= $item->id != get('atype') ?: 'selected' ?> value="<?= $item->id ?>">
                                            <?= $item->name ?>
                                        </option>
                                    <?php } ?>
                                </select>
                            </div>
                        <?php } ?>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="hint">Підказка</label>
                            <select id="hint" class="search form-control">
                                <option value=""></option>
                                <?php foreach (\Web\Model\Orders::getHints($type) as $item) { ?>
                                    <option <?= $item->id != get('hint') ?: 'selected' ?> value="<?= $item->id ?>">
                                        <?= $item->description ?>
                                    </option>
                                <?php } ?>
                            </select>
                        </div>
                        <?php if ($type == 'delivery') { ?>
                            <div class="form-group">
                                <label for="pay_method">Спосіб оплати</label>
                                <select id="pay_method" class="search form-control">
                                    <option value=""></option>
                                    <?php foreach (\Web\Model\Orders::getAll('pays') as $item) { ?>
                                        <option <?= $item->id != get('pay_method') ?: 'selected' ?>
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
        <?php } ?>

        <div style="border: 1px solid #ccc; margin-bottom: 15px; padding: 10px">
            <span class="text-info">Сума всіх замовлень: </span><b><?= number_format($full, 2) ?></b>
        </div>

        <?php include t_file("buy.view.$type"); ?>

        <?php if ($paginate['count_pages'] > 0) { ?>
            <div class="centered">
                Показано з <?= $paginate['start'] + 1 ?> по <?= $paginate['start'] + my_count($data) ?>
                з <?= $paginate['all'] ?> (всього сторінок - <?= ceil($paginate['all'] / $paginate['items']) ?>)
                <br>
                <?php include parts('paginate') ?>
            </div>
        <?php } ?>
    </div>

<?php include parts('foot') ?>