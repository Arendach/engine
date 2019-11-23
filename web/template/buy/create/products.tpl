<!-- Пошук товарів -->

<div class="new_product_block form-group">

    <div style="padding: 10px 15px">
        <select class="form-control" name="storage" id="storage">
            <?php foreach ($storage as $item) { ?>
                <option value="<?= $item->id ?>"><?= $item->name ?></option>
            <?php } ?>
        </select>
    </div>

    <div class="search_product" style="margin-bottom: 10px">
        <div class="col-md-4">
            <input id="search_ser_code" placeholder="Сервісний код" class="form-control input-md">
        </div>
        <div class="col-md-4">
            <select id="categories_pr" class="col-md-4 form-control">
                <option value="0"></option>
                <?= $categories ?>
            </select>
        </div>
        <div class="col-md-4">
            <input id="search_name_product" placeholder="Назва" class="form-control input-md">
        </div>
        <div class="col-md-12">
            <div style="height: 200px" class="products form-control select" id="products"></div>
        </div>
    </div>

    <button type="button" class="btn btn-primary" id="select_products">Вибрати</button>
</div>

<!-- Таблиця товарів -->

<div class="products-order">
    <table id="list_products" class="table table-bordered">
        <thead>
        <th>Назва товару</th>
        <th>Ідентифікатор складу</th>
        <th>Склад</th>
        <th>Артикул</th>
        <th>Кількість</th>
        <th>Вартість</th>
        <th>Сума</th>
        <th>Аттрибути</th>
        <?= $type == 'sending' ? '<th>Номер місця</th>' : '' ?>
        <th>Дії</th>
        </thead>
        <tbody></tbody>
    </table>
</div>

<div class="form-horizontal" style="margin-top: 15px;">

    <div class="form-group">
        <label for="delivery_cost" class="col-md-4 control-label">Ціна за доставку</label>
        <div class="col-md-5">
            <input id="delivery_cost" name="delivery_cost" class="form-control count" data-inspect="decimal">
        </div>
    </div>

    <div class=" form-group">
        <label for="discount" class="col-md-4 control-label">Знижка</label>
        <div class="col-md-5">
            <input id="discount" name="discount" class="form-control count" data-inspect="decimal">
        </div>
    </div>

    <div class="form-group">
        <label for="sum" class="col-md-4 control-label">Ціна за товари</label>
        <div class="col-md-5">
            <input disabled id="sum" class="form-control" data-inspect="decimal">
        </div>
    </div>

    <div class="form-group">
        <label for="full_sum" class="col-md-4 control-label">Сума</label>
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