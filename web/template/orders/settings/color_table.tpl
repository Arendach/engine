<table class="table table-bordered" cellspacing="0" width="100%">
    <thead>
    <th>Колір</th>
    <th>Опис</th>
    <th style="width: 69px;">Дії</th>
    </thead>
    <tbody>
    <?php if (my_count($table) > 0) {
        foreach ($table as $item): ?>
            <tr>
                <td>
                    <div class="color_hint"
                         style="width: 30px; height: 30px; background: #<?php echo $item->color; ?>;"></div>
                </td>
                <td><?php echo $item->description; ?></td>
                <td>
                    <a class="edit btn btn-primary btn-xs"
                       data-form="<?= $form; ?>"
                       data-id="<?= $item->id; ?>">
                        <span class="glyphicon glyphicon-pencil"></span>
                    </a>
                    <a class="remove btn btn-danger btn-xs"
                       data-form="<?= $form; ?>"
                       data-id="<?= $item->id; ?>">
                        <span class="glyphicon glyphicon-remove"></span>
                    </a>
                </td>
            </tr>

        <?php endforeach;
    } else{
        echo '<tr><td class="centered" colspan="3"><h4>Тут пусто :(</h4></td></tr>';
    } ?>
    </tbody>
    <tfoot>
    <tr>
        <td colspan="3">
            <?php if (isset($inputsTbl)) print($inputsTbl) ?>
        </td>
    </tr>
    </tfoot>
</table>

