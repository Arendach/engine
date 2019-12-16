<?php include parts('head') ?>
    <h1 class="sub-header"><?= $section ?></h1>

<?php if ($notification || count($not_moving_money) > 0 || count($product_moving) > 0) { ?>

    <h2><i style="color: red" class="fa fa-bell"></i> Сповіщення</h2>

    <?php if ($notification) { ?>

        <?php foreach ($notification as $item) { ?>
            <div class="alert alert-<?= $item->type ?> alert-dismissable">
                <div class="row">
                    <div class="col-md-9">
                        <?= $item->content ?>
                    </div>
                    <div class="col-md-3 right">
                        <?= $item->date ?>
                        <button data-id="<?= $item->id ?>" type="button" class="close close_notification"
                                data-dismiss="alert">&times;
                        </button>
                    </div>
                </div>
            </div>
        <?php } ?>
    <?php } ?>

    <?php if (count($not_moving_money) > 0) { ?>
        <div class="alert alert-info">
            <?php foreach ($not_moving_money as $item) {
                list($user_id, $status) = explode(':', $item->data); ?>
                Менеджер
                <a href="<?= uri('manager/' . $user_id) ?>"><b style="color: green"><?= user($user_id)->login ?></b>
                </a>
                ще не підтвердив отримання коштів в сумі
                <b style="color: green"><?= $item->sum ?></b> грн <br>
            <?php } ?>
        </div>
    <?php } ?>

    <?php if (count($product_moving) > 0) { ?>
        <?php foreach ($product_moving as $item) { ?>
            <div class="alert alert-success alert-dismissable">
                <div class="row">
                    <div class="col-md-9">
                    Прийняти товар від менеджера <?= user($item->user_from)->login ?>.
                        <a href="<?= uri('product', ['section' => 'print_moving', 'id' => $item->id]) ?>">
                            Детальніше тут.
                        </a>
                    </div>
                    <div class="col-md-3 right">
                        <?= ($item->date) ?> <br>
                        <button data-type="ajax_request"
                                data-uri="<?= uri('product') ?>"
                                data-action="close_moving"
                                data-post="<?= params(['id' => $item->id]) ?>"
                                type="button"
                                class="btn btn-success btn-xs">
                            Підтвердити
                        </button>
                    </div>
                </div>
            </div>
        <?php } ?>
    <?php } ?>
<?php } ?>

