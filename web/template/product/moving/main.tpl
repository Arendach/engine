<?php include parts('head') ?>

    <style>
        .product_item_s:hover {
            cursor: pointer;
            background-color: #eee;
        }

        #place_products{
            margin-top: 15px;
        }
        #place_products button {
            position: absolute;
            top:0;
            right: 0;
        }
        #place_products div{
            border: 1px solid #ccc;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 4px;
            position: relative;
        }
    </style>

    <div class="right" style="margin-bottom: 15px;">
        <button data-type="get_form"
                data-action="create_moving_form"
                data-uri="<?= uri('product') ?>"
                class="btn btn-primary">
            Нове переміщення
        </button>
    </div>

<?php if (my_count($moving) > 0) { ?>

    <table class="table table-bordered">
        <tr>
            <th>Дата</th>
            <th>З складу</th>
            <th>На склад</th>
            <th>Передав</th>
            <th>Отримав</th>
            <th>Статус</th>
            <th class="centered action-1">Дії</th>
        </tr>
        <?php foreach ($moving as $item) { ?>
            <tr>
                <td><?= date_for_humans($item->date) ?></td>
                <td><i style="color: green"><?= $item->sf_name ?></i></td>
                <td><i style="color: blue"><?= $item->st_name ?></i></td>
                <td>
                    <a href="<?= uri('user', ['section' => 'view', 'id' => $item->user_from]) ?>">
                        <?= $item->uf_login ?>
                    </a>
                </td>
                <td>
                    <a href="<?= uri('user', ['section' => 'view', 'id' => $item->user_to]) ?>">
                        <?= $item->ut_login ?>
                    </a>
                </td>
                <td>
                    <?= $item->status ? '<b style="color: green">Виконано</b>' : '<b style="color: blue">В обробці</b>' ?>
                </td>
                <td class="centered action-1">
                    <a target="_blank" href="<?= uri('product', ['section' => 'print_moving', 'id' => $item->id]) ?>"
                       class="btn btn-primary btn-xs">
                        <i class="fa fa-print"></i>
                    </a>
                </td>
            </tr>
        <?php } ?>
    </table>
    
    <div class="centered">
        <? \Web\App\NewPaginate::display() ?>
    </div>

<?php } else { ?>
    <h4 class="centered">Тут пусто :(</h4>
<?php } ?>

<?php include parts('foot') ?>