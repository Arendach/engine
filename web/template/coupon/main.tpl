<?php include parts('head'); ?>


<div class="right" style="margin-bottom: 10px">
    <button data-type="get_form"
            data-uri="<?= uri('coupon') ?>"
            data-action="create_form"
            class="btn btn-primary"
            title="Створити новий купон">
        Створити
    </button>
</div>

<table class="table table-bordered">
    <tr>
        <td>Код</td>
        <td>Тип</td>
        <td>Дії</td>
    </tr>
    <?php if (my_count($coupons) > 0):
        foreach ($coupons as $coupon): ?>
            <tr>
                <td><?= $coupon->code; ?></td>
                <td><?= $coupon->type == 0 ? 'Стаціонарний' : 'Накопичувальний'; ?></td>
                <td class="action-2">
                    <button data-type="get_form"
                            data-uri="<?= uri('coupon') ?>"
                            data-action="update_form"
                            data-post="<?= params(['id' => $coupon->id]) ?>"
                            class="btn btn-primary btn-xs">
                        <span class="glyphicon glyphicon-pencil"></span>
                    </button>
                    <button data-type="delete"
                            data-uri="<?= uri('coupon') ?>"
                            data-action="delete"
                            data-id="<?= $coupon->id; ?>"
                            class="btn btn-danger btn-xs">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </td>
            </tr>
        <?php endforeach;
    else: ?>
        <tr>
            <td colspan="6">
                <h4 class="centered">Тут пусто :(</h4>
            </td>
        </tr>
    <?php endif; ?>
</table>

<?php if (isset($paginate)) { ?>
    <div class="centered">
        <?php include parts('paginate'); ?>
    </div>
<?php } ?>

<?php include parts('foot'); ?>


