<?php include parts('head') ?>

<?php if (count($users) != 0) { ?>
    <?php foreach ($users as $user) { ?>
        <div style="color: gray">
            <i class="fa fa-circle-o"></i>
            <a href="<?= uri('schedule', ['user' => $user['id']]) ?>">
                <?= $user['login'] ?>
            </a>
        </div>
        <hr style="margin: 5px">
    <?php } ?>
<?php } else { ?>
    <h4 class="centered">Тут пусто :(</h4>
<?php } ?>

<?php include parts('foot') ?>