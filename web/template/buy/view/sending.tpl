<table class="table table-bordered orders-table">
    <tr>
        <th class="action-2">№</th>
        <th>ПІБ</th>
        <th>Номер</th>
        <th>ТТН</th>
        <th>Доставка</th>
        <th>Кур`єр</th>
        <th>Сума</th>
        <th>Статус</th>
        <th>Статус відправки</th>
        <th>Дата</th>
        <th class="action-2">Дія</th>
    </tr>

    <tr class="tr_search">
        <td><input class="search" id="id" value="<?= request('id') ?>"></td>

        <td><input class="search" id="fio" value="<?= request('fio') ?>"></td>

        <td><input class="search" id="phone" value="<?= request('phone') ?>"></td>

        <td><input class="search" id="street" value="<?= request('street') ?>"></td>

        <td></td>

        <td>
            <select class="search" id="courier_id">
                <option value=""></option>
                <option <?= request()->selected('courier_id', 0) ?> value="0">Не вибраний</option>
                <?php foreach ($couriers as $courier) { ?>
                    <option <?= request()->selected('courier_id', $courier->id) ?> value="<?= $courier->id ?>">
                        <?= $courier->name ?>
                    </option>
                <?php } ?>
            </select>
        </td>

        <td><input class="search" id="full_sum" value="<?= request('full_sum') ?>"></td>

        <td>
            <select id="status" class="search">
                <option value=""></option>
                <?php foreach (\Web\Model\OrderSettings::statuses($type) as $k => $status) { ?>
                    <option <?= request()->selected('status', (int)$k) ?> value="<?= $k ?>">
                        <?= $status->text ?>
                    </option>
                <?php } ?>
                <option disabled value="">-------------</option>
                <option <?= request()->selected('status', 'open') ?> value="open">Відкриті</option>
                <option <?= request()->selected('status', 'close') ?> value="close">Закриті</option>
            </select>
        </td>

        <td>
            <select id="phone2" class="search">
                <option value=""></option>
                <?php foreach (\Web\Model\OrderSettings::sending_statuses() as $key => $item) { ?>
                    <option <?= request()->selected('phone2', $key) ?> value="<?= $key ?>">
                        <?= $item['text'] ?>
                    </option>
                <?php } ?>
            </select>
        </td>

        <td><input type="date" class="search" id="date" value="<?= request('date') ?>"></td>

        <td class="centered">
            <button class="btn btn-primary btn-xs" id="search"><span class="fa fa-search"></span></button>
        </td>
    </tr>

    <?php if ($orders->count()) {
        foreach ($orders as $item) { ?>
            <tr id="<?= $item->id; ?>" <?= $item->client_id != '' ? 'class="client-order"' : '' ?>>
                <td>
                    <?php if ($item->delivery == 'НоваПошта') { ?>
                        <input type="checkbox" data-id="<?= $item->id; ?>" class="order_check">
                    <?php } ?>
                    <?= $item->id ?>
                </td>

                <td><?= $item->fio ?></td>

                <td><?= $item->phone ?></td>

                <td><?= $item->street ?></td>

                <td><?= $item->delivery ?></td>

                <td>
                    <select class="courier">
                        <option <?= $item->status ?: 'disabled' ?> <?= $item->courier ?: 'selected' ?> value="0">
                            Не вибрано
                        </option>
                        <?php foreach ($couriers as $courier) { ?>
                            <option <?= $courier->id != $item->courier_id ?: 'selected' ?> value="<?= $courier->id ?>">
                                <?= $courier->name ?>
                            </option>
                        <?php } ?>
                    </select>
                </td>

                <td><?= round($item->full_sum) ?></td>

                <td><?= get_order_status($item->status, $type); ?></td>

                <td>
                    <?php $sending_status = \Web\Model\OrderSettings::sending_statuses($item->phone2) ?>
                    <span style="color: <?= $sending_status['color'] ?>;">
                        <?= $sending_status['text'] ?>
                    </span>
                </td>

                <td><?= $item->date_delivery ?></td>

                <td class="action-2 relative">
                    <div id="preview_<?= $item->id ?>" class="preview_container"></div>
                    <div class="buttons-2">
                        <button class="btn btn-primary btn-xs preview">
                            <span class="glyphicon glyphicon-eye-open"></span>
                        </button>
                        <a class="btn btn-primary btn-xs" href="<?= uri('orders/update', ['id' => $item->id]) ?>" title="Редагувати">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </a>
                    </div>
                    <div class="buttons-2">
                        <a class="btn btn-primary btn-xs" href="<?= uri('orders/changes', ['id' => $item->id]) ?>" title="Історія змін">
                            <span class="glyphicon glyphicon-time"></span>
                        </a>
                        <a target="_blank" href="<?= uri('orders/receipt', ['id' => $item->id]) ?>" data-id="#print_<?= $item->id ?>" class="btn btn-primary btn-xs print_button" title="Друкувати">
                            <span class="glyphicon glyphicon-print"></span>
                        </a>
                    </div>
                    <?php if (!is_null($item->hint)) { ?>
                        <div class="centered">
                            <button class="btn btn-xs" data-toggle="tooltip"
                                    style="background-color: #<?= $item->hint->color ?>"
                                    title="<?= $item->hint->description ?>">
                                <span class="glyphicon glyphicon-comment"></span>
                            </button>
                        </div>
                    <?php } ?>
                </td>
            </tr>
        <?php } ?>
    <?php } else { ?>
        <tr>
            <td class="centered" colspan="11"><h4>Тут пусто :(</h4></td>
        </tr>
    <?php } ?>
</table>