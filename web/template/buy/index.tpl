<?php include parts('head'); ?>

    <div class="dropdown right        <button class="btn btn-success dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Додати замовлення <span class="caret"></span>
        </button>

        <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation">
                <a role="menuitem" href="<?= route('add_order', ['type' => 'delivery']); ?>">Доставка</a>
            </li>
            <li role="presentation">
                <a role="menuitem" href="<?= route('add_order', ['type' => 'shop']); ?>">Магазин</a>
            </li>
            <li role="presentation">
                <a role="menuitem" href="<?= route('add_order', ['type' => 'sending']); ?>">Відправка</a>
            </li>
            <li role="presentation">
                <a role="menuitem" href="<?= route('add_order', ['type' => 'self']); ?>">Самовивіз</a>
            </li>
        </ul>
    </div>

    <form>
        <div class="form-group">
            <label for="type">Тип:</label>
            <select class="form-control" id="type">
                <option value="delivery">Доставка</option>
                <option value="shop">Магазин</option>
                <option value="sending">Надсилання</option>
                <option value="self">Самовивіз</option>
            </select>
        </div>
        <div class="form-group">
            <label for="items">Пунктів на сторінку:</label>
            <input id="items" class="form-control" value="25">
        </div>
        <div class="form-group">
            <button class="btn btn-primary" id="show_orders">Показати</button>
        </div>
    </form>

    <script>
        $(document).ready(function () {
            var $body = $('body');

            $body.on('click', '#show_orders', function (event) {
                event.preventDefault();
                var type = $('#type').val();
                var items = $('#items').val();

                var url = '/orders/' + type;
                if (items !== '') url += '?items=' + items;

                window.location.href = url;
            });
        });
    </script>

<?php include parts('foot'); ?>