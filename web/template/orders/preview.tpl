<?php if ($order->comment != '') { ?>
    <table class="table table-bordered" style="margin-bottom: -10px">
        <tr>
            <td class="right">Коментар:</td>
            <td colspan="4"><?= preg_replace('/\n/', '<br>', $order->comment) ?></td>
        </tr>
    </table>
<?php } ?>

<table class="table table-bordered">
    <tr>
        <td>Товар</td>
        <td>Модель</td>
        <td>Кількість</td>
        <td>Ціна</td>
        <td>Сума</td>
    </tr>
    <?php foreach ($order->products as $item) { ?>
        <tr>
            <td><?= $item->name ?></td>
            <td><?= $item->model ?></td>
            <td><?= $item->pivot->amount ?></td>
            <td><?= number_format($item->pivot->price, 2) ?></td>
            <td><?= number_format($item->pivot->amount * $item->pivot->price, 2) ?></td>
        </tr>
    <?php } ?>
    <tr>
        <td colspan="3"></td>
        <td class="right">Знижка:</td>
        <td><?= number_format($order->discount, 2) ?></td>
    </tr>
    <tr>
        <td colspan="3"></td>
        <td class="right"> Доставка:</td>
        <td><?= number_format($order->delivery_cost, 2) ?></td>
    </tr>
    <tr>
        <td colspan="3"></td>
        <td class="right">Загальна сума:</td>
        <td><?= number_format($order->full_sum, 2) ?></td>
    </tr>
</table>