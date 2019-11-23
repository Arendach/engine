<div class="right" style="margin-bottom: 15px;">
    <?php if ($add_transaction) { ?>
        <button class="btn btn-primary"
                data-type="get_form"
                data-uri="<?= uri('orders') ?>"
                data-post="<?= params(['id' => $order->id]) ?>"
                data-action="search_transaction">
            Привязати транзакцію
        </button>
    <?php } else { ?>
        <button class="btn btn-danger">Виберіть спосіб оплати з мерчантом</button>
    <?php } ?>
</div>


<form action="<?= uri('orders') ?>" data-type="ajax" data-pin_code="" class="form-horizontal">
    <input type="hidden" name="id" value="<?= $order->id ?>">
    <input type="hidden" name="action" value="update_pay">
    <input type="hidden" name="type" value="<?= $order->type ?>">
    <input type="hidden" name="pay_delivery" value="<?= $order->pay_delivery ?>">

    <?php element('pay_method', ['pay_method' => $order->pay_method]) ?>

    <?php element('prepayment', ['prepayment' => $order->prepayment]) ?>

    <?php element('button') ?>
</form>


<?php if (isset($transactions) && my_count($transactions) > 0) { ?>

    <table class="table table-bordered">
        <tr>
            <td>Id</td>
            <td>Сума</td>
            <td>Дата</td>
            <td>Карта</td>
            <td>Опис</td>
            <td class="action-1">Дії</td>
        </tr>
        <?php foreach ($transactions as $transaction) { ?>
            <tr>
                <td><?= $transaction->transaction_id ?></td>
                <td><?= $transaction->sum ?></td>
                <td><?= $transaction->date ?></td>
                <td><?= $transaction->card ?></td>
                <td><?= $transaction->description ?></td>
                <td class="action-1">
                    <button data-type="delete"
                            data-id="<?= $transaction->id ?>"
                            data-action="delete_transaction"
                            data-uri="<?= uri('orders') ?>"
                            class="btn btn-danger btn-xs">
                        <i class="fa fa-remove"></i>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>

<?php } ?>