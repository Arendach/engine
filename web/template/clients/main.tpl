<?php include parts('head'); ?>

    <style>
        .filter {
            width: 100%;
            height: 18px;
        }
    </style>

    <div class="right" style="margin-bottom: 15px">
        <button data-type="get_form"
                data-uri="<?= uri('clients') ?>"
                data-action="create_form"
                class="btn btn-primary btn-md">Створити
        </button>
    </div>
    <div id="overlay"></div>
    <table class="table table-bordered">
        <tr>
            <th>Імя</th>
            <th>E-Mail</th>
            <th>Телефон</th>
            <th>Адреса</th>
            <th>Інформація</th>
            <th>Група</th>
            <th class="action-3">Дія</th>
        </tr>
        <tr>
            <th>
                <input value="<?= get('name') ? get('name') : '' ?>" class="filter" data-name="name">
            </th>

            <th>
                <input value="<?= get('email') ? get('email') : '' ?>" class="filter" data-name="email">
            </th>

            <th>
                <input value="<?= get('phone') ? get('phone') : '' ?>" class="filter" data-name="phone">
            </th>

            <th>
                <input value="<?= get('address') ? get('address') : '' ?>" class="filter" data-name="address">
            </th>
            <th></th>
            <th>
                <select class="filter" data-name="group">
                    <option value=""></option>
                    <?php foreach ($groups as $group) { ?>
                        <option <?= $group->id == get('group') ? 'selected' : '' ?>  value="<?= $group->id ?>">
                            <?= $group->name ?>
                        </option>
                    <?php } ?>
                </select>
            </th>
            <th class="action-3">
<!--                <button class="btn btn-primary btn-xs">-->
<!--                    <i class="fa fa-search"></i>-->
<!--                </button>-->
            </th>
        </tr>
        <?php if (isset($clients) && my_count($clients) > 0) {
            foreach ($clients as $client) { ?>
                <tr>
                    <td><?= $client['name'] ?></td>
                    <td><?= $client['email'] ?></td>
                    <td><?= $client['phone'] ?></td>
                    <td><?= $client['address'] ?></td>
                    <td><?= htmlspecialchars_decode($client['info']) ?></td>
                    <td><?= $client['group'] != '0' ? $client['group_name'] : 'Без групи' ?></td>
                    <td class="action-3">
                        <a href="<?= uri('clients', ['section' => 'client_orders', 'id' => $client['id']]); ?>"
                           title="Замовлення клієнта" class="btn btn-success btn-xs">
                            <span class="glyphicon glyphicon-shopping-cart"></span>
                        </a>
                        <button data-type="get_form"
                                data-uri="<?= uri('clients') ?>"
                                data-action="update_form"
                                data-post="<?= params(['id' => $client['id']]) ?>"
                                title="Редагувати"
                                class="btn btn-primary btn-xs">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </button>
                        <button data-type="delete"
                                data-uri="<?= uri('clients') ?>"
                                data-action="delete"
                                data-id="<?= $client['id'] ?>"
                                title="Видалити"
                                class="btn btn-danger btn-xs">
                            <span class="glyphicon glyphicon-remove"></span>
                        </button>
                    </td>
                </tr>
            <?php }
        } else { ?>
            <tr>
                <td class="centered" colspan="8">Тут пусто :(</td>
            </tr>
        <?php } ?>
    </table>

<div class="centered">
    <? \Web\App\NewPaginate::display() ?>
</div>

    <script>
        $(document).ready(function () {
            $(document).on('change', '.filter', function () {
                var data = {};
                $('.filter').each(function () {
                    data[$(this).data('name')] = $(this).val();
                });

                GET.setObject(data).unsetEmpty().go();
            });
        });
    </script>

<?php include parts('foot'); ?>