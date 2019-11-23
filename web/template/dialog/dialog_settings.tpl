<style>

    .tab_head {
        padding: 10px;
        cursor: pointer;
    }

    .tab_head:hover {
        background-color: #eee;
    }

    .tab_close {
        position: absolute;
        top: 5px;
        right: 0;
        color: red;
        border-radius: 50%;
        padding: 2px;
        cursor: pointer;
    }

    .tab_body {
        background: #eee;
        padding: 10px;
        margin: 0 -15px 0 -15px;
    }

</style>

<div class="row">
    <div class="tab_head col-md-6 centered" data-id="conf_users">
        <i class="fa fa-users"></i>
    </div>
    <div class="tab_head col-md-6 centered" data-id="conf_settings">
        <i class="fa fa-cogs"></i>
    </div>
</div>

<div class="tab_body none" id="conf_users">
    <div class="relative">
        <h3>Учасники бесіди</h3>
        <i class="fa fa-remove tab_close"></i>
    </div>
    <form id="dialog_users">

        <div class="form-group">
            <div class="select" id="dialog_users" style="height: 200px">
                <?php foreach (app()->users as $user) { ?>
                    <div class="option<?= isset($users[$user->id]) ? ' active' : '' ?>"> <?= $user->first_name . ' ' . $user->last_name ?></div>
                <?php } ?>
            </div>
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>
</div>

<div class="tab_body none" id="conf_settings">
    <div class="relative">
        <h3>Налаштування</h3>
        <i class="fa fa-remove tab_close"></i>
    </div>

    <form id="dialog_settings">
        <div class="form-group">
            <label for="name">Назва діалога</label>
            <input type="text" class="form-control" name="name" value="<?= $dialog->name ?>">
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </form>
</div>


