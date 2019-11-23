<?php if (can('payouts')) { ?>
    <div class="right" style="margin-bottom: 15px;">
        <button <?= $payouts_sum >= $salary ? 'disabled' : '' ?> data-type="get_form"
                data-uri="<?= uri('schedule') ?>"
                data-action="create_payout_form"
                data-post="<?= params(['year' => $data->year, 'month' => $data->month, 'user' => $data->user]) ?>"
                class="btn btn-success">
            Нова виплата
        </button>
    </div>
<?php } ?>

<?php if (my_count($payouts) > 0) { ?>
    <table class="table table-bordered">
        <tr>
            <td style="font-weight: bold">Дата виплати</td>
            <td style="font-weight: bold">Сума</td>
            <td style="font-weight: bold">Виплатив</td>
            <td style="font-weight: bold">Коментар</td>
            <?php if (can('payouts')) { ?>
                <td style="font-weight: bold" class="action-2">Дії</td>
            <?php } ?>
        </tr>
        <?php foreach ($payouts as $payout) { ?>
            <tr>
                <td><?= date_for_humans($payout->date_payout) ?></td>
                <td><?= $payout->sum ?> грн</td>
                <td>
                    <a href="<?= uri('user', ['section' => 'view', 'id' => $payout->author]) ?>">
                        <?= user($payout->author)->login ?>
                    </a>
                </td>
                <td><?= $payout->comment ?></td>
                <?php if (can('payouts')) { ?>
                    <td>
                        <button data-type="get_form"
                                data-uri="<?= uri('schedule') ?>"
                                data-action="update_payout_form"
                                data-post="<?= params(['id' => $payout->id]) ?>"
                                class="btn btn-primary btn-xs"
                                title="Редагувати">
                            <i class="fa fa-pencil"></i>
                        </button>
                        <button data-type="delete"
                                data-uri="<?= uri('schedule') ?>"
                                data-action="delete_payout"
                                data-id="<?= $payout->id ?>"
                                class="btn btn-danger btn-xs" title="Видалити">
                            <i class="fa fa-remove"></i>
                        </button>
                    </td>
                <?php } ?>
            </tr>
        <?php } ?>
    </table>
<?php } else { ?>
    <h4 class="centered">Тут пусто :(</h4>
<?php } ?>