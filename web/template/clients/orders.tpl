<?php include parts('head'); ?>

<div class="right" style="margin-bottom: 15px">
    <button data-type="get_form"
            data-uri="<?= uri('clients') ?>"
            data-action="add_order_form"
            data-post="<?= params(['client_id' => get('id')]) ?>"
            class="btn btn-primary">
        <span class="glyphicon glyphicon-plus"></span>
        Прикріпити замовлення
    </button>
</div>

<table class="table table-bordered">
    <tr>
        <th>№ Замовлення</th>
        <th>ПІБ</th>
        <th>Телефон</th>
        <th>Сума</th>
        <th>Статус</th>
        <th>Дата</th>
        <th>Дія</th>
    </tr>
    <?php if (my_count($orders) > 0) {
        $statistic['sum'] = 0;
        foreach ($orders as $item) {
            $statistic['sum'] += $item['full_sum'];
            ?>
            <tr>
                <td>
                    <a href="<?= uri('orders', ['section' => 'update', 'id' => $item['id']]) ?>">
                        <?= $item['id']; ?>
                    </a>
                </td>
                <td><?= $item['fio']; ?></td>
                <td><?= $item['phone']; ?></td>
                <td><?= $item['full_sum']; ?> грн</td>
                <td>
                    <?= get_order_status($item['status'], $item['type']) ?>
                </td>
                <td><?= date_for_humans($item['date_delivery']) ?></td>
                <td class="action-2">
                    <a href="<?= uri('orders', ['section' => 'update', 'id' => $item['id']]); ?>" title="Детальніше"
                       class="btn btn-primary btn-xs">
                        <span class="glyphicon glyphicon-eye-open"></span>
                    </a>
                    <button class="btn btn-danger btn-xs remove" data-id="<?= $item['id'] ?>" title="Видалити">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </td>
            </tr>
        <?php } ?>
        <tr>
            <td colspan="8">
                Всього замовлень - <span class="text-primary"><?= count($orders); ?></span>, на суму
                <span class="text-primary"><?= $statistic['sum'] ?> грн.</span>
            </td>
        </tr>
    <?php } else { ?>
        <tr>
            <td class="centered" colspan="8"><h4>Тут пусто :(</h4></td>
        </tr>
    <?php } ?>
</table>

<input type="hidden" id="client_id" value="<?= $client_id ?>">

<?php include parts('foot'); ?>
