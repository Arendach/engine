<?php

use Web\Model\OrderSettings as Settings;

$users = Settings::findAll('users', 'archive = 0');
$s = isset($_GET['status']) ? true : false;

?>

<table class="table table-bordered orders-table table-responsive">
    <tr>
        <th class="action-2">№</th>
        <th>ПІБ</th>
        <th>Номер</th>
        <th style="width: 88px;">Час доставки</th>
        <th>Регіон</th>
        <th>Кур`єр</th>
        <th>Сума</th>
        <th>Статус</th>
        <th>Дата</th>
        <th class="action-2">Дія</th>
    </tr>

    <tr class="tr_search">
        <td>
            <input autocomplete="false" class="search" id="id" value="<?= get('id') ? get('id') : ''; ?>">
        </td>

        <td>
            <input class="search" id="fio" value="<?= get('fio'); ?>">
        </td>

        <td>
            <input class="search" id="phone" value="<?= get('phone'); ?>">
        </td>

        <td style="width: 88px;">
            <input class="search filter_time_input" id="time_with" placeholder="Від"
                <?= get('time_with') ? 'value="' . string_to_time(get('time_with')) . '"' : '' ?>>
            <input class="search filter_time_input" id="time_to" placeholder="До"
                <?= get('time_with') ? 'value="' . string_to_time(get('time_with')) . '"' : '' ?>>
        </td>

        <td>
            <select id="region" class="search">
                <option value=""></option>
                <?php foreach (Settings::regions() as $region) { ?>
                    <option <?= $region != get('region') ?: 'selected' ?> value="<?= $region ?>">
                        <?= $region ?>
                    </option>
                <?php } ?>
            </select>
        </td>
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
            <input type="date" class="search" id="date" value="<?= get('date'); ?>">
        </td>

        <td class="centered">
            <button class="btn btn-primary btn-xs" id="search">
                <span class="fa fa-search"></span>
            </button>
        </td>

    </tr>

    <?php if (my_count($data) > 0) { ?>
        <?php foreach ($data as $item) { ?>
            <tr id="<?= $item->id; ?>" class="order-row<?= $item->client_id != '' ? ' client-order' : '' ?>">

                <td>
                    <?= $item->id; ?>
                    <?php if ($item->atype != 0) { ?>
                        <button type="button"
                                class="btn btn-xs btn-primary"
                                style="background: #<?= $item->order_type_color ?>; height: 20px; width: 20px;"
                                data-toggle="popover"
                                data-placement="top"
                                data-trigger="hover"
                                title="<?= $item->order_type_login ?>"
                                data-html="true"
                                data-content="<?= $item->order_type_name ?>">
                            <i class="fa fa-info"></i>
                        </button>
                    <?php } ?>
                </td>

                <td>
                    <?= $item->fio; ?>
                </td>

                <td>
                    <?= $item->phone; ?>
                </td>

                <td style="width: 88px;">
                    <?php if (string_to_time($item->time_with) != '00:00' && string_to_time($item->time_to) != '00:00')
                        echo string_to_time($item->time_with) . ' - ' . string_to_time($item->time_to);
                    else
                        echo '<span style="color: blue">Цілодобово</span>';
                    ?>
                </td>

                <td>
                    <?= $item->street . ' ' . $item->address ?>
                </td>

                <td>
                    <select class="courier">
                        <option <?= $item->status != 0 ? 'disabled' : '' ?> <?= $item->courier == '0' ? 'selected' : '' ?>
                                value="0">
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
                           class="btn btn-primary btn-xs print_button" title="Друкувати">
                            <span class="glyphicon glyphicon-print"></span>
                        </a>
                    </div>
                    <div class="centered buttons-2">
                        <?php if (!empty($item->color)) { ?>
                            <button class="btn btn-xs" data-toggle="tooltip"
                                    style="background-color: #<?= $item->color; ?>;" title="<?= $item->description; ?>">
                                <span class="glyphicon glyphicon-comment"></span>
                            </button>
                        <?php } ?>

                        <?php if (my_count($item->bonuses) > 0) { ?>
                            <button class="btn btn-xs btn-success"
                                    style="background: red"
                                    data-toggle="tooltip"
                                    title="<?php foreach ($item->bonuses as $bonus){ echo user($bonus->user_id)->login ."\n"; } ?>">
                                <span class="fa fa-dollar"></span>
                            </button>
                        <?php } ?>
                    </div>
                </td>
            </tr>
        <?php } ?>
    <?php } else { ?>
        <tr>
            <td class="centered" colspan="10"><h4>Тут пусто :(</h4></td>
        </tr>
    <?php } ?>
</table>

