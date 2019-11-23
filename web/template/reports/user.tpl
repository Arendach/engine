<?php

use RedBeanPHP\R;

$user = get('user') ? get('user') : user()->id;
?>

<?php include parts('head'); ?>

<div class="panel-group" id="accordion">
    <?php
    $start_life = date_parse(START_LIFE);
    for ($i = date('Y'); $i > $start_life['year'] - 1; $i--) { ?>
        <?php $rand32 = rand32(); ?>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapse<?= $rand32 ?>">
                        <?= $i ?>
                    </a>
                </h4>
            </div>
            <div id="collapse<?= $rand32 ?>" class="panel-collapse collapse<?= $i == date('Y') ? ' in' : '' ?>">
                <div class="panel-body">
                    <?php if ($start_life['year'] == $i) {
                        $start_month = $start_life['month'];
                        if ($i == date("Y"))
                            $finish_month = date('m') + 1;
                        else
                            $finish_month = 13;
                    } else if ($i == date('Y')) {
                        $start_month = 1;
                        $finish_month = date('m') + 1;
                    } else {
                        $start_month = 1;
                        $finish_month = 13;
                    }
                    for ($i2 = $start_month; $i2 < $finish_month; $i2++) {
                        $count = R::count('reports', 'YEAR(`date`) = ? AND MONTH(`date`) = ? AND `user` = ?', [$i, $i2, $user]);
                        if ($count) { ?>
                            <div style="margin-bottom: 5px; color: grey">
                                <i class="fa fa-dot-circle-o"></i>
                                <a disabled="disabled"
                                   href="<?= uri('reports',[
                                       'section' => 'view',
                                       'year' => $i,
                                       'month' => month_valid($i2),
                                       'user' => $user
                                   ]) ?>"><?= int_to_month($i2) . '(' . $count . ')' ?></a>
                            </div>
                        <?php } else { ?>
                            <div style="margin-bottom: 5px; color: grey">
                                <i class="fa fa-dot-circle-o"></i> <?= int_to_month($i2) ?>
                            </div>
                        <?php } ?>
                    <?php } ?>
                </div>
            </div>
        </div>
    <?php } ?>
</div>

<?php include parts('foot'); ?>
