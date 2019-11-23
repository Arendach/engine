<?php include parts('head') ?>

    <form id="inventory_create">
        <div class="form-group">
            <label for="manufacturer">Виберіть виробника</label>
            <select required id="manufacturer" class="form-control">
                <option  value=""></option>
                <?php foreach ($manufacturers as $item){ ?>
                    <option value="<?= $item->id ?>"><?= $item->name ?></option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label>Виберіть склад</label>
            <select required name="storage" id="storage" class="form-control">
                <option value=""></option>
                <?php foreach ($storage as $item){ ?>
                    <option value="<?= $item->id ?>"><?= $item->name ?></option>
                <?php } ?>
            </select>
        </div>

        <div class="form-group">
            <label>Виберіть категорію</label>
            <select name="category" id="category" class="form-control">
                <option value="0"></option>
                <?= $categories ?>
            </select>
        </div>

        <div class="form-group">
            <button id="find_products" type="button" class="btn btn-primary">Вибрати</button>
        </div>

        <div id="place_for_products"></div>
    </form>

<?php include parts('foot') ?>