<?php if ($order->client == '') { ?>
    <h4>Дане замовлення не привязане до жодного клієнта</h4>
<?php } else { ?>
    <table class="table">
        <tr>
            <td><b>Інформація:</b></td>
            <td><b>Постійний клієнт:</b></td>
            <td><b>Нромер телефону:</b></td>
            <td class="action-1"><b>Дії</b></td>
        </tr>
        <tr>
            <td><span class="text-primary"><?= htmlspecialchars_decode($order->client->info) ?></span></td>
            <td><span class="text-primary"><?= $order->client->name ?></span></td>
            <td><span class="text-primary"><?= $order->client->phone ?></span></td>
            <td class="action-1">
                <button data-type="delete"
                        data-action="reset_client_to_order"
                        data-uri="<?= uri('clients') ?>"
                        data-post="<?= params(['client_id' => $order->client->id, 'order_id' => $order->id]) ?>"
                        class="btn btn-danger btn-xs">
                    <span class="glyphicon glyphicon-remove"></span>
                </button>
            </td>
        </tr>
    </table>
<?php } ?>

<div class="form-group">
    <label for="search_name"></label>
    <input type="text" class="form-control" id="search_name" placeholder="Введіть 3 символи">
</div>

<div id="place_for_search_result"></div>

<div class="form-group">
    <button id="add_order_to_client" class="btn btn-primary" disabled="disabled">Зберегти</button>
</div>