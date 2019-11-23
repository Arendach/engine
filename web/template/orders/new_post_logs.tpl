<?php include parts('head') ?>


    <div class="panel-group" id="accordion">
        <?php foreach ($logs as $log) { ?>
            <?php $rand32 = rand32(); ?>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#<?= $rand32 ?>">
                            Пункт Группы Свертывания #1
                        </a>
                    </h4>
                </div>
                <div id="<?= $rand32 ?>" class="panel-collapse collapse in">
                    <div class="panel-body">
                        <pre>
                            <?php var_dump($log) ?>
                        </pre>
                    </div>
                </div>
            </div>
        <?php } ?>
    </div>

<?php include parts('foot') ?>