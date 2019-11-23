<? include parts('head'); ?>

    <div class="right" style="margin-bottom: 15px;">
        <?php if (isset($_GET['archive'])) { ?>
            <a class="btn btn-primary" href="<?= uri('product', ['section' => 'assets']) ?>">Активи</a>
        <?php } else { ?>
            <a class="btn btn-primary" href="<?= uri('product', ['section' => 'assets', 'archive' => '']) ?>">Архів</a>
        <?php } ?>
        <button data-type="get_form"
                data-uri="<?= uri('product') ?>"
                data-action="create_assets_form"
                class="btn btn-primary">
            Новий актив
        </button>
    </div>

<? if (my_count($assets) > 0) { ?>
    <table class="table table-bordered">
        <tr>
            <th>ID</th>
            <th>Назва</th>
            <th>Склад</th>
            <th>Ід. складу</th>
            <th>Опис</th>
            <th>Ціна</th>
            <th>Курс долара</th>
            <th>Придбано</th>
            <th class="action-2 centered">Дії</th>
        </tr>
        <? foreach ($assets as $item) { ?>
            <tr>
                <td><?= $item->id ?></td>
                <td><?= $item->name ?></td>
                <td><?= $item->storage_name ?></td>
                <td><?= $item->id_in_storage ?></td>
                <td><?= $item->description ?></td>
                <td><?= $item->price ?></td>
                <td><?= $item->course ?></td>
                <td><?= date_for_humans($item->date) ?></td>
                <td class="action-2 centered">
                    <?php if (!isset($_GET['archive'])) { ?>
                        <button data-type="get_form" 
                                data-uri="<?= uri('product') ?>"
                                data-action="update_assets_form"
                                data-post="<?= params(['id' => $item->id]) ?>"
                                data-toggle="tooltip"
                                title="Редагувати"
                                class="btn btn-xs btn-primary">
                            <i class="fa fa-pencil"></i>
                        </button>
                    <?php } ?>

                    <?php if (isset($_GET['archive'])) { ?>
                        <button data-type="ajax_request"
                                data-post="<?= params(['id' => $item->id]) ?>"
                                data-action="assets_un_archive"
                                data-toggle="tooltip"
                                title="Вернути з архіву"
                                class="btn btn-xs btn-danger">
                            <i class="fa fa-remove"></i>
                        </button>
                    <?php } else { ?>
                        <button data-type="ajax_request"
                                data-post="<?= params(['id' => $item->id]) ?>"
                                data-action="assets_to_archive"
                                data-toggle="tooltip"
                                title="До архіву"
                                class="btn btn-xs btn-danger">
                            <i class="fa fa-remove"></i>
                        </button>
                    <?php } ?>
                </td>
            </tr>
        <? } ?>
    </table>

    <div class="centered">
        <? \Web\App\NewPaginate::display() ?>
    </div>
<? } else { ?>
    <h4 class="centered">Тут пусто :(</h4>
<? } ?>

<? include parts('foot'); ?>