<div class="row">
    <div class="col-md-3">
        <form data-type="ajax" action="<?= uri('orders/upload_file') ?>" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<?= $order->id ?>">

            <div class="form-group">
                <?php \Web\Tools\HTML::file('file', true) ?>
            </div>

            <div class="form-group">
                <button class="btn btn-primary">Завантажити</button>
            </div>
        </form>
    </div>

    <style>
        a.file {
            position: relative;
            display: block;
            border: 1px dashed #ccc;
            padding: 10px;
            margin-bottom: 15px
        }

        a.file:hover {
            background: #eee;
            text-decoration: none;
        }

        .delete_image {
            position: absolute;
            top: 10px;
            right: 15px;
            color: red;
            display: block;
            width: 20px;
            height: 20px;
            text-align: center;
            font-size: 140%;
        }

    </style>

    <div class="col-md-9">
        <?php if ($order->files->count()) { ?>
            <?php foreach ($order->files as $file) { ?>
                <a class="file" href="<?= $file->path ?>">
                    <img style="height: 150px;" src="<?= $file->icon ?>">
                    <div style="margin-left: 15px; display: inline-block">
                        <?= $file->base_name ?> <br>
                        <?= $file->create_date; ?><br>
                        <?= $file->size ?>
                    </div>
                    <span class="delete_image"
                          data-toggle="tooltip"
                          title="Видалити"
                          data-id="<?= $file->id ?>">
                        <i class="fa fa-remove"></i>
                    </span>
                </a>
            <?php } ?>
        <?php } ?>
    </div>

</div>