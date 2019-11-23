<?php include parts('head') ?>

    <style>
        .log_block{
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 10px;
            padding: 10px;
        }

        .log_block:hover{
            background-color: #eee;
            border: 1px solid #999;
        }

        .user_name{
            font-weight: bold;
            color: #0f74a8;
        }

        .errors{
            padding-left: 25px;
        }
    </style>

<?php if (my_count($logs) > 0){ ?>

    <div class="right" style="margin-bottom: 15px;">
        <a target="_blank" href="<?= uri('server/logs/new_post.json') ?>" class="btn btn-primary">Оригінал файл логів</a>
    </div>

    <?php foreach ($logs as $log) { ?>
        <div class="log_block">
            <div>
                <span class="user_name">
                    Менеджер: <?= user($log->manager)->login ?>
                </span><br>
                <span>
                    Час: <?= date('H:i:s', strtotime($log->date)) ?>
                </span><br>
                <span>
                    Замовлення: <a href="<?= uri('orders', ['section' => 'update', 'id' => $log->order_id]) ?>">
                        № <?= $log->order_id ?>
                    </a>
                </span>
            </div>
            <hr style="margin: 3px;">
            <?php foreach ($log->errorCodes as $item) { ?>
                <div class="text-warning errors">
                    <?= $tool_log->getTextByCode($item) ?>
                </div>
            <?php } ?>
        </div>
    <?php } ?>
<?php } else { ?>
    <h4 class="centered">Тут пусто :(</h4>
<?php } ?>

<?php include parts('foot') ?>