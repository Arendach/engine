<div class="new_product_block form-group">
    <div class="search_product">

        <div class="mini-block row" style="margin-bottom: 10px">

            <div class="col-md-4">
                <input id="search_ser_code" placeholder="Сервісний код" class="form-control input-md">
            </div>

            <div class="col-md-4">
                <label for="categories_pr"></label>
                <select id="categories_pr" class="col-md-4 form-control">
                    <option value="0"></option>
                    <?= $categories ?>
                </select>
            </div>

            <div class="col-md-4">
                <input id="search_name" placeholder="Назва" class="form-control input-md">
            </div>
        </div>

        <div id="place_for_search">
            <table class="table-bordered table"></table>
        </div>

    </div>

    <button class="btn btn-primary" id="select_products">Вибрати</button>
</div>