<?php include parts('modal_head') ?>

    <form data-type="ajax" action="<?= uri('orders/close') ?>">
        <input type="hidden" name="id" value="<?= $order->id ?>">

        <div class="form-group">
            <label for="name_operation">Назва операції</label>
            <input type="text" class="form-control" name="name_operation" value="Замовлення №<?= $order->id ?>">
        </div>

        <div class="form-group <?= cannot() ? 'none' : '' ?>">
            <label>Сума(сума + доставка - знижка - предоплата)</label>
            <input  class="form-control" name="sum" value="<?= $order->full_sum - $order->prepayment ?>">
        </div>

        <div class="form-group <?= can() ? 'none' : '' ?>">
            <label>Сума(сума + доставка - знижка - предоплата)</label>
            <span style="display: block; border: 1px solid #ccc;padding: 8px; border-radius: 4px">
                <?= $order->full_sum - $order->prepayment ?>
            </span>
        </div>


        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea class="form-control" name="comment"><?= date('d.m.Y', strtotime($order->date_delivery)) ?> <?= $order->courier_id != user()->id && $order->courier_id != 0 ? user($order->courier_id)->name : '' ?></textarea>
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Закрити замовлення</button>
        </div>
    </form>

<?php include parts('modal_foot') ?>