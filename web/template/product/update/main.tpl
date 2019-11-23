<?php include parts('head') ?>

    <div class="right" style="margin-top: 15px; margin-bottom: 15px">
        <a href="#" class="btn btn-primary copy">Копіювати</a>
        <?php if ($product->archive == 0) { ?>
            <a href="<?= uri('product', ['section' => 'to_archive', 'id' => $product->id]); ?>" class="btn btn-primary">В
                архів</a>
        <?php } else { ?>
            <a href="<?= uri('product', ['section' => 'un_archive', 'id' => $product->id]); ?>" class="btn btn-primary">Вернути
                з архіву</a>
        <?php } ?>
    </div>

    <ul class="nav nav-pills nav-justified" style="margin-bottom: 15px">
        <li class="active"><a href="#info" data-toggle="tab">Інформація</a></li>
        <li><a href="#photo" data-toggle="tab">Фото</a></li>

        <li><a href="#storage" data-toggle="tab">Склад</a></li>

        <?php if ($product->combine) { ?>
            <li><a href="#combine" data-toggle="tab">Компоненти</a></li>
        <?php } ?>

        <li><a href="#attributes" data-toggle="tab">Атрибути</a></li>
        <li><a href="#characteristics" data-toggle="tab">Характеристики</a></li>
        <li><a href="#seo" data-toggle="tab">SEO</a></li>
    </ul>

    <hr>

    <div class="tab-content">
        <div class="tab-pane active" id="info">
            <?php include t_file('product.update.info') ?>
        </div>

        <div class="tab-pane form-horizontal" id="photo">
            <?php include t_file('product.update.photo') ?>
        </div>

        <div class="tab-pane" id="storage">
            <?php include t_file('product.update.storage') ?>
        </div>

        <?php if ($product->combine) { ?>
            <div class="tab-pane" id="combine">
                <?php include t_file('product.update.combine') ?>
            </div>
        <?php } ?>

        <div class="tab-pane" id="attributes">
            <?php include t_file('product.update.attributes') ?>
        </div>

        <div class="tab-pane" id="characteristics">
            <?php include t_file('product.update.characteristics') ?>
        </div>

        <div class="tab-pane" id="seo">
            <?php include t_file('product.update.seo') ?>
        </div>
    </div>

    <script>
        id = '<?=$product->id;?>';
    </script>
<?php include parts('foot'); ?>