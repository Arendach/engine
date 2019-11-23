<?php $css = ['purchases.css']; ?>

<?php include parts('head'); ?>

    <div class="relative">
        <div class="btn-group">
            <a href="<?= uri('purchases') ?>" class="btn btn-<?= get('view') == false ? 'primary' : 'default' ?>">Відкриті</a>
            <a href="<?= uri('purchases', ['view' => 'all']) ?>"
               class="btn btn-<?= get('view') == 'all' ? 'primary' : 'default' ?>">Всі</a>
            <a href="<?= uri('purchases', ['view' => 'close']) ?>"
               class="btn btn-<?= get('view') == 'close' ? 'primary' : 'default' ?>">Закриті</a>
        </div>
        <a href="<?= uri('purchases', ['section' => 'create']) ?>" class="btn btn-primary create" title="Створити нове замовлення">
            Нова закупка
        </a>
    </div>

    <h4>Сума <span class="label label-default"><?= $sum ?>$</span></h4>

    <table class="table table-bordered">
        <tr>
            <th>Дата</th>
            <th>Виробник</th>
            <th>Склад</th>
            <th>Сума</th>
            <th>Оплата</th>
            <th>Тип предзамовлення</th>
            <th class="action-2 centered">Дії</th>
        </tr>

        <tr>
            <td style="width: 290px">
                <input type="date" class="filter"
                    <?= get('date_with') ? 'value="' . get('date_with') . '"' : '' ?> data-column="date_with">
                <input type="date" class="filter"
                    <?= get('date_to') ? 'value="' . get('date_to') . '"' : '' ?> data-column="date_to">
            </td>

            <td>
                <select style="width: 100%" class="filter" data-column="manufacturer">
                    <option value=""></option>
                    <?php foreach ($manufacturers as $manufacturer) { ?>
                        <option <?= $manufacturer->id == get('manufacturer') ? 'selected' : '' ?>
                                value="<?= $manufacturer->id ?>"><?= $manufacturer->name ?></option>
                    <?php } ?>
                </select>
            </td>

            <td>
                <select style="width: 100%" class="filter" data-column="storage_id">
                    <option value=""></option>
                    <?php foreach ($storage as $item) { ?>
                        <option <?= $item->id == get('storage_id') ? 'selected' : '' ?>
                                value="<?= $item->id ?>"><?= $item->name ?></option>
                    <?php } ?>
                </select>
            </td>

            <td></td>

            <td>
                <select style="width: 100%" class="filter" data-column="status">
                    <option value=""></option>
                    <option <?= isset($_GET['status']) && $_GET['status'] == '0' ? 'selected' : '' ?> value="0">
                        Не оплачено
                    </option>

                    <option <?= isset($_GET['status']) && $_GET['status'] == '1' ? 'selected' : '' ?> value="1">
                        Оплачено частково
                    </option>

                    <option <?= isset($_GET['status']) && $_GET['status'] == '2' ? 'selected' : '' ?> value="2">
                        Оплачено
                    </option>
                </select>
            </td>

            <td>
                <select style="width: 100%" class="filter" data-column="type">
                    <option value=""></option>
                    <option <?= isset($_GET['type']) && $_GET['type'] == '0' ? 'selected' : '' ?> value="0">
                        Потрібно закупити
                    </option>

                    <option <?= isset($_GET['type']) && $_GET['type'] == '1' ? 'selected' : '' ?> value="1">
                        Прийнято на облік
                    </option>
                </select>
            </td>

            <td>
                <button class="btn btn-primary btn-xs" id="filter">
                    <span class="glyphicon glyphicon-search"></span>
                </button>
            </td>
        </tr>

        <?php foreach ($items as $item) { ?>
            <tr>
                <td><?= date_for_humans($item->date) ?></td>
                <td><?= $item->manufacturer_name ?></td>
                <td><?= $item->storage_name ?></td>
                <td><?= number_format($item->sum, 2) ?></td>
                <td>
                    <?php if ($item->status == 0)
                        echo 'Не оплачено';
                    elseif ($item->status == 1)
                        echo 'Сплачено частково';
                    else
                        echo 'Сплачено'; ?>
                </td>
                <td><?= $item->type == 0 ? 'Потрібно закупити' : 'Прийнято на облік' ?></td>
                <td class="action-2 centered">
                    <?php if ($item->close) { ?>
                        <button class="btn btn-danger btn-xs">
                            <span class="glyphicon glyphicon-lock"></span>
                        </button>
                    <?php } else { ?>
                        <a href="<?= uri('purchases', ['section' => 'update', 'id' => $item->id]) ?>" class="btn btn-primary btn-xs">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </a>
                    <?php } ?>

                    <a href="<?= uri('purchases', ['section' => 'print', 'id' => $item->id]) ?>" class="btn btn-primary btn-xs">
                        <span class="glyphicon glyphicon-print"></span>
                    </a>
                </td>
            </tr>
        <?php } ?>
    </table>
    <div class="centered">
        <?php Web\App\NewPaginate::display() ?>
    </div>
<?php include parts('foot'); ?>