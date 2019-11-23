<?php include parts('modal_head'); ?>

    <form action="<?= uri('work_schedule') ?>" data-type="ajax">
        <input type="hidden" name="action" value="update_schedule">
        <input type="hidden" name="year" value="<?= $data->year ?>">
        <input type="hidden" name="month" value="<?= $data->month ?>">
        <input type="hidden" name="user" value="<?= $data->user ?>">
        <input type="hidden" name="id" value="<?= $data->id ?>">

        <div class="form-group">
            <label for="shipment_order"><?= l('schedule.shipment_order') ?></label>
            <input class="form-control" name="shipment_order" id="shipment_order" value="<?= $data->shipment_order ?>">
        </div>

        <div class="form-group">
            <label for="phone_call"><?= l('schedule.phone_call') ?></label>
            <input class="form-control" name="phone_call" id="phone_call" value="<?= $data->phone_call ?>">
        </div>

        <div class="form-group">
            <label for="created_ttn"><?= l('schedule.created_ttn') ?></label>
            <input class="form-control" name="created_ttn" id="created_ttn" value="<?= $data->created_ttn ?>">
        </div>

        <div class="form-group">
            <label for="sold_products"><?= l('schedule.sold_products') ?></label>
            <input class="form-control" name="sold_products" id="sold_products" value="<?= $data->sold_products ?>">
        </div>

        <div class="form-group">
            <label for="self"><?= l('schedule.self') ?></label>
            <input class="form-control" name="self" id="self" value="<?= $data->self ?>">
        </div>

        <div class="form-group">
           <button class="btn btn-primary"><?= l('d.save') ?></button>
        </div>

    </form>

<?php include parts('modal_foot') ?>