<?php include parts('head'); ?>

    <ol class="breadcrumb breadcrumb-arrow">
        <li><a href="<?= route('index'); ?>"><i class="fa fa-dashboard"></i></a></li>
        <li><a href="<?= uri('dialog') ?>">Діалоги</a></li>
        <li class="active"><span><?= $dialog->name ?></span></li>
    </ol>

    <div class="row">
        <div class="col-md-4">
            <div>
                <!-- Навигация -->
                <ul class="nav nav-tabs" role="tablist">
                    <li class="active"><a href="#text" aria-controls="text" role="tab" data-toggle="tab">Текст</a></li>
                    <li><a href="#photo" aria-controls="photo" role="tab" data-toggle="tab">Фото</a></li>
                    <li><a href="#file" aria-controls="file" role="tab" data-toggle="tab">Файл</a></li>
                    <li><a href="#youtube" aria-controls="youtube" role="tab" data-toggle="tab">Ютуб-відео</a></li>
                </ul>
                <!-- Содержимое вкладок -->
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane active" id="text">
                        <?php include t_file('dialog.forms.text') ?>
                    </div>
                    <div role="tabpanel" class="tab-pane" id="photo">
                        <?php include t_file('dialog.forms.photo') ?>
                    </div>
                    <div role="tabpanel" class="tab-pane" id="file">
                        <?php include t_file('dialog.forms.file') ?>
                    </div>
                    <div role="tabpanel" class="tab-pane" id="youtube">
                        <?php include t_file('dialog.forms.youtube') ?>
                    </div>
                </div>
            </div>
            <?php if ($dialog->created_id == user()->id){
                include t_file('dialog.dialog_settings');
            } ?>

            <?php include t_file('dialog.dialogs_list') ?>
        </div>

        <div class="col-md-8">
            <div id="message-wrap">
                <?php foreach ($messages as $message) {
                    include t_file('dialog.message_types.' . $message->type);
                } ?>
            </div>
        </div>
    </div>

<?php include parts('foot') ?>