<form class="form-horizontal" data-type="ajax" action="<?= uri('product') ?>">
    <input type="hidden" name="id" value="<?= $product->id ?>">
    <input type="hidden" name="action" value="update_attribute">

    <div class="edit-block">
        <div class="form-group">
            <label class="col-md-2 control-label">Атрибути:</label>

            <div class="col-md-8">
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-search"></i></span>
                    <input id="search_attribute" class="form-control" placeholder="Пошук атрибутів">
                    <span class="input-group-addon pointer close_attribute_search_result">
                        <i class="fa fa-remove"></i>
                    </span>
                </div>

                <div style="margin-bottom: 0;" class="list-group attribute_search_result"></div>
            </div>
        </div>

        <div class="form-group">
            <div class="col-md-offset-2 col-md-8">
                <div class="panel-group" id="attribute_list" style="margin-bottom: 0;">
                    <?php if (my_count($attributes) > 0) { ?>
                        <?php $c = 0;
                        foreach ($attributes as $item) { ?>
                            <div class="panel panel-default attribute_item">
                                <div class="panel-heading">
                                    <h4 class="panel-title relative">
                                        <a data-toggle="collapse" data-parent="#attribute_list"
                                           href="#collapse<?= $c ?>">
                                            <?= $item->name ?>
                                        </a>
                                        <span class="delete_attribute pointer" style="position: absolute; right: 0;">
                                            <i class="fa fa-remove"></i>
                                        </span>
                                    </h4>
                                </div>
                                <div id="collapse<?= $c ?>"
                                     class="panel-collapse collapse <?= !$c ? 'in' : '' ?>">
                                    <div class="panel-body">
                                        <?php foreach ($item->variants as $variant) { ?>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="input-group">
                                                        <span class="input-group-addon">
                                                            <img src="<?= asset('icons/uk.ico') ?>" alt="">
                                                        </span>
                                                        <input value="<?= $variant->value ?>"
                                                               class="attribute form-control"
                                                        name="attributes[<?= $item->attribute_id ?>][][value]">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="input-group">
                                                        <span class="input-group-addon">
                                                        <img src="<?= asset('icons/ru.ico') ?>" alt="">
                                                    </span>
                                                        <input value="<?= $variant->value_ru ?>"
                                                               class="attribute form-control"
                                                               name="attributes[<?= $item->attribute_id ?>][][value_ru]">
                                                        <span class="input-group-addon pointer delete_attribute_variant">
                                                        <i class="fa fa-remove"></i>
                                                    </span>
                                                    </div>
                                                </div>
                                            </div>
                                        <?php } ?>
                                        <br>
                                        <a class="add_attribute_value" href="#">Додати значення</a>
                                    </div>
                                </div>
                            </div>
                            <?php $c++;
                        } ?>
                    <?php } ?>
                </div>
            </div>
        </div>


        <div class="form-group">
            <div class="col-md-offset-2 col-md-8">
                <button class="btn btn-primary">Оновити</button>
            </div>
        </div>
    </div>

</form>