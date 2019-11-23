<?php include parts('modal_head') ?>

    <form data-type="ajax" action="<?= uri('product') ?>">
        <input type="hidden" name="action" value="create_moving">

        <div class="form-group">
            <label><i class="text-danger">*</i> На менеджера</label>
            <select required class="form-control input-sm" name="user_to">
                <option value=""></option>
                <?php foreach ($users as $item) { ?>
                    <option value="<?= $item->id ?>"><?= $item->login ?></option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label><i class="text-danger">*</i> З складу</label>
            <select required class="form-control input-sm" name="storage_from">
                <option value=""></option>
                <?php foreach ($storage as $item) { ?>
                    <option value="<?= $item->id ?>"><?= $item->name ?></option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label><i class="text-danger">*</i> На склад</label>
            <select required class="form-control input-sm" name="storage_to">
                <option value=""></option>
                <?php foreach ($storage as $item) { ?>
                    <option value="<?= $item->id ?>"><?= $item->name ?></option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label>Пошук</label>
            <input class="form-control" id="search">

            <ul class="list-group" style="margin-bottom: 0" id="search_results"></ul>

            <div id="place_products">


            </div>
        </div>

        <div class="form-group">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>
    </form>

    <script>
        $(document).ready(function () {
            $(document).on('keyup', '#search', function () {
                var $this = $(this);
                var $storage_from = $('[name="storage_from"]');

                if ($this.val().length < 3) {
                    $('#search_results').html('');
                    return;
                }

                console.log($storage_from.val())

                if ($storage_from.val() == '') {
                    $('#search_results').html('');
                    return;
                }

                $.ajax({
                    type: 'post',
                    url: url('product'),
                    data: {
                        storage: $storage_from.val(),
                        name: $this.val(),
                        action: 'search_products_to_moving'
                    },
                    success: function (answer) {
                        $('#search_results').html(answer);
                    }
                });
            });

            $(document).on('click', '.product_item_s', function () {
                var $this = $(this);

                $.ajax({
                    type: 'post',
                    url: url('product'),
                    data: {
                        action: 'get_product',
                        id: $(this).data('id'),
                        storage: $(this).data('storage')
                    },
                    success: function (answer) {
                        $('#place_products').prepend(answer);
                        $this.remove();
                    }
                })
            });

            $(document).on('keyup', '#place_products input', function () {
                if ($(this).val() > $(this).data('max')) $(this).val($(this).data('max'));

                if ($(this).val() < 0) $(this).val(0);
            });


        });

        function delete_item(e) {
            $(e).parent().remove();
        }
    </script>


<?php include parts('modal_foot') ?>