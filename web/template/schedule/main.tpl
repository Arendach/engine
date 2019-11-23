<?php include parts('head'); ?>

<?php if (count($schedules) > 0) { ?>
    <div class="panel-group" id="accordion">
        <?php foreach ($schedules as $year => $schedule) { ?>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse<?= $year ?>">
                            <?= $year ?>
                        </a>
                    </h4>
                </div>
                <div id="collapse<?= $year ?>" class="panel-collapse collapse <?= $year == date('Y') ? 'in' : '' ?>">
                    <div class="panel-body">
                        <?php for ($i = 1; $i < 13; $i++) { ?>
                            <?php if (isset($schedule[$i])) { ?>
                                <?php $item = $schedule[$i]; ?>
                                <div style="color: grey">
                                <i class="fa fa-dot-circle-o"></i> <a href="<?= uri('schedule', [
                                        'section' => 'view',
                                        'year' => $year,
                                        'month' => $i,
                                        'user' => $item->user
                                    ]) ?>">
                                        <?php echo int_to_month($i) ?>
                                    </a>
                                </div>
                            <?php } else { ?>
                                <div style="color: grey">
                                    <i class="fa fa-dot-circle-o"></i> <?php echo int_to_month($i); ?>
                                </div>
                            <?php } ?>
                        <?php } ?>
                    </div>
                </div>
            </div>
        <?php } ?>
    </div>
<?php } else { ?>
    <h4 class="centered">Тут пусто :(</h4>
<?php } ?>

<?php include parts('foot'); ?>