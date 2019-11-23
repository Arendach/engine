<?php include parts('modal_head'); ?>

    <form data-type="ajax" action="<?= uri('settings') ?>">
        <input type="hidden" name="action" value="update_order_type">
        <input type="hidden" name="id" value="<?= $order_type->id ?>">

        <div class="form-group">
            <label for="name"><span class="text-danger">*</span> Назва</label>
            <input class="form-control input-sm" name="name" id="name" value="<?= $order_type->name ?>">
        </div>

        <div class="form-group">
            <label for="color"><span class="text-danger">*</span> Колір</label>
            <input name="color" id="color" class="form-control input-sm" value="<?= $order_type->color ?>">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-sm btn-primary">Зберегти</button>
        </div>

    </form>

    <script>
        $(document).ready(function () {

            var $body = $('body');

            $body.on('focus', '#color, #color_edit', function () {
                $(this).ColorPicker({
                    onSubmit: function (hsb, hex, rgb, el) {
                        $(el).val(hex);
                        $(el).ColorPickerHide();
                    },
                    onBeforeShow: function () {
                        $(this).ColorPickerSetColor(this.value);
                    }
                }).bind('keyup', function () {
                    $(this).ColorPickerSetColor(this.value);
                });
            });
        });
    </script>

<?php include parts('modal_foot') ?>