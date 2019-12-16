<?php include parts('head'); ?>

    <div class="right" style="margin-bottom: 15px;">
       <?php foreach (assets('order_types') as $k => $item) { ?>
           <a class="btn btn-<?= request()->is('type', $k) ? 'primary' : 'default' ?>" href="<?= uri('orders/create', ['type' => $k]) ?>">
               <?= $item['one'] ?>
           </a>
       <?php } ?>
    </div>

    <hr>

    <div class="content-section">
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

    <script>window.type = '<?= $type ?>'</script>

<?php include parts('foot') ?>