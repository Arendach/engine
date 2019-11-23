<div class="form-group">
    <label for="usr" class="col-md-4 control-label">Фото:</label>
    <div class="col-md-5">
        <input type="file" class="form-control" id="image_upload">
    </div>
</div>
<div>
    <div class="thumbnail_img col-md-offset-4 col-md-5" style="margin-bottom: 15px">
        <?php if (isset($photos) && my_count($photos) > 0) {
            foreach ($photos as $thumbnail) { ?>
                <div class="img_wrap">
                    <img src="<?= $thumbnail; ?>" class="img-thumbnail">
                    <span data-src="<?= $thumbnail; ?>" data-id="<?= $product->id ?>"
                          class="deleteImg delete_image">X</span>
                </div>
            <?php }
        } ?>
    </div>
</div>
