<div class="form-group">
    <label for="purchased">Куплено по карті</label>
    <input class="form-control input-sm" id="discount" name="discount">
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
        <tr class="rows" id="row1">
            <td><input class="field2" name="sum"></td>
            <td>
                <select name="operator" class="field2">
                    <option value="0"><</option>
                    <option value="1">=</option>
                    <option value="2">></option>
                </select>
            </td>
            <td>
                <input class="field2" name="discount">
            </td>
            <td>
                <select class="field2" name="type">
                    <option value="0">%</option>
                    <option value="1">грн</option>
                </select>
            </td>
            <td>
                <button class="del_row btn btn-danger btn-xs del">
                    <span class="glyphicon glyphicon-remove"></span>
                </button>
            </td>
        </tr>
    </table>
</div>