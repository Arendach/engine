<?php use Web\Tools\HTML; ?>

<?php include parts('head') ?>

<style>
    input, select {
        width: 100%;
        max-height: 17px;
    }

    .pts_more_item {
        position: absolute;
        border: 1px solid black;
        border-radius: 10px 10px 0 10px;
        padding: 10px;
        background-color: #ccc;
        right: 7px;
        bottom: 10px;
        width: 400px;
    }
</style>

<div class="right" style="margin-bottom: 10px">
    <button class="btn btn-success more">Додатково</button>
    <?php if (get('name') || get('combine') || get('category') || get('manufacturer') || get('identefire_storage') || get('costs') || get('articul')) { ?>
        <button class="btn btn-primary print_products">Друкувати</button>
    <?php } ?>
    <a href="<?= uri('product', ['section' => 'moving']) ?>" class="btn btn-primary">Переміщення</a>
    <a href="<?= uri('product', ['section' => 'create']) ?>" class="btn btn-primary">Додати</a>
</div>

<div class="filters none" style="margin-bottom: 15px; border: 1px solid #ccc;padding: 10px">
    <div>
        <button class="btn btn-primary print_tick">Друкувати цінник</button>
        <button class="btn btn-primary print_stickers">Друкувати наклейки</button>
    </div>
    <hr>
    <div class="form-group">
        <label>Кількість пунктів на сторінку</label>
        <input class="form-control" name="items" style="max-height: 34px"
               value="<?= get('items') ? get('items') : ITEMS ?>">
    </div>

    <div class="form-group" style="margin-bottom: 0">
        <button class="btn btn-primary filters_ok">Задіяти</button>
    </div>
</div>

<div style="margin-bottom: 15px; border: 1px solid #ccc;padding: 10px">
    Сума товарів: <span class="text-primary"><?= number_format($sum, 2) ?>$</span>
</div>

<div class="table-responsive">
    <table class="table table-striped table-bordered" cellspacing="0" width="100%">
        <thead class="head-center">
        <tr>

            <th>
                <span data-parent="table" class="checkbox check_all"> Назва</span> <br><br>
                <input data-action="search" data-column="name" value="<?= get('name'); ?>">
            </th>

            <th>
                Облік
                <br><br>
                <select data-action="search" data-column="accounted">
                    <option value=""></option>
                    <option <?= isset($_GET['accounted']) && $_GET['accounted'] == 1 ? 'selected' : '' ?> value="1">
                        Так
                    </option>
                    <option <?= isset($_GET['accounted']) && $_GET['accounted'] == 0 ? 'selected' : '' ?> value="0">
                        Ні
                    </option>
                </select>
            </th>

            <th>
                Тип<br><br>
                <select data-action="search" data-column="combine">
                    <option value=""></option>
                    <option <?= isset($_GET['combine']) && $_GET['combine'] == 1 ? 'selected' : '' ?> value="1">
                        Комбіновані
                    </option>
                    <option <?= isset($_GET['combine']) && $_GET['combine'] == 0 ? 'selected' : '' ?> value="0">
                        Одиничні
                    </option>
                </select>
            </th>

            <th>
                Категорія<br><br>
                <select data-action="search" data-column="category">
                    <?php if (get('category')) { ?>
                        <option value="<?= get('category') ?>" class="none"><?= $category_name ?></option>
                    <?php } ?>
                    <option value=""></option>
                    <?= $category ?>
                </select>
            </th>

            <th>
                Виробник<br><br>
                <select data-action="search" data-column="manufacturer">
                    <option value=""></option>
                    <?php foreach ($manufacturers as $item) { ?>
                        <option value="<?= $item->id ?>" <?= get('manufacturer') == $item->id ? 'selected' : '' ?>>
                            <?= $item->name ?>
                        </option>
                    <?php } ?>
                </select>
            </th>

            <th>
                Артикул <br><br>
                <input data-action="search" data-column="articul" value="<?= get('articul'); ?>">
            </th>

            <th>Ід.складу <br><br>
                <input data-action="search" data-column="identefire_storage" value="<?= get('identefire_storage') ?>">
            </th>

            <th>
                <a class="sort" data-by="<?= HTML::order_by('costs') ?>" data-field="costs" href="#">
                    Ціна <?= HTML::order_by_sym('costs') ?>
                </a>
                <br><br>
                <input data-action="search" data-column="products-costs" value="<?= get('products-costs'); ?>">
            </th>

            <th>
                На доставці
            </th>

            <th>
                На складі
            </th>

            <th>
                Дія
                <br><br>
                <button class="btn btn-primary" id="search">
                    <span class="glyphicon glyphicon-search"></span>
                </button>
            </th>
        </tr>
        </thead>
        <tbody id="tableProduct">
        <?php if (isset($empty_search) && $empty_search == true) { ?>
            <tr>
                <td colspan="10"><?php echo $search_not_found ?></td>
            </tr>
        <?php } ?>

        <?php if (isset($products) && my_count($products) > 0) {
            foreach ($products as $item) { ?>
                <tr>
                    <td><span data-value="<?= $item->id ?>" class="checkbox product_item">  <?= $item->name ?></span></td>
                    <td><?= $item->combine ? 'Ні' : ($item->accounted ? 'Так' : 'Ні') ?></td>
                    <td><?= $item->combine ? 'Комбінований' : 'Одиничний' ?></td>
                    <td><?= $item->category_name ?></td>
                    <td><?= $item->manufacturer_name ?></td>
                    <td><?= $item->articul ?></td>
                    <td><?= $item->identefire_storage ?></td>
                    <td><?= $item->costs ?></td>
                    <td><?= !empty($item->delivery_count) ? $item->delivery_count : '0' ?></td>
                    <td>
                        <?php if ($item->count_on_storage != 0) { ?>
                            <b data-id="<?= $item->id ?>" style="color: blue" class="relative pts_more pointer">
                                <span class="pts_more_<?= $item->id ?> none pts_more_item"></span><?= $item->count_on_storage ?>
                            </b>
                        <?php } else { ?>
                            0
                        <?php } ?>
                    </td>
                    <td class="action-2">
                        <a class="btn btn-primary btn-xs"
                           href="<?= uri('product', ['section' => 'update', 'id' => $item->id]) ?>">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </a>
                        <a class="btn btn-primary btn-xs"
                           href="<?= uri('product', ['section' => 'history', 'id' => $item->id]) ?>">
                            <span class="glyphicon glyphicon-time"></span>
                        </a>
                    </td>
                </tr>
            <?php } ?>
        <?php } else { ?>
            <tr>
                <td colspan="11" class="centered"><h4 class="text-muted">Нічого не знайдено :(</h4></td>
            </tr>
        <?php } ?>
        </tbody>

    </table>
</div>

<!-- Paginate -->

<div class="centered">
    <?php \Web\App\NewPaginate::display() ?>
</div>


<?php include parts('foot') ?>
