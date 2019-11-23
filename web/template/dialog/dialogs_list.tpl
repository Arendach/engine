<?php if (my_count($dialogs) > 0) { ?>
    <?php foreach ($dialogs as $dialog) {
        $active = $dialog->dialog_id == get('dialog_id') ? ' dialog-active' : '';
        $read = in_array($dialog->dialog_id, $not_read) ? ' dialog-not-read' : '';
        ?>
        <div class="media dialog-media<?= $active . $read ?>"
             href="<?= uri('dialog') . parameters(['section' => 'view', 'dialog_id' => $dialog->dialog_id]) ?>">
            <a class="pull-left"><img class="media-object" src="<?= asset('images/dialogs.png') ?>" width="64px"></a>
            <div class="media-body">
                <h4 class="media-heading"><?= $dialog->name ?></h4>
                <?php if ($dialog->data != '') { ?>
                    <?php if ($dialog->user_id != user()->id) { ?>
                        <b><?= app()->users[$dialog->user_id]->first_name . ' ' . app()->users[$dialog->user_id]->last_name ?></b>
                        <br>
                    <?php } ?>

                    <?php if ($dialog->type == 'text') { ?>
                        <?= strlen($dialog->data) > 300 ? substr($dialog->data, 0, 300) . '...' : $dialog->data ?>
                    <?php } elseif ($dialog->type == 'photo') { ?>
                        <span class="text-primary"><b>Фотографія</b></span>
                    <?php } elseif ($dialog->type == 'youtube') { ?>
                        <span class="text-primary"><b>Відео</b></span>
                    <?php } elseif ($dialog->type == 'file') { ?>
                        <span class="text-primary"><b>Файл</b></span>
                    <?php } ?>
                <?php } else { ?>
                    <span class="text-danger">Бесіда порожня!!!</span>
                <?php } ?>
            </div>
        </div>
    <?php } ?>
<?php } else { ?>
    <div class="text-danger centered">
        Список діалогів порожній
    </div>
<?php } ?>