<?php include parts('head'); ?>

<?php include t_file('settings.buttons') ?>

    <table class="table table-bordered">
        <tr>
            <th>Колір</th>
            <th>Опис</th>
            <th>Тип</th>
            <th class="action-2">Дії</th>
        </tr>
        <?php if (my_count($items) > 0) { ?>
            <?php foreach ($items as $item){ ?>
                <tr>
                    <td>
                        <div class="color_hint" style="width: 30px; height: 30px; background: #<?= $item->color; ?>;">

                        </div>
                    </td>
                    <td>
                        <?= $item->description; ?>
                    </td>
                    <td>
                        <?php if ($item->type == '0') { ?>
                            Загальний
                        <?php } elseif ($item->type == 'self') { ?>
                            Самовивози
                        <?php } elseif ($item->type == 'shop') { ?>
                            Магазин
                        <?php } elseif ($item->type == 'delivery') { ?>
                            Доставки
                        <?php } elseif ($item->type == 'sending') { ?>
                            Відправки
                        <?php } ?>
                    </td>
                    <td class="action-2">
                        <a data-type="get_form"
                           data-uri="<?= uri('settings') ?>"
                           data-action="color_form_update"
                           data-post="<?= params(['id' => $item->id]) ?>"
                           class="btn btn-primary btn-xs">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </a>
                        <button data-type="delete"
                                data-uri="<?= uri('settings') ?>"
                                data-action="color_delete"
                                data-id="<?= $item->id ?>"
                                class="btn btn-danger btn-xs">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                    </td>
                </tr>
            <?php } ?>
        <?php } else { ?>
            <tr>
                <td class="centered" colspan="4">
                    <h4>Тут пусто :(</h4>
                </td>
            </tr>
        <?php } ?>
    </table>

    <div class="type_block" style="padding: 10px">
        <form data-type="ajax" action="<?= uri('settings') ?>">
            <input type="hidden" name="action" value="color_create">

            <div class="form-group">
                <label for="description"><span class="text-danger">*</span> Опис</label>
                <input id="description" name="description" class="form-control">
            </div>

            <div class="form-group">
                <label for="type"><span class="text-danger">*</span> Тип</label>
                <select name="type" id="type" class="form-control">
                    <option value="0">Загальний</option>
                    <option value="self">Самовивози</option>
                    <option value="sending">Відправки</option>
                    <option value="shop">Магазин</option>
                    <option value="delivery">Доставки</option>
                </select>
            </div>

            <div class="form-group">
                <label for="color"><span class="text-danger">*</span> Колір</label>
                <input class="form-control" id="color" value="00ff00" name="color">
            </div>

            <div class="form-group">
                <button class="btn btn-primary">Нова підказка</button>
            </div>

        </form>
    </div>

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

<?php include parts('foot') ?>