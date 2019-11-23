<?php include parts('head'); ?>

<div class="right">
    <button
            data-type="get_form"
            data-uri="<?= uri('manufacturer') ?>"
            data-action="create_form"
            class="btn btn-primary">
        Додати
    </button>
    <button id="printMe" type="button" class="btn btn-primary">Друкувати</button>
</div>
<div class="table-responsive" style="margin-top: 15px">
    <table class="table table-bordered">
        <thead>
        <tr>
            <th style="width: 36px;">CH</th>
            <th>Назва</th>
            <th>Групи виробників</th>
            <th>Телефон</th>
            <th>Електронна пошта</th>
            <th style="width: 69px;">Дія</th>
        </tr>
        </thead>
        <tbody>
        <?php if (my_count($manufacturers) > 0) {
            foreach ($manufacturers as $key => $manuf): ?>
                <tr>
                    <td style="width: 36px;"><input type="checkbox" class="delSelected"
                                                    value="<?= $manuf->id ?>"></td>
                    <td><?php echo $manuf->name ?></td>
                    <td><?= val($manuf->group_name) ? $manuf->group_name : 'Група не вибрана' ?></td>
                    <td><?= $manuf->phone; ?></td>
                    <td><?= $manuf->email; ?></td>
                    <td style="width: 69px;">
                        <button
                                data-type="get_form"
                                data-action="update_form"
                                data-uri="<?= uri('manufacturer') ?>"
                                data-post="<?= params(['id' => $manuf->id]) ?>"
                                class="btn btn-primary btn-xs btn-outline"
                                title="Редагувати"
                                data-id="<?= $manuf->id ?>">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </button>
                        <button data-type="delete"
                                data-action="delete"
                                data-uri="<?= uri('manufacturer') ?>"
                                class="btn btn-danger btn-xs" title="Видалити" data-id="<?= $manuf->id ?>">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                    </td>
                </tr>
            <?php endforeach;
        } else {
            echo '<tr><td class="centered" colspan="7"><h4>Тут пусто :(</h4></td></tr>';
        } ?>
        </tbody>
    </table>
</div>


<script>
    $(document).ready(function () {

        var $body = $('body');

        $body.on('click', '#printMe', function () {

            var selected = [];
            $('.delSelected:checked').each(function () {
                selected.push($(this).val());
            });

            if (selected.length < 1) {
                alert('Не відмічено що треба друкувати!');
                return false;
            }

            $.ajax({
                type: "post",
                url: url('/manufacturer'),
                data: {
                    ids: selected,
                    action: 'print'
                },
                dataType: "html",
                success: function (response) {
                    var originalContents = document.body.innerHTML;
                    document.body.innerHTML = response;
                    window.print();
                    document.body.innerHTML = originalContents;
                }
            });
        });
    });
</script>

<?php include parts('foot'); ?>
