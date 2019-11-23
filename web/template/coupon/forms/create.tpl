<?php include parts('modal_head'); ?>

    <form id="create_coupon">

        <div class="form-group">
            <label for="code">Код <span title="Для вказання діапазону введіть наприклад: '1000-2304' БЕЗ ПРОБІЛІВ!" data-toggle="tooltip" class="hint">?</span></label>
            <input required id="code" class="form-control input-sm" name="code">
        </div>

        <div class="form-group">
            <label for="type_coupon">Тип</label>
            <select required id="type_coupon" class="form-control input-sm" name="type_coupon">
                <option selected value="" class="none"></option>
                <option value="0">Стаціонарний</option>
                <option value="1">Накопичувальний</option>
            </select>
        </div>

        <div id="for-form"></div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>
    </form>

<?php include parts('modal_foot'); ?>