<table class="table table-bordered" cellspacing="0" width="100%">
    <thead>
    <th>Імя</th>
    <th>Дії</th>
    </thead>
    <tfoot>
    <tr>
        <td style="width: 69px;" colspan="2">
            <?php print($inputsTbl) ?>
        </td>
    </tr>
    </tfoot>
    <tbody>
    <?php foreach ($table as $item): ?>
        <tr>
            <td><?php print($item->name) ?></td>
            <td style="width: 69px;">
                <a class="edit btn btn-primary btn-xs"
                   data-form="<?=$form;?>"
                   data-id="<?=$item->id;?>">
                    <span class="glyphicon glyphicon-pencil"></span>
                </a>
                <a class="remove btn btn-danger btn-xs"
                    data-id="<?php print($item->id) ?>"
                    data-form="<?=$form;?>">
                    <span class="glyphicon glyphicon-remove"></span>
                </a>
            </td>
        </tr>

    <?php endforeach ?>
    </tbody>
</table>

