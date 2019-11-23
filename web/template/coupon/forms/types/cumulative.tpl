<div class="form-group">
    <label for="discount">Куплено по карті</label>
    <input class="form-control" name="discount" id="discount" value="<?= $coupon->discount; ?>">
</div>
<div class="form-group">
    <label>Накопичення</label>
    <div class="centered" style="margin: 10px 0">
        <button class="plus btn btn-success">
            <span class="glyphicon glyphicon-plus"></span> Додати нове поле
        </button>
    </div>
    <table class="table table-bordered" id="asd">
        <tr>
            <td>Сума(грн)</td>
            <td>Оператор</td>
            <td>Знижка</td>
            <td>Тип</td>
            <td>Дія</td>
        </tr>
        <?php foreach($cumulative as $item) { ?>
            <tr id="row-<?= $item->id;?>" class="rows">
                <td><input data-name="sum" class="cumulative" value="<?= $item->sum;?>"></td>
                <td>
                    <select data-name="operator" class="cumulative">
                        <option <?= $item->operator == 0 ? 'selected' : '';?> value="0"><</option>
                        <option <?= $item->operator == 1 ? 'selected' : '';?> value="1">=</option>
                        <option <?= $item->operator == 2 ? 'selected' : '';?> value="2">></option>
                    </select>
                </td>
                <td><input data-name="discount" class="cumulative" value="<?= $item->discount; ?>"></td>
                <td>
                    <select data-name="type" class="cumulative">
                        <option <?= $item->type == 0 ? 'selected' : '';?> value="0">%</option>
                        <option <?= $item->type == 1 ? 'selected' : '';?> value="1">грн</option>
                    </select>
                </td>
                <td class="action-1">
                    <button class="del_row btn btn-xs btn-danger"><span class="glyphicon glyphicon-remove"></span></button>
                </td>
            </tr>
        <?php } ?>
    </table>
</div>