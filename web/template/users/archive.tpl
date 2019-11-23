<?php include parts('head'); ?>

<style>
    .tooltip{
        z-index: 99999;
    }
</style>

<div class="container-fluid">

    <?php foreach ($items as $item) {
        if (!is_online(strtotime($item->updated_at))) {
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

                    <a href="<?= uri('reports', ['section' => 'user', 'user' => $item->id]); ?>"
                       class="btn btn-primary btn-xs">
                        <i class="fa fa-dollar"></i> Звіти
                    </a>
                    <a href="<?= uri('user', ['section' => 'update', 'id' => $item->id]); ?>" class="btn btn-primary btn-xs">
                        <i class="glyphicon glyphicon-pencil"></i> Редагувати
                    </a>
                    <a href="<?= uri('task', ['user' => $item->id, 'section' => 'list']); ?>"
                       class="btn btn-primary btn-xs">
                        <i class="fa fa-list"></i> Таск менеджер
                    </a>
                    <a href="<?= uri('schedule', ['user' => $item->id]); ?>"
                       class="btn btn-primary btn-xs">
                        <i class="fa fa-line-chart"></i> Графік роботи
                    </a>
                <?php } ?>
            </div>
        </div>

    <?php } ?>

</div>

<script>
    $(document).ready(function () {
        var $body = $('body');

        $body.on('click', '.not_closed', function () {
            var $container = $(this).parents('.buttons123').find('.not_closed_orders');
            if ($container.css('display') == 'none'){
                $container.show();
            } else {
                $container.hide();
            }
        });
    });
</script>

<?php include parts('foot'); ?>
