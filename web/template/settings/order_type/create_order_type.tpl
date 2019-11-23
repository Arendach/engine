<?php

$title = 'Новий тип замовлення';
include parts('modal_head');

?>

    <form action="<?= uri('settings') ?>" data-type="ajax">
        <input type="hidden" name="action" value="create_order_type">

        <div class="form-group">
            <label for="name"><span class="text-danger">*</span> Назва</label>
            <input name="name" id="name" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label for="color"><span class="text-danger">*</span> Колір</label>
            <input name="color" id="color" class="form-control input-sm">
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