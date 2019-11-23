<?php

$data = json_decode($item->data); 

?>

<div class="panel panel-success">

    <div class="panel-heading">
        <div data-toggle="collapse" data-parent="#accordion" href="#collapse<?= $i ?>">
            <h4 class="panel-title">
                <?= date('Y.m.d H:i', strtotime($item->date)) ?> <a class="alert-link" href="#"><?= $item->login ?></a>
                Оригінал
            </h4>
        </div>
    </div>

    <div id="collapse<?= $i ?>" class="panel-collapse collapse">
        <div class="panel-body">
            <div><span class="text-primary">Імя:</span> <?= $data->fio ?></div>
            <div><span class="text-primary">Телефон:</span> <?= $data->phone ?></div>

            <?php if (isset($data->phone2)) { ?>
                <div><span class="text-primary">Телефон 2:</span> <?= $data->phone2 ?></div>
            <?php } ?>

            <?php if (isset($data->email)) { ?>
                <div><span class="text-primary">Емейл:</span> <?= $data->email ?></div>
            <?php } ?>

            <?php if (isset($data->hint)) { ?>
                <div><span class="text-primary">Підказка:</span> <?= $data->hint ?></div>
            <?php } ?>

            <?php if (isset($data->delivery)) { ?>
                <div><span class="text-primary">Транспортна компанія:</span> <?= $data->delivery ?></div>
            <?php } ?>

            <?php if (isset($data->date_delivery)) { ?>
                <div><span class="text-primary">Дата доставки:</span> <?= date_for_humans($data->date_delivery) ?></div>
            <?php } ?>

            <?php if (isset($data->site)) { ?>
                <div><span class="text-primary">Сайт:</span> <?= $data->site ?></div>
            <?php } ?>

            <?php if (isset($data->courier)) { ?>
                <div><span class="text-primary">Курєр:</span> <?= $data->courier ?></div>
            <?php } ?>

            <?php if (isset($data->comment)) { ?>
                <div><span class="text-primary">Коментар:</span> <?= $data->comment ?></div>
            <?php } ?>

            <?php if (isset($data->coupon)) { ?>
                <div><span class="text-primary">Купон:</span> <?= $data->coupon ?></div>
            <?php } ?>

            <?php if (isset($data->city)) { ?>
                <div><span class="text-primary">Місто:</span> <?= $data->city ?></div>
            <?php } ?>

            <?php if (isset($data->warehouse)) { ?>
                <div><span class="text-primary">Відділення:</span> <?= $data->warehouse ?></div>
            <?php } ?>

            <?php if (isset($data->address)) { ?>
                <div><span class="text-primary">Адреса:</span> <?= $data->address ?></div>
            <?php } ?>

            <?php if (isset($data->form_delivery)) { ?>
                <div><span class="text-primary">Форма оплати:</span> <?= $data->form_delivery ?></div>
            <?php } ?>

            <?php if (isset($data->pay_delivery)) { ?>
                <div><span class="text-primary">Оплата доставки:</span> <?= $data->pay_delivery ?></div>
            <?php } ?>

            <?php if (isset($data->payment_status)) { ?>
                <div><span class="text-primary">Статус оплати:</span> <?= $data->payment_status ?></div>
            <?php } ?>

            <?php if (isset($data->prepayment)) { ?>
                <div><span class="text-primary">Предоплата:</span> <?= $data->prepayment ?></div>
            <?php } ?>

            <?php if (isset($data->delivery_cost)) { ?>
                <div><span class="text-primary">Ціна доставки:</span> <?= $data->delivery_cost ?></div>
            <?php } ?>

            <?php if (isset($data->discount)) { ?>
                <div><span class="text-primary">Знижка:</span> <?= $data->discount ?></div>
            <?php } ?>
            <div>
                <span class="text-primary" style="margin-bottom: 15px">Товари:</span>
                <?php foreach ($data->products as $product) { ?>
                    <div style="margin-bottom: 10px;border: 1px solid #ccc; padding: 10px;border-radius: 5px; background-color: #fff;">
                        <a href="<?= uri('product', ['section' => 'update', 'id' => $product->id]) ?>">
                            <?= $product->name ?>
                        </a> <br>
                        <b style="color: red"><?= $product->amount ?></b> шт. по ціні <b style="color: red"><?= $product->price ?></b> грн
                    </div>                    
                <?php } ?>
            </div>
        </div>
    </div>

</div>