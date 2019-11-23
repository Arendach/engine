<?php include parts('modal_head'); ?>

    <form id="update_coupon">

        <input type="hidden" name="id" value="<?= $coupon->id ?>">
        <input type="hidden" value="<?= $coupon->type; ?>" name="type">

        <div class="form-group">
            <label for="code">Код</label>
            <input id="code" name="code" class="form-control" value="<?= $coupon->code; ?>">
        </div>

        <?php
        $type = $coupon->type == 0 ? 'stationary' : 'cumulative';
        include t_file("coupon.forms.types.$type");
        ?>

        <div class="form-group">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot'); ?>