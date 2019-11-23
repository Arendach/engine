<?php include parts('head'); ?>

    <div class="right" style="margin: 15px 0">
        <a href="<?= '' ?>" class="btn btn-default">Звітність</a>
        <a href="#" class="btn btn-default">Зміни в замовленнях</a>
        <a href="#" class="btn btn-default">Зміни в товарах</a>
        <?php if (can()) { ?>
            <a href="<?= uri('user', ['id' => $manager->id, 'section' => 'view']); ?>" class="btn btn-primary">Налаштування</a>
        <?php } ?>
    </div>

    <table class="table table-bordered">
        <tr>
            <td>Прізвище:</td>
            <td><?= !empty($manager->last_name) ? $manager->last_name : 'Не заповнено'; ?></td>
        </tr>
        <tr>
            <td>Імя:</td>
            <td><?= !empty($manager->first_name) ? $manager->first_name : 'Не заповнено'; ?></td>
        </tr>
        <tr>
            <td>Email:</td>
            <td><?= !empty($manager->email) ? $manager->email : 'Не заповнено'; ?></td>
        </tr>
        <tr>
            <td>Група доступу:</td>
            <td>
                <?php if (isset($manager->access_link)) {
                    echo '<a href="' . route('access_group', ['id' => $manager->access]) . '">' . $manager->access_name . '</a>';
                } else {
                    echo $manager->access_name;
                } ?>
            </td>
        </tr>
    </table>

<?php include parts('foot'); ?>