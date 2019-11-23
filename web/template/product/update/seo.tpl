<div class="row">
    <div class="col-md-offset-4 col-md-5">
        <ul class="nav nav-tabs nav-justified">
            <li class="active">
                <a href="#seo_uk" data-toggle="tab">
                    <img src="<?= asset('icons/uk.ico') ?>">
                </a>
            </li>
            <li>
                <a href="#seo_ru" data-toggle="tab">
                    <img src="<?= asset('icons/ru.ico') ?>">
                </a>
            </li>
        </ul>
    </div>
</div>

<br>
<form action="<?= uri('product') ?>" class="form-horizontal" data-type="ajax">
    <input type="hidden" name="action" value="update_seo">
    <input type="hidden" name="id" value="<?= $product->id ?>">

    <div class="tab-content">
        <?php foreach (['uk', 'ru'] as $item) { ?>
            <div class="tab-pane<?= $item == 'uk' ? ' active' : '' ?>" id="seo_<?= $item ?>">
                <div class="form-group">
                    <label class="col-md-4 control-label">Заголовок (Title)</label>
                    <div class="col-md-5">
                        <input class="form-control" name="meta_title_<?= $item ?>"
                               value="<?= $product->{"meta_title_$item"} ?>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-4 control-label">Ключові слова (Keywords)</label>
                    <div class="col-md-5">
                        <input class="form-control" name="meta_keywords_<?= $item ?>"
                               value="<?= $product->{"meta_keywords_$item"} ?>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-4 control-label">Опис сторінки (Description)</label>
                    <div class="col-md-5">
                        <input class="form-control" name="meta_description_<?= $item ?>"
                               value="<?= $product->{"meta_description_$item"} ?>">
                    </div>
                </div>
            </div>
        <?php } ?>
    </div>

    <div class="form-group">
        <div class="col-md-offset-4 col-md-5">
            <button class="btn btn-sm btn-primary">Зберегти</button>
        </div>
    </div>
</form>