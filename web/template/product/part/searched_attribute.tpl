<div class="panel panel-default attribute_item">
    <div class="panel-heading">
        <h4 class="panel-title relative">
            <a data-toggle="collapse" data-parent="#attribute_list"
               href="#collapse<?= $attribute->id ?>">
                <?= $attribute->name ?>
            </a>
            <span class="delete_attribute pointer" style="position: absolute; right: 0;">
                <i class="fa fa-remove"></i>
            </span>
        </h4>
    </div>
    <div id="collapse<?= $attribute->id ?>"
         class="panel-collapse collapse in">
        <div class="panel-body">
            <?php foreach ([0,1] as $i) { ?>
                <div class="row">
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-addon">
                                <img src="<?= asset('icons/uk.ico') ?>" alt="">
                            </span>
                            <input  class="attribute form-control" name="attributes[<?= $attribute->id ?>][][value]">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-addon">
                                <img src="<?= asset('icons/ru.ico') ?>" alt="">
                            </span>
                            <input class="attribute form-control" name="attributes[<?= $attribute->id ?>][][value_ru]">
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
