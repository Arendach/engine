<!-- Пошук товарів -->

<div class="order_search_products">
    <div class="row">
        <div class="col-md-8">
            <input id="search_field" data-search="field" placeholder="Почніть вводити" class="form-control input-md">
        </div>
        <div class="col-md-4">
            <select id="search_category" data-search="category" class="col-md-4 form-control">
                <option value="0">Пошук по категорії</option>
                <?= $categories ?>
            </select>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div style="height: 200px" class="products select"></div>
        </div>
    </div>
</div>

<!-- Таблиця товарів -->

<div class="order_search_products">
    <table id="product-list" class="table table-bordered">
        <thead>
        <th>Товар</th>
        <th>Склад</th>
        <th>Кількість</th>
        <th>Вартість</th>
        <th style="width: 71px">Сума</th>
        <th>Атрибути</th>
        <?= $type != 'sending' ?: '<th>Місце</th>' ?>
        <th style="width: 39px">Дії</th>
        </thead>
        <tbody></tbody>
    </table>
</div>

<div class="form-horizontal" style="margin-top: 15px;">

    <div class="form-group">
        <label class="col-md-4 control-label">Вартість доставки</label>
        <div class="col-md-5">
            <input id="delivery_cost" name="delivery_cost" class="form-control count" data-inspect="decimal">
        </div>
    </div>

    <div class=" form-group">
        <label class="col-md-4 control-label">Знижка</label>
        <div class="col-md-5">
            <input id="discount" name="discount" class="form-control count" data-inspect="decimal">
        </div>
    </div>

    <div class="form-group">
        <label class="col-md-4 control-label">Вартість товарів</label>
        <div class="col-md-5">
            <input disabled id="sum" class="form-control" data-inspect="decimal">
        </div>
    </div>

    <div class="form-group">
        <label class="col-md-4 control-label">Сума</label>
        <div class="col-md-5">
            <input disabled id="full_sum" class="form-control" data-inspect="decimal">
        </div>
    </div>

    <div class="form-group">
        <div class="col-md-offset-4 col-md-5">
            <button id="create" class="btn btn-primary">Зберегти</button>
        </div>
    </div>

</div>