<?php if (
    $schedules - 1 > 0 ||
    $schedules_month['work_schedules_month'] > 0 ||
    $nco !== 0 ||
    $liable_orders->self > 0 ||
    $liable_orders->delivery > 0) { ?>

    <h2><i style="color: red" class="fa fa-file-text"></i> Нагадування</h2>
    <?php if ($nco !== 0) { ?>
        <div class="alert alert-info">
            У вас не закрито: <br>

            <?php if ($nco->sending != 0) { ?>
                <a href="<?= uri('orders', ['type' => "sending", 'courier' => user()->id, 'status' => 'open']) ?>">
                    Відправки - <b style="color: red"><?= $nco->sending ?></b><br>
                </a>
            <?php } ?>

            <?php if ($nco->delivery != 0) { ?>
                <a href="<?= uri('orders', ['type' => "delivery", 'courier' => user()->id, 'status' => 'open']) ?>">
                    Доставки - <b style="color: red"><?= $nco->delivery ?></b><br>
                </a>
            <?php } ?>

            <?php if ($nco->self != 0) { ?>
                <a href="<?= uri('orders', ['type' => "self", 'courier' => user()->id, 'status' => 'open']) ?>">
                    Самовивози - <b style="color: red"><?= $nco->self ?></b>
                </a>
            <?php } ?>
        </div>
    <?php } ?>

    <?php if ($liable_orders->self > 0 || $liable_orders->delivery > 0) { ?>
        <div class="alert alert-success">
            За вами закріплені замовлення: <br>
            <?php if ($liable_orders->self > 0) { ?>
                <a href="<?= uri('orders', [
                        'type' => 'self',
                    'liable' => user()->id,
                    'from' => date('Y-m-d', time() - 60 * 60 * 24 * 90),
                    'to' => date('Y-m-d', time() + 60 * 60 * 24 * 365)
                ]) ?>">
                    Самовивози - <b style="color: red"><?= $liable_orders->self ?></b>
                </a>
            <?php } ?>

            <?php if ($liable_orders->delivery > 0 && $liable_orders->self > 0) { ?>
                <br>
            <?php } ?>

            <?php if ($liable_orders->delivery > 0) { ?>

                <a href="<?= uri('orders', [
                        'type' => 'delivery',
                    'liable' => user()->id,
                    'from' => date('Y-m-d', time() - 60 * 60 * 24 * 90),
                    'to' => date('Y-m-d', time() + 60 * 60 * 24 * 365)]) ?>">
                    Доставки - <b style="color: red"><?= $liable_orders->delivery ?></b>
                </a>
            <?php } ?>
        </div>
    <?php } ?>


    <?php if ($schedules - 1 > 0) { ?>
        <div class="alert alert-warning alert-dismissable">
            <strong>Увага!</strong> За цей місяць у вашому графіку не заповнено -
            <b style="color: red"><?= $schedules - 1; ?></b> днів!<br>
            Графік можна заповнити за даним
            <a href="<?= uri('schedule', ['section' => 'view']) ?>">
                посиланням
            </a>
        </div>
    <?php } ?>

    <?php if ($schedules_month['work_schedules_month'] > 0) { ?>
        <div class="alert alert-danger alert-dismissable">
            <strong>Увага!</strong> За минулий місяць у вашому графіку не заповнено
            - <b style="color: red"><?= $schedules_month['work_schedules_month']; ?></b> днів!<br>
            Графік можна заповнити за даним
            <a href="<?= uri('schedule', ['section' => 'view', 'year' => $schedules_month['year'], 'month' => $schedules_month['month']]) ?>">
                посиланням
            </a>
        </div>
    <?php } ?>
<?php } ?>


<?php if (count($moving_money) > 0 || count($tasks) > 0) { ?>

    <h2><i style="color: red" class="fa fa-automobile"></i> Задачі</h2>

    <?php if (count($moving_money) > 0) {
        foreach ($moving_money as $item) { ?>
            <div class="alert alert-info">
                <div class="row">
                    <div class="col-md-9">
                        Менеджер <?= user($item->user)->login ?> хоче передати
                        вам <?= number_format($item->sum, 2) ?>
                        грн
                    </div>
                    <div class="col-md-3 right">
                        <?= ($item->date) ?> <br>
                        <button data-type="get_form"
                                data-uri="<?= uri('reports') ?>"
                                data-action="close_moving_form"
                                data-post="<?= params(['id' => $item->id]) ?>" class="btn btn-xs btn-success">
                            Підтвердити
                        </button>
                    </div>
                </div>
            </div>
        <?php }
    }
    if (count($tasks) > 0) { ?>
        <?php foreach ($tasks as $item) { ?>
            <div class="alert alert-<?= $item->type ?>">
                <div class="row">
                    <div class="col-md-9">
                        <?php if ($item->price != 0) { ?>
                            <b>Бюджет задачі:</b> <span
                                    style="color: green"><?= number_format($item->price, 2) ?></span><br>
                        <?php } ?>
                        <?= htmlspecialchars_decode($item->content) ?>
                    </div>
                    <div class="right col-md-3">
                        <?= ($item->date) ?> <br>
                        <button data-type="success" data-id="<?= $item->id ?>"
                                class="close_task btn btn-xs btn-success">Виконано
                        </button>
                        <button data-type="danger" data-id="<?= $item->id ?>"
                                class="close_task btn btn-xs btn-danger">
                            Не виконано
                        </button>
                    </div>
                </div>
            </div>
        <?php }
    }
} ?>


<?php include parts('foot'); ?>