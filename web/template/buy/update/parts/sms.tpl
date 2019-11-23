<?php

function parse_status($key)
{
    $array = [
        'NEW' => 'Нове повідомлення, ще не було відправлено',
        'ENQUEUD' => 'Минуло модерацію і поставлено в чергу на відправку',
        'ACCEPTD' => 'Відправлено з системи і прийнято оператором для подальшої пересилки одержувачу',
        'UNDELIV' => 'Не доставлено одержувачу',
        'REJECTD' => 'Відхилено оператором по одній з безлічі причин - неправильний номер одержувача, заборонений текст і т.д.',
        'PDLIVRD' => 'Не всі сегменти повідомлення доставлено одержувачу, деякі оператори повертають звіт тільки про перший доставленому сегменті, тому таке повідомлення після закінчення терміну життя перейде в статус Доставлено',
        'DELIVRD' => 'Доставлено одержувачу повністю',
        'EXPIRED' => 'Доставка не вдалася так як закінчився термін життя повідомлення (за замовчуванням 3 доби)',
        'DELETED' => 'Вилучено з-за обмежень і не доставлено до одержувача',
    ];

    return isset($array[$key]) ? $array[$key] : $key;
}

?>

    <form action="<?= uri('sms') ?>" data-type="ajax">

        <input type="hidden" name="action" value="send_message">
        <input type="hidden" name="order_id" value="<?= $order->id ?>">

        <div class="form-group">
            <label for="phone_number">Номер отримувача</label>
            <input type="text" name="phone" id="phone_number" class="form-control" required
                   value="<?= get_number_world_format(get_number($order->phone)) ?>" pattern="\+380[0-9]{9}">
        </div>

        <div class="form-group">
            <label for="sms_template">Шаблон</label>
            <select id="sms_template" class="form-control">
                <option value=""></option>
                <?php foreach ($sms_templates as $item): ?>
                    <option value="<?= $item->id ?>"><?= $item->name ?></option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="form-group">
            <label for="text">Повідомлення</label>
            <textarea id="text" name="text" class="form-control" required></textarea>
        </div>


        <div class="form-group">
            <button id="send_message" class="btn btn-primary">Відправити</button>
        </div>
    </form>

<?php if (my_count($sms) > 0) { ?>
    <h2>Відправлені СМС</h2>

    <table class="table table-bordered">
        <tr>
            <th>Текст</th>
            <th>Телефон</th>
            <th>Дата</th>
            <th>Статус</th>
        </tr>
        <?php foreach ($sms as $item): ?>
            <tr>
                <td><?= $item->text ?></td>
                <td><?= $item->phone ?></td>
                <td><?= $item->date ?></td>
                <td><?= parse_status($item->status) ?></td>
            </tr>
        <?php endforeach; ?>
    </table>

<?php } ?>