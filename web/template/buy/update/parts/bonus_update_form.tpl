<?php $title = 'Сума бонусу/штрафу співробітника ' . user($bonus->user_id)->first_name . ' ' . user($bonus->user_id)->last_name ?>
<?php include parts('modal_head') ?>

    <form action="<?= uri('orders') ?>" data-type="ajax">

        <input type="hidden" name="id" value="<?= $bonus->id ?>">
        <input type="hidden" name="action" value="update_bonus_sum">

        <div class="form-group">
            <label for="update_sum">Сума(<?= $bonus->type == 'bonus' ? 'бонусу' : 'штрафу' ?>)</label>
            <input class="form-control" id="update_sum" name="sum" value="<?= $bonus->sum ?>" data-inspect="decimal">
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Зберегти</button>
        </div>

    </form>

<?php include parts('modal_foot') ?>