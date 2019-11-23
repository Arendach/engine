<form class="form-horizontal" id="update_characteristics" action="<?= uri('product') ?>" data-type="ajax">
    <input type="hidden" name="id" value="<?= $product->id ?>">
    <input type="hidden" name="action" value="update_characteristics">

    <div class="edit-block">
        <div class="form-group">
            <div class="col-md-offset-2 col-md-8">
                <div class="input-group">
                    <span class="input-group-addon">
                        <i class="fa fa-search"></i>
                    </span>
                    <input id="search_characteristic" class="form-control" placeholder="Пошук характеристик">
                    <span class="input-group-addon pointer close_characteristic_search_result">
                        <i class="fa fa-remove"></i>
                    </span>
                </div>

                <div style="margin-bottom: 0;" class="list-group characteristic_search_result"></div>
            </div>
        </div>

        <div class="form-group">
            <div class="col-md-offset-2 col-md-8 characteristics">

                <?php foreach ($characteristics as $characteristic) { ?>
                    <?php include t_file('product.update.characteristics.result') ?>
                <?php } ?>

            </div>
        </div>


        <div class="form-group">
            <div class="col-md-offset-2 col-md-8">
                <button class="btn btn-primary">Оновити</button>
            </div>
        </div>
    </div>

</form>