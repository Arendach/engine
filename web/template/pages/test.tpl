<?php include parts('head'); ?>

<?php if (isset($files)) { ?>
    <?php foreach ($files as $file) { ?>
        <a href="<?= uri('test', ['file' => $file]) ?>"><?= $file ?></a><br>
    <?php } ?>
<?php } else { ?>
    <div style="margin-top: 15px; margin-bottom: 15px">
        Середній час генерації сторінок: <?= $tl * 1000 ?> мс
    </div>

    <div class="panel-group" id="accordion">
        <?php foreach ($items as $uri => $arr) {
            $rand = rand32();
            $i = 0;
            foreach ($arr as $item) $i += $item['time_load'];
            $mtl = round($i / count($arr), 3) * 1000; // середній час загрузки
            ?>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse<?= $rand ?>">
                            <?= $uri ?> <span style="color: green;">(<?= $mtl ?>мс)</span>
                        </a>
                    </h4>
                </div>
                <div id="collapse<?= $rand ?>" class="panel-collapse collapse">
                    <div class="panel-body">
                        Згенеровано раз: <?= count($arr) ?><br>
                        Середній час генерації: <?= $mtl ?>мс
                        <?php foreach ($arr as $item2) {
                            $rand2 = rand32() ?>
                            <div style="border-bottom: 1px solid; padding:  5px">
                                <span style="display: inline-block; width: 40px; color: red">
                                    <?= $item2['method'] ?>
                                </span> |
                                <span style="display: inline-block; min-width: 45px; color: green">
                                    <?= $item2['time_load'] * 1000 ?>мс
                                </span> |
                                <span style="color: blue">
                                    <?= $item2['uri'] ?>
                                </span>

                            </div>
                        <?php } ?>
                    </div>
                </div>
            </div>
        <?php } ?>
    </div>
<?php } ?>

<?php include parts('foot'); ?>