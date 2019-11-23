<?php

use Web\Model\OrderSettings as Settings;

$users = Settings::findAll('users', 'archive = 0');
$s = isset($_GET['status']) ? true : false;

?>
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
        <td>
            <input class="search" id="id" value="<?= get('id'); ?>">
        </td>

        <td>
            <input class="search" id="fio" value="<?= get('fio'); ?>">
        </td>


        <td>
            <input class="search" id="phone" value="<?= get('phone'); ?>">
        </td>

        <td>
            <input value="<?= get('street') ?>" class="search" id="street">
        </td>

        <td></td>

        <td>
            <select class="search" id="courier">
                <option value=""></option>
                <option <?= isset($_GET['courier']) && $_GET['courier'] == '0' ? 'selected' : '' ?> value="0">
                    Не вибрано
                </option>
                <?php foreach ($users as $user) { ?>
                    <option <?= $user->id != get('courier') ?: 'selected' ?> value="<?= $user->id ?>">
                        <?php echo $user->name ?>
                    </option>
                <?php } ?>
            </select>
        </td>

        <td>
            <input class="search" id="full_sum" value="<?= get('full_sum') ?>">
        </td>

        <td>
            <select id="status" class="search">
                <option value=""></option>
                <?php foreach (\Web\Model\OrderSettings::statuses($type) as $k => $status) {
                    if ($s === true)
                        $selected = get('status') == $k ? 'selected' : '';
                    else
                        $selected = ''; ?>
                    <option <?= $selected ?> value="<?= $k ?>">
                        <?= $status->text ?>
                    </option>
                <?php } ?>
                <option disabled value="">-------------</option>
                <option <?= get('status') === 'open' ? 'selected' : '' ?> value="open">Відкриті</option>
                <option <?= get('status') === 'close' ? 'selected' : '' ?> value="close">Закриті</option>
            </select>
        </td>

        <td>
            <select id="phone2" class="search">
                <option value=""></option>
                <?php foreach (\Web\Model\OrderSettings::sending_statuses() as $key => $item) { ?>
                    <option <?= get('phone2') == $key ? 'selected' : '' ?> value="<?= $key ?>">
                        <?= $item['text'] ?>
                    </option>
                <?php } ?>
            </select>
        </td>

        <td>
            <input type="date" class="search" id="date" value="<?= get('date'); ?>">
        </td>

        <td class="centered">
            <button class="btn btn-primary btn-xs" id="search"><span class="fa fa-search"></span></button>
        </td>

    </tr>

    <?php if (my_count($data) > 0) {
        foreach ($data as $item) { ?>
            <tr id="<?= $item->id; ?>" <?= $item->client_id != '' ? 'class="client-order"' : '' ?>>
                <td>
                    <?php if ($item->delivery == 'НоваПошта') { ?>
                        <input type="checkbox" data-id="<?= $item->id; ?>" class="order_check">
                    <?php } ?>
                    <?= $item->id; ?>
                </td>

                <td>
                    <?= $item->fio; ?>
                </td>

                <td>
                    <?= $item->phone; ?>
                </td>

                <td>
                    <?= $item->street; ?>
                </td>

                <td>
                    <?= $item->delivery; ?>
                </td>

                <td>
                    <select class="courier">
                        <option <?= $item->status != 0 ? 'disabled' : '' ?> <?= $item->courier == '0' ? 'selected' : '' ?> value="0">
                            Не вибрано
                        </option>
                        <?php foreach ($users as $user) { ?>
                            <option <?= $user->id == $item->courier ? 'selected' : '' ?> value="<?= $user->id ?>">
                                <?= $user->name ?>
                            </option>
                        <?php } ?>
                    </select>
                </td>

                <td>
                    <?= number_format($item->full_sum, 2) ?>
                </td>

                <td>
                    <?= get_order_status($item->status, $type); ?>
                </td>

                <td>
                    <?php $sending_status = \Web\Model\OrderSettings::sending_statuses($item->phone2) ?>
                    <span style="color: <?= $sending_status['color'] ?>;">
                        <?= $sending_status['text'] ?>
                    </span>
                </td>

                <td>
                    <?= my_df($item->date_delivery, 'd.m.Y'); ?>
                </td>

                <td class="action-2 relative">
                    <div id="preview_<?= $item->id ?>" class="preview_container"></div>
                    <div class="buttons-2">
                        <button class="btn btn-primary btn-xs preview">
                            <span class="glyphicon glyphicon-eye-open"></span>
                        </button>
                        <a class="btn btn-primary btn-xs"
                           href="<?= uri('orders', ['section' => 'update', 'id' => $item->id]); ?>"
                           title="Редагувати">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </a>
                    </div>
                    <div class="buttons-2">
                        <a class="btn btn-primary btn-xs"
                           href="<?= uri('orders', ['section' => 'changes', 'id' => $item->id]); ?>"

                           title="Історія змін">
                            <span class="glyphicon glyphicon-time"></span>
                        </a>
                        <a target="_blank" href="<?= uri('orders', ['section' => 'receipt', 'id' => $item->id]) ?>"
                           data-id="#print_<?= $item->id ?>" class="btn btn-primary btn-xs print_button"
                           title="Друкувати">
                            <span class="glyphicon glyphicon-print"></span>
                        </a>
                    </div>
                    <?php if (!empty($item->color)) { ?>
                        <div class="centered">
                            <button class="btn btn-xs" data-toggle="tooltip"
                                    style="background-color: #<?= $item->color; ?>;" title="<?= $item->description; ?>">
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