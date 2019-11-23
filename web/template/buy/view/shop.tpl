<?php
$s = isset($_GET['status']) ? true : false;
?>

<table class="table table-bordered orders-table">
    <tr>
        <th class="action-2">№</th>
        <th>За товари (Повна сума)</th>
        <th>Статус</th>
        <th>Спосіб оплати</th>
        <th>Дата</th>
        <th class="action-2">Дія</th>
    </tr>
    <tr class="tr_search">

        <td>
            <input class="search" id="id" value="<?= get('id'); ?>">
        </td>

        <td>
            <input class="search" id="full_sum" value="<?= get('full_sum') ?>">
        </td>

        <td>
            <select id="status" class="search">
                <option value=""></option>
                <?php foreach (\Web\Model\OrderSettings::statuses($type) as $k => $status) {
                    if ($s === true) $selected = get('status') == $k ? 'selected' : ''; else $selected = ''; ?>
                    <option <?= $selected ?> value="<?= $k ?>"><?= $status->text ?></option>
                <?php } ?>
                <option disabled value="">-------------</option>
                <option <?= get('status') === 'open' ? 'selected' : '' ?> value="open">Відкриті</option>
                <option <?= get('status') === 'close' ? 'selected' : '' ?> value="close">Закриті</option>
            </select>
        </td>

        <td>
            <select class="search" id="pay_method">
                <option value=""></option>
                <?php foreach (\Web\App\Model::getAll('pays') as $item) { ?>
                    <option <?= get('pay_method') == $item->id ? 'selected' : '' ?> value="<?= $item->id ?>">
                        <?= $item->name ?>
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
            <tr id="<?= $item->id; ?>">

                <td>
                    <?= $item->id; ?>
                </td>

                <td>
                    <?= number_format($item->full_sum, 2) ?>
                </td>

                <td>
                    <?= get_order_status($item->status, $type); ?>
                </td>

                <td>
                    <?= $item->pay_method ?>
                </td>

                <td>
                    <?= my_df($item->date_delivery, 'd-m-Y'); ?>
                </td>

                <td class="action-2 relative">
                    <div id="preview_<?= $item->id ?>" class="preview_container"></div>
                    <div class="buttons-2">
                        <button class="btn btn-primary btn-xs preview">
                            <span class="glyphicon glyphicon-eye-open"></span>
                        </button>
                        <a class="btn btn-primary btn-xs" href="<?= uri('orders', ['section' => 'update', 'id' => $item->id]); ?>"
                           title="Редагувати">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </a>
                    </div>
                    <div class="buttons-2">
                        <a class="btn btn-primary btn-xs" href="<?= uri('orders', ['section' => 'changes', 'id' => $item->id]); ?>"

                           title="Історія змін">
                            <span class="glyphicon glyphicon-time"></span>
                        </a>
                        <a target="_blank" href="<?= uri('orders', ['section' => 'receipt', 'id' => $item->id]) ?>"
                           class="btn btn-primary btn-xs print_button" title="Друкувати">
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
            <td class="centered" colspan="6"><h4>Тут пусто :(</h4></td>
        </tr>
    <?php } ?>
</table>