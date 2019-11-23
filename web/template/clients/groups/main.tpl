<?php include parts('head'); ?>

<div class="right" style="margin-bottom: 15px;">
    <button data-type="get_form"
            data-uri="<?= uri('clients_group') ?>"
            data-action="create_form"
            class="btn btn-primary">Нова група</button>
</div>

<table class="table table-bordered">
    <tr>
        <th>Імя</th>
        <th class="action-2">Дія</th>
    </tr>

    <?php if (my_count($groups) > 0) { ?>
        <?php foreach ($groups as $group) { ?>
            <tr>
                <td><?=$group->name;?></td>
                <td class="action-2">
                    <button data-type="get_form"
                            data-uri="<?= uri('clients_group') ?>"
                            data-action="update_form"
                            data-post="<?= params(['id' => $group->id]) ?>"
                            class="btn btn-primary btn-xs edit">
                        <span class="glyphicon glyphicon-pencil"></span>
                    </button>

                    <button data-type="delete"
                            data-uri="<?= uri('clients_group') ?>"
                            data-action="delete"
                            data-id="<?= $group->id ?>"
                            class="btn btn-danger btn-xs delete">
                        <span class="glyphicon glyphicon-remove "></span>
                    </button>
                </td>
            </tr>
        <?php } ?>
    <?php } else { ?>
        <tr>
            <td colspan="2">
                <h4 class="centered">Тут пусто :(</h4>
            </td>
        </tr>
    <?php } ?>
</table>

<?php include parts('foot'); ?>