<?php include parts('head'); ?>

    <div class="right" style="margin-bottom: 15px">
        <button data-type="get_form"
                data-uri="<?= uri('task') ?>"
                data-action="create_form"
                data-post="<?= params(['user_id' => get('user')]) ?>"
                class="btn btn-primary">
            Нова задача
        </button>
    </div>

    <table class="table table-bordered">
        <tr>
            <td><b>Дата</b></td>
            <td><b>Зміст</b></td>
            <td>
                <b>Статус </b> <br>
                <select id="status">
                    <option value=""></option>
                    <option <?= get('status') === 0 ? 'selected' : '' ?> value="0">Чекає на виконання</option>
                    <option <?= get('status') == 1 ? 'selected' : '' ?> value="1">Виконано</option>
                    <option <?= get('status') == 2 ? 'selected' : '' ?> value="2">Не виконано</option>
                </select>
            </td>
            <td><b>Коментар</b></td>
            <td><b>Бюджет</b></td>
            <td class="action-4"><b>Дії</b></td>
        </tr>
        <?php foreach ($tasks as $item) { ?>
            <tr class="alert-<?= $item->type ?>" data-id="<?= $item->id ?>">
                <td><?= date('d.m.Y', strtotime($item->date)) ?></td>
                <td><?= htmlspecialchars_decode($item->content) ?></td>
                <td>
                    <?php if ($item->success == 0) : ?>
                        <span style="color: blue">Чекає на виконання</span>
                    <?php elseif ($item->success == 1): ?>
                        <span style="color: green;">Виконано</span>
                    <?php else: ?>
                        <span style="color: red;">Не виконано</span>
                    <?php endif ?>
                </td>
                <td><?= $item->comment == '' ? 'Не заповнено' : htmlspecialchars_decode($item->comment) ?></td>
                <td><?= $item->price ?></td>
                <td class="right">
                    <?php if (!(user()->id == $item->user && user()->id == $item->author)) { ?>
                        <a href="<?= uri('/dialog') . parameters(['section' => 'task', 'task_id' => $item->id]) ?>"
                           class="btn btn-default btn-xs" title="Чат">
                            <span class="fa fa-wechat"></span>
                        </a>
                    <?php } ?>
                    <button title="Затвердити задачу"
                            class="btn btn-<?= $item->approve ? 'success' : 'danger approve_task' ?> btn-xs">
                        <span class="fa fa-circle-o"></span>
                    </button>
                    <button data-type="get_form"
                            data-uri="<?= uri('task') ?>"
                            data-action="update_form"
                            data-post="<?= params(['id' => $item->id]) ?>"
                            title="Редагувати"
                            class="btn btn-primary btn-xs">
                        <span class="glyphicon glyphicon-pencil"></span>
                    </button>
                    <button data-type="delete"
                            data-uri="<?= uri('task') ?>"
                            data-action="delete"
                            data-id="<?= $item->id ?>"
                            title="Видалити" 
                            class="btn btn-danger btn-xs">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>

    <script>
        $(document).ready(function () {

            var $body = $('body');

            $body.on('change', '#status', function () {
                var $this = $(this);
                if ($this.val() == '') {
                    GET.setRequest().unset('status').go();
                } else {
                    GET.set('status', $this.val()).go();
                }
            });

            $body.on('click', '.approve_task', function () {
                var id = $(this).parents('tr').data('id');
                swal({
                        title: "Затвердити?",
                        text: "Дану дію відмінити буде неможливо",
                        type: "info",
                        showCancelButton: true,
                        confirmButtonColor: "#DD6B55",
                        confirmButtonText: "Підтвердити",
                        closeOnConfirm: false
                    },
                    function () {
                        $.ajax({
                            type: "post",
                            url: url('task'),
                            data: {
                                id: id,
                                action: 'approve_task'
                            },
                            success: function (answer) {
                                successHandler(answer);
                            },
                            error: function (answer) {
                                errorHandler(answer);
                            }
                        });
                    });
            });

        });
    </script>

<?php include parts('foot'); ?>