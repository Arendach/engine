<?php include parts('head') ?>

    <div class="row" style="margin-bottom: 15px;">
        <div class="col-md-6">
            <b>Мерчант:</b> <br>
            <select class="form-control" id="merchant" style="margin-bottom: 15px;">
                <option value=""></option>
                <?php foreach ($merchant as $item) { ?>
                    <option <?= $item->id == get('merchant') ? 'selected' : '' ?> value="<?= $item->id ?>">
                        <?= $item->name ?>
                    </option>
                <?php } ?>
            </select>

            <b>Від:</b> <br>
            <input <?= get('date_to') ? 'value="' . get('date_to') . '"' : '' ?> id="date_to" type="date"
                                                                                 class="form-control">
        </div>
        <div class="col-md-6">
            <b>Картка:</b> <br>
            <?php if (count($cards) > 0) { ?>
                <select class="form-control" id="card" style="margin-bottom: 15px;">
                    <option value=""></option>
                    <?php foreach ($cards as $item) { ?>
                        <option <?= get('card') == $item->id ? 'selected' : '' ?> value="<?= $item->id ?>">
                            <?= $item->number ?>
                        </option>
                    <?php } ?>
                </select>
            <?php } else { ?>
                <select class="form-control" disabled id="card"></select>
            <?php } ?>

            <b>До:</b> <br>
            <input <?= get('date_from') ? 'value="' . get('date_from') . '"' : '' ?> id="date_from" type="date"
                                                                                     class="form-control">
        </div>
    </div>

    <div class="centered">
        <button <?= !get('card') || !get('merchant') ? 'disabled' : '' ?> class="btn btn-primary btn-block filter">
            Фільтрувати
        </button>
    </div>

    <hr>


<?php if (count($items) > 0) { ?>
    <table class="table table-bordered">
        <tr>
            <th>Карта</th>
            <th>Дата</th>
            <th>Сума</th>
            <th>Опис</th>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr>
                <td><?= $item['card'] ?></td>
                <td><?= $item['trandate'] ?> <?= $item['trantime'] ?></td>
                <td><?= $item['cardamount'] ?></td>
                <td><?= $item['description'] ?></td>
            </tr>
        <?php } ?>
    </table>
<?php } else { ?>
    <h4 class="centered">Тут пусто :(</h4>
<?php } ?>

    <script>
        $(document).ready(function () {
            $(document).on('click', '.filter', function () {

                var data = {
                    date_to: $('#date_to').val(),
                    date_from: $('#date_from').val(),
                    merchant: $('#merchant').val(),
                    card: $('#card').val(),
                };

                GET.setObject(data).unsetEmpty().go();
            });

            $(document).on('change', '#merchant', function () {
                var $this = $(this);
                var $card = $('#card');

                if ($this.val() == '') {
                    $card.attr('disabled', 'disabled');
                    return;
                }

                $.ajax({
                    type: 'post',
                    url: url('pb'),
                    data: {
                        merchant: $this.val(),
                        action: 'get_cards'
                    },
                    success: function (answer) {
                        $card.html(answer).removeAttr('disabled');
                    },
                    error: function (answer) {
                        errorHandler(answer);
                    }
                });
            });

            $(document).on('change', '#merchant,#card', function () {
                if ($('#merchant :selected').val() == '' || $('#card :selected').val() == '' || $('#card :selected').val() == undefined)
                    $('.filter').attr('disabled', 'disabled');
                else $('.filter').removeAttr('disabled');
            })
        });
    </script>

<?php include parts('foot') ?>