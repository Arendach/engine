<?php include parts('head'); ?>

<div class="right" style="margin-bottom: 15px;">
    <button data-type="get_form"
            data-uri="<?= uri('settings') ?>"
            data-action="create_site_form"
            class="btn btn-primary">Новий сайт</button>
</div>

<table class="table-bordered table">
    <tr>
        <th>Назва</th>
        <th>Адреса(URL)</th>
        <th class="action-2 centered">Дії</th>
    </tr>
    <?php foreach ($items as $item) { ?>
        <tr>
            <td><?= $item->name ?></td>
            <td>
                <a target="_blank" href="<?= $item->url ?>">
                    <?= $item->url ?>
                </a>
            </td>
            <td class="action-2 centered">
                <button data-type="get_form"
                        data-uri="<?= uri('settings') ?>"
                        data-action="update_site_form"
                        data-post="<?= params(['id' => $item->id]) ?>"
                        class="btn-xs btn btn-primary">
                    <i class="fa fa-pencil"></i>
                </button>

                <button data-type="delete"
                        data-uri="<?= uri('settings') ?>"
                        data-action="delete_site"
                        data-id="<?= $item->id ?>"
                        class="btn-xs btn btn-danger">
                    <i class="fa fa-remove"></i>
                </button>
            </td>
        </tr>
    <?php } ?>
</table>

<?php include parts('foot'); ?>

