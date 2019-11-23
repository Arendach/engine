<?php include parts('head'); ?>

    <!-- Buttons -->

    <div class="right" style="margin-bottom: 15px;">
        <a class="btn btn-<?= $type == 'delivery' ? 'primary' : 'default'; ?>"
           href="<?= uri('orders', ['section' => 'create', 'type' => 'delivery']) ?>"> Доставка </a>

        <a class="btn btn-<?= $type == 'shop' ? 'primary' : 'default'; ?>"
           href="<?= uri('orders', ['section' => 'create', 'type' => 'shop']) ?>">Магазин</a>

        <a class="btn btn-<?= $type == 'self' ? 'primary' : 'default'; ?>"
           href="<?= uri('orders', ['section' => 'create', 'type' => 'self']) ?>">Самовивіз</a>

        <a class="btn btn-<?= $type == 'sending' ? 'primary' : 'default'; ?>"
           href="<?= uri('orders', ['section' => 'create', 'type' => 'sending']) ?>">Відправка</a>
    </div>

    <hr>

    <!-- Content -->

    <div class="content-section">
        <!-- Navigation -->

        <ul class="nav nav-pills nav-justified">
            <li class="active"><a data-toggle="tab" href="#main">Основна інформація</a></li>
            <li><a data-toggle="tab" href="#products">Товари</a></li>
        </ul>

        <hr>
        <form id="create_order">
            <input type="hidden" name="type" value="<?= $type ?>">
            <div class="tab-content">
                <div id="main" class="tab-pane fade in active">
                    <div class="form-horizontal">
                        <?php include t_file("buy.create.$type") ?>
                    </div>
                </div>
                <div id="products" class="tab-pane fade">
                    <?php include t_file('buy.create.products') ?>
                </div>
            </div>
        </form>
    </div>

<?php include parts('foot') ?>