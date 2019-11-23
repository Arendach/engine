<?php include t_file('buy.create.elements') ?>

<div class="row right">
    <div class="col-md-4">
        <h4><b>Основна інформація</b></h4>
    </div>
</div>

<div class="type_block">
    <?php element('date_delivery') ?>

    <?php element('address', ['value' => 'Бориспільська 26 \'З\', магазин \'Повітряно\'']) ?>

    <?php element('pay_method', ['pays' => $pays]) ?>
</div>