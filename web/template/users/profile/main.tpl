<?php include parts('head'); ?>

<div style="border-left: 1px solid grey; padding: 10px;">
    <div style="color: grey">
        <i class="fa fa-dot-circle-o"></i> <a href="<?= uri('schedule', ['section' => 'view']) ?>">Мій графік роботи</a>
    </div>

    <div>
        <i class="fa fa-dot-circle-o"></i> <a href="<?= uri('reports', ['section' => 'user', 'user' => user()->id]) ?>">Мої
            звіти</a>
    </div>

    <div>
        <i class="fa fa-dot-circle-o"></i> <a href="<?= uri('user', ['section' => 'update_password']) ?>">Зміна
            паролю</a>
    </div>

    <div>
        <i class="fa fa-dot-circle-o"></i> <a href="<?= uri('user', ['section' => 'instruction']) ?>">Посадова
            інструкція</a>
    </div>
</div>

<?php include parts('foot'); ?>
