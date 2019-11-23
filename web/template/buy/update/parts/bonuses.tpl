<form action="<?= uri('orders') ?>" data-type="ajax">

    <input type="hidden" name="action" value="create_user_bonus">
    <input type="hidden" name="order_id" value="<?= $order->id ?>">

    <div class="form-group">
        <label><input <?= $order->liable != user()->id ? 'disabled' : '' ?> checked type="radio" name="type" value="bonus"> Бонус </label><br>
        <label><input <?= $order->liable != user()->id ? 'disabled' : '' ?> type="radio" name="type" value="fine"> Штраф </label>
    </div>

    <div class="form-group">
        <label>Співробітник</label>
        <select <?= $order->liable != user()->id ? 'disabled' : '' ?> class="form-control" name="user_id" required>
            <option value=""></option>
            <?php foreach (Web\App\Model::findAll('users', 'archive = 0') as $item) { ?>
                <?php if (!isset($bonuses->{$item->id})) { ?>
                    <option value="<?= $item->id ?>">
                        <?= $item->first_name . ' ' . $item->last_name ?>
                    </option>
                <?php } ?>
            <?php } ?>
        </select>
    </div>

    <div class="form-group">
        <label for="sum">Сума</label>
        <input <?= $order->liable != user()->id ? 'disabled' : '' ?> class="form-control" name="sum" required pattern="[0-9\.]+" data-inspect="decimal">
    </div>

    <div class="form-group">
        <button <?= $order->liable != user()->id ? 'disabled' : '' ?> class="btn btn-primary">Зберегти</button>
    </div>
</form>

<?php if (my_count($bonuses) > 0) { ?>
    <table class="table table-bordered">
        <tr>
            <td><b>Співробітник</b></td>
            <td><b>Сума</b></td>
            <td><b>Бонус/Штраф</b></td>
            <td><b>Дата</b></td>
            <td class="action-2"><b>Дії</b></td>
        </tr>
        <?php foreach ($bonuses as $bonus) { ?>
            <?php $color = $bonus->type == 'bonus' ? 'rgba(0,255,0,.1)' : 'rgba(255,0,0,.1)' ?>
            <tr style="background-color: <?= $color ?>  ">
                <td><?= $bonus->first_name . ' ' . $bonus->last_name ?></td>
                <td><?= $bonus->sum ?></td>
                <td><?= $bonus->type == 'bonus' ? 'Бонус' : 'Штраф' ?></td>
                <td><?= date_for_humans($bonus->date) ?></td>
                <td class="action-2">
                    <button data-type="get_form"
                            data-uri="<?= uri('orders') ?>"
                            data-action="update_bonus_form"
                            data-post="<?= params(['id' => $bonus->id]) ?>"
                            class="btn btn-xs btn-primary"
                            title="Редагувати">
                        <span class="glyphicon glyphicon-pencil"></span>
                    </button>

                    <button data-type="delete"
                            data-uri="<?= uri('orders') ?>"
                            data-action="delete_bonus"
                            data-id="<?= $bonus->id ?>"
                            class="delete_bonus btn btn-xs btn-danger"
                            title="Видалити">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>
<?php } ?>




