<?php include parts('head'); ?>

    <form action="<?= uri('settings') ?>" data-type="ajax">
        <input type="hidden" name="action" value="update_schedule">

        <div class="form-group">
            <label for="shipment_order"><?= l('schedule.shipment_order_cost') ?></label>
            <input class="form-control" name="shipment_order" id="shipment_order" value="<?= setting('shipment_order') ?>">
        </div>

        <div class="form-group">
            <label for="phone_call"><?= l('schedule.phone_call_cost') ?></label>
            <input class="form-control" name="phone_call" id="phone_call" value="<?= setting('phone_call') ?>">
        </div>

        <div class="form-group">
            <label for="created_ttn"><?= l('schedule.created_ttn_cost') ?></label>
            <input class="form-control" name="created_ttn" id="created_ttn" value="<?= setting('created_ttn') ?>">
        </div>

        <div class="form-group">
            <label for="sold_products"><?= l('schedule.sold_products_cost') ?></label>
            <input class="form-control" name="sold_products" id="sold_products" value="<?= setting('sold_products') ?>">
        </div>

        <div class="form-group">
            <label for="self"><?= l('schedule.self_cost') ?></label>
            <input class="form-control" name="self" id="self" value="<?= setting('self') ?>">
        </div>

        <div class="form-group">
            <button class="btn btn-primary"><?= l('d.save') ?></button>
        </div>

    </form>


<?php include parts('footer') ?>