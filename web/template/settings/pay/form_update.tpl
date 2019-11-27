<?php include parts('modal_head'); ?>

    <form data-type="ajax" action="<?= uri('settings') ?>">

        <input type="hidden" name="id" value="<?= $pay->id; ?>">
        <input type="hidden" name="action" value="pay_update">

        <div class="form-group">
            <label for="name"><span class="text-danger">*</span> Назва</label>
            <input name="name" id="name" class="form-control" value="<?= $pay->name; ?>">
        </div>

        <div class="form-group">
            <label>Мерчант</label>
            <select name="merchant_id" class="form-control">
                <option <?= ($pay->merchant_id == null) ? 'selected' : '' ?> value="">
                    Немає
                </option>
                <?php foreach ($merchants as $merchant) { ?>
                    <option <?= ($merchant->id == $pay->merchant_id) ? 'selected' : '' ?> value="<?= $merchant->id ?>">
                        <?= $merchant->name ?>
                    </option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label>Безготівковий розрахунок</label>
            <select name="is_cashless" class="form-control">
                <option <?= !$pay->is_cashless ? 'selected' : '' ?> value="0">Ні</option>
                <option <?= $pay->is_cashless ? 'selected' : '' ?> value="1">Так</option>
            </select>
        </div>

        <div class="form-group">
            <label>Являється платником податків</label>
            <select name="is_pdv" class="form-control">
                <option <?= !$pay->is_pdv ? 'selected' : '' ?> value="0">Ні</option>
                <option <?= $pay->is_pdv ? 'selected' : '' ?> value="1">Так</option>
            </select>
        </div>

        <div class="form-group">
            <label>Постачальник</label>
            <input name="provider" class="form-control" value="<?= $pay->provider ?>">
        </div>


        <div class="form-group">
            <label>Адреса</label>
            <input name="address" class="form-control" value="<?= $pay->address ?>">
        </div>

        <div class="form-group">
            <label>ІПН</label>
            <input name="ipn" class="form-control" value="<?= $pay->ipn ?>">
        </div>

        <div class="form-group">
            <label>Розрахунковий рахунок</label>
            <input name="account" class="form-control" value="<?= $pay->account ?>">
        </div>


        <div class="form-group">
            <label>Банк</label>
            <input name="bank" class="form-control" value="<?= $pay->bank ?>">
        </div>


        <div class="form-group">
            <label>МФО</label>
            <input name="mfo" class="form-control" value="<?= $pay->mfo ?>">
        </div>


        <div class="form-group">
            <label>Тел./факс</label>
            <input name="phone" class="form-control" value="<?= $pay->phone ?>">
        </div>


        <div class="form-group">
            <label>Директор</label>
            <input name="director" class="form-control" value="<?= $pay->director ?>">
        </div>


        <div class="form-group" style="margin-bottom: 0">
            <button class="btn btn-primary">Зберегти</button>
        </div>

    </form>

<?php include parts('modal_foot'); ?>