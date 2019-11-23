<?php if (!$product->combine) { ?>
    <form action="<?= uri('product') ?>" data-type="ajax" class="edit-block form-horizontal">

        <input type="hidden" name="action" value="update_accounted">
        <input type="hidden" name="id" value="<?= $product->id ?>">

        <div class="form-group">
            <label for="accounted" class="col-md-4 control-label">Обліковувати товар</label>
            <div class="col-md-5">
                <select name="accounted" id="accounted" class="form-control">
                    <option <?= !$product->accounted ? 'selected' : '' ?> value="0">Ні</option>
                    <option <?= $product->accounted ? 'selected' : '' ?> value="1">Так</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <div class="col-md-offset-4 col-md-5">
                <button class="btn btn-primary">Зберегти</button>
            </div>
        </div>
    </form>
<?php } ?>

<form action="<?= uri('product') ?>" id="update_pts" class="form-horizontal edit-block" data-type="ajax">
    <input type="hidden" name="id" value="<?= $product->id ?>">
    <input type="hidden" name="action" value="update_storage">
    <div class="form-group">
        <label class="col-md-4 control-label">Склади</label>
        <div class="col-md-5">
            <?php foreach ($storage as $item) { ?>
                <div class="pts_item">
                        <span data-name="pts[]*"
                              data-key="<?= $item->id ?>"
                              class="checkbox<?= isset($pts[$item->id]) ? ' active' : '' ?>">
                            <?= $item->name ?>
                        </span>
                    <br>
                    <?php if ((isset($pts[$item->id]) && !$product->combine) && (isset($pts[$item->id]) && $product->accounted)) { ?>
                        <span class="text-primary">Кількість:</span> <?= $pts[$item->id]->count ?>
                    <?php } ?>
                </div>
            <?php } ?>
        </div>
    </div>

    <div class="form-group" style="margin-bottom: 15px">
        <div class="col-md-offset-4 col-md-5">
            <button class="btn btn-primary">Оновити</button>
        </div>
    </div>
</form>

