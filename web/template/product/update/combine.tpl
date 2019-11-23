<form action="<?= uri('product') ?>" data-type="ajax" class="edit-block form-horizontal">
    <input type="hidden" name="action" value="update_combine">
    <input type="hidden" name="id" value="<?= $product->id ?>">

    <div class="form-group">
        <label for="search_products_to_combine" class="col-md-4 control-label">Пошук товарів для звязки</label>
        <div class="col-md-5">
            <div class="input-group">
                <input id="search_products_to_combine" class="form-control">
                <span class="input-group-addon pointer" id="close_search_combine_result">
                        <i class="fa fa-remove"></i>
                    </span>
            </div>

            <div style="margin-bottom: 15px" class="search_combine_result list-group"></div>
        </div>

        <div class="col-md-offset-4 col-md-5">
            <div class="combine_products_list">
                <?php if (my_count($combine_products) > 0) include t_file('product.part.combine_products') ?>
            </div>
        </div>
    </div>

    <div class="form-group">
        <label for="costs" class="col-md-4 control-label">Ціна товару</label>
        <div class="col-md-5">
            <input value="<?= $product->costs; ?>" name="costs" class="form-control">
        </div>
    </div>

    <div class="form-group">
        <div class="col-md-offset-4 col-md-5">
            <button class="btn btn-primary">Зберегти</button>
        </div>
    </div>
</form>