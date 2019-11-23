<table class="table table-bordered">
    <tr>
        <td><b>Амортизація авто</b></td>
        <td><b>Бонуси</b></td>
        <td><b>Штрафи</b></td>
        <?php if (can('bonuses')) { ?>
            <td class="action-1"><b>Дія</b></td>
        <?php } ?>
    </tr>
    <tr>
        <td><?= $data->for_car ?> грн</td>
        <td><?= $data->bonus ?> грн</td>
        <td><?= $data->fine ?> грн</td>
        <?php if (can('bonuses')) { ?>
            <td class="action-1">
                <button data-type="get_form"
                        data-uri="<?= uri('schedule') ?>"
                        data-action="update_bonuses_form"
                        data-post="<?= params([
                            'year' => $data->year,
                            'month' => $data->month,
                            'user' => $data->user,
                        ]) ?>"
                        class="btn btn-primary btn-xs">
                    <span class="glyphicon glyphicon-pencil"></span>
                </button>
            </td>
        <?php } ?>
    </tr>
</table>

<?php if(can('bonuses')){ ?>
    <div class="right" style="margin: -5px 0 15px 0;">
        <button data-type="get_form"
                data-uri="<?= uri('schedule') ?>"
                data-action="create_bonus_form"
                data-post="<?= params([
                    'year' => $data->year,
                    'month' => $data->month,
                    'user' => $data->user
                ]) ?>"
                class="btn btn-success">
            Новий бонус
        </button>
    </div>
<?php } ?>

<?php if (my_count($bonuses) != 0) { ?>
    <table class="table table-bordered">
        <tr>
            <td><b>Причина</b></td>
            <td><b>Бонус/Штраф</b></td>
            <td><b>Сума</b></td>
            <?php if (can('bonuses')) { ?>
                <td class="action-1"><b>Дія</b></td>
            <?php } ?>
        </tr>
        <?php foreach ($bonuses as $item) { ?>
            <?php $color = $item->type == 'bonus' ? 'rgba(0,255,0,.1)' : 'rgba(255,0,0,.1)' ?>
            <tr style="background-color: <?= $color ?>">
                <td>
                    <?php if ($item->source == 'order') { ?>
                        <a href="<?= uri('orders', ['section' => 'update', 'id' => $item->data], 'bonuses') ?>">
                            Замовлення №<?= $item->data ?>
                        </a>
                    <?php } elseif ($item->source == 'other') { ?>
                        Інше
                    <?php } elseif ($item->source == 'event') { ?>
                        <a href="<?= uri('orders', ['section' => 'update', 'id' => $item->data]) ?>">
                            Робота з івентами (№<?= $item->data ?>)
                        </a>
                    <?php } else { ?>
                        <a href="<?= uri('task', ['section' => 'list', 'id' => $item->data, 'user' => $item->user_id]) ?>">
                            Задача №<?= $item->data ?>
                        </a>

                    <?php } ?>
                </td>
                <td><?= $item->type == 'bonus' ? 'Бонус' : 'Штраф' ?></td>
                <td><?= $item->sum ?> грн</td>
                <?php if (can('bonuses')) { ?>
                    <td class="action-1">
                        <?php if ($item->source == 'order' || $item->source == 'event') {
                            $hash = $item->source == 'order' ? 'bonuses' : 'clients'; ?>
                            <a class="btn btn-primary btn-xs" href="<?= uri('orders', [
                                'section' => 'update',
                                'id' => $item->data
                            ], $hash) ?>">
                                <span class="fa fa-pencil"></span>
                            </a>
                        <?php } elseif ($item->source == 'other') { ?>
                            <button data-type="get_form"
                                    data-uri="<?= uri('schedule') ?>"
                                    data-action="update_bonus_form"
                                    data-post="<?= params([
                                        'id' => $item->id,
                                        'year' => $data->year,
                                        'month' => $data->month,
                                        'user' => $data->user
                                    ]) ?>"
                                    class="btn btn-primary btn-xs">
                                <span class="fa fa-pencil"></span>
                            </button>
                        <?php } elseif ($item->source == 'task') { ?>
                            <a class="btn btn-primary btn-xs" href="<?= uri('task', [
                                'section' => 'list',
                                'id' => $item->data,
                                'user' => $item->user_id
                            ]) ?>">
                                <span class="fa fa-pencil"></span>
                            </a>
                        <?php } ?>
                    </td>
                <?php } ?>
            </tr>
        <?php } ?>
    </table>
<?php } ?>