<?php include parts('head'); ?>

<style>
    .tooltip{
        z-index: 99999;
    }
</style>

<div class="right" style="margin-bottom: 10px">
    <a href="<?= route('register'); ?>" class="btn btn-primary">Реєструвати</a>
</div>

<div class="container-fluid">

    <?php foreach ($items as $item) { ?>

        <?php if (!is_online(strtotime($item->updated_at))) {
            $title = 'Був онлайн ' . diff_for_humans($item->updated_at);
            $color = 'red';
        } else {
            $title = 'Онлайн';
            $color = 'green';
        } ?>

        <div class="user-block">
            <i data-toggle="tooltip" title="<?= $title ?>" style="color: <?= $color ?>" class="fa fa-circle-o"></i>
            <a href="<?= uri('user', ['section' => 'view', 'id' => $item->id]) ?>">
                <span class="user-name"> <?= $item->login ?></span>
            </a>

            <div class="buttons123">
                <?php if (can()) { ?>

                    <?php if (array_sum([$item->delivery, $item->sending, $item->shop, $item->self]) > 0){ ?>
                    <div class="not_closed_orders">
                        <?php if($item->sending != 0) { ?>
                            <a href="<?= route('orders', ['type' => "sending"]).parameters(['courier' => $item->id, 'status' => 'open']) ?>">Відправки - <?= $item->sending ?></a><br>
                        <?php } ?>

                        <?php if($item->delivery != 0) { ?>
                            <a href="<?= route('orders', ['type' => "delivery"]).parameters(['courier' => $item->id, 'status' => 'open']) ?>">Доставки - <?= $item->delivery ?></a><br>
                        <?php } ?>

                        <?php if($item->shop != 0) { ?>
                            <a href="<?= route('orders', ['type' => "shop"]).parameters(['courier' => $item->id, 'status' => 'open']) ?>">Магазин - <?= $item->shop ?></a><br>
                        <?php } ?>

                        <?php if($item->self != 0) { ?>
                            <a href="<?= route('orders', ['type' => "self"]).parameters(['courier' => $item->id, 'status' => 'open']) ?>">Самовивози - <?= $item->self ?></a>
                        <?php } ?>
                    </div>

                    <button class="btn btn-warning btn-xs not_closed">
                        <span class="fa fa-commenting-o"></span>
                    </button>

                    <?php } else { ?>
                        <button class="btn btn-success btn-xs">
                            <span class="fa fa-check"></span>
                        </button>
                    <?php } ?>

                    <a href="<?= route('reports').parameters(['section' => 'user', 'user' => $item->id]); ?>"
                       class="btn btn-primary btn-xs">
                        <i class="fa fa-dollar"></i>
                    </a>
                    <a href="<?= uri('user', ['section' => 'update', 'id' => $item->id]); ?>" class="btn btn-primary btn-xs">
                        <i class="glyphicon glyphicon-pencil"></i>
                    </a>
                    <a href="<?= route('task') . parameters(['user' => $item->id, 'section' => 'list']); ?>"
                       class="btn btn-primary btn-xs">
                        <i class="fa fa-list"></i>
                    </a>
                <?php } ?>
            </div>
        </div>

    <?php } ?>

</div>

<?php include parts('foot'); ?>
