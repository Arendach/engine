<?php include parts('head') ?>

    <div class="right" style="margin-bottom: 15px">
        <a href="<?= uri('inventory', ["section" => "create"]) ?>" class="btn btn-primary">Додати</a>
    </div>


    <table class="table table-bordered">
        <tr>
            <td><b>Дата</b></td>
            <td><b>Виробник</b></td>
            <td><b>Підкоректовано</b></td>
            <td><b>Коментар</b></td>
            <td class="action-1"><b>Дії</b></td>
        </tr>
        <?php foreach ($items as $item) { ?>
            <tr>
                <td>
                    <?= date_for_humans($item->date) ?>
                </td>

                <td>
                    <?= $item->manufacturer_name ?>
                </td>

                <td>
                    <?= $item->count_products ?>
                </td>

                <td>
                    <?= $item->comment ?>
                </td>

                <td>
                    <a href="<?= uri('inventory', ['section' => 'print', 'id' => $item->id]) ?>"
                       class="btn btn-primary btn-xs">
                        <span class="glyphicon glyphicon-eye-open"></span>
                    </a>
                </td>

            </tr>
        <?php } ?>
    </table>

    <div class="centered">
        <?php \Web\App\NewPaginate::display() ?>
    </div>


<?php include parts('foot') ?>