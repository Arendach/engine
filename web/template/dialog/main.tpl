<?php include parts('head') ?>

    <style>
        .switch {
            text-align: center;
            background: aliceblue;
            padding: 15px;
            color: #000;
            font-size: 20px;
            cursor: pointer;
        }

        .select {
            height: 250px;
        }

        #form_crete_dialog {
            background-color: #F0F8FF;
            padding: 10px;
            margin-bottom: 10px;
            margin-top: 10px;
        }

        #form_crete_dialog .select {
            margin-bottom: 10px;
        }
    </style>

    <ol class="breadcrumb breadcrumb-arrow">
        <li><a href="<?= route('index'); ?>"><i class="fa fa-dashboard"></i></a></li>
        <li><a href="#">Мій профіль</a></li>
        <li class="active"><span>Діалоги</span></li>
    </ol>

    <div class="switch">
        Створити діалог
    </div>

    <form id="form_crete_dialog" class="none type-block`">
        <label>Виберіть учасників</label>
        <div class="select">
            <?php foreach (app()->users as $item) {
                if ($item->id != user()->id) { ?>
                    <div data-value="<?= $item->id ?>" class="option">
                        <?= $item->first_name . ' ' . $item->last_name ?>
                    </div>
                <?php } ?>
            <?php } ?>
        </div>

        <div class="form-group">
            <label for="name">Назва діалога</label>
            <input type="text" class="form-control" name="name">
        </div>

        <div class="form-group">
            <label for="message">Повідомлення</label>
            <textarea class="form-control" name="message"></textarea>
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Зберегти</button>
        </div>

    </form>

<?php include t_file('dialog.dialogs_list') ?>

<?php include parts('foot') ?>