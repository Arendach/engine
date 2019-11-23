<?php include parts('head') ?>

    <div class="right" style="margin-bottom: 15px">
        <button
                data-type="get_form"
                data-uri="<?= uri('category') ?>"
                data-action="create_form"
                class="btn btn-primary">
            Створити категорію
        </button>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>Назва Категорії</th>
                <th>Сервісний код</th>
                <th style="width: 69px">Дія</th>
            </tr>
            </thead>
            <tbody>
            <?php if (isset($categories) && $categories !== false)
                echo $categories;
            else
                echo '<tr><td colspan="4" class="centered">Тут пусто :(</td></tr>'; ?>
            </tbody>
        </table>
    </div>
<?php include parts('foot') ?>