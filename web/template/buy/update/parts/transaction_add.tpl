<?php include parts('modal_head') ?>

    <form action="<?= uri('orders') ?>" data-type="ajax">
        <input type="hidden" name="action" value="add_transaction">

        <div class="form-group">
            <label>Виберіть транзакції</label>
            <div class="select" data-name="transactions" style="height: 350px">
                <?php foreach ($transactions as $item) { ?>
                    <div data-value="<?= params([
                        'order_id' => $order_id,
                        'transaction_id' => $item['appcode'],
                        'sum' => (float)$item['amount'],
                        'date' => $item['trandate'] . ' ' . $item['trantime'],
                        'description' => $item['description'],
                        'card' => $item['card']
                    ]) ?>" class="option">
                        <?= date_for_humans($item['trandate']) ?> <?= $item['trantime'] ?>
                        <br>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-primary"><?= $item['amount'] ?></span>
                        <br>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?= $item['description'] ?>
                    </div>
                <?php } ?>
            </div>
        </div>

        <div class="form-group" style="margin-bottom: 0">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>