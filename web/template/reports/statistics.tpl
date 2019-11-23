<?php include parts('head') ?>

<style>
    .year {
        margin-bottom: 15px;
        border-bottom: 1px solid;
        padding: 10px;
    }

    .month {
        background-color: #fff;
        padding: 10px;
        margin-bottom: 10px;
        border: 1px dashed #999;
    }

    .month > .centered {
        color: #0a790f;
    }
</style>

<?php foreach ($data as $year => $months) { ?>
    <div class="year">
        <?php foreach ($months as $month => $item) { ?>
            <div class="month">
                <div class="centered"><?= int_to_month($month) ?> <?= $year ?></div>

                <?php if (isset($item['shipping_costs'])){ ?>
                    <?php if (isset($item['shipping_costs']['gasoline'])){ ?>
                        Бензин: <span class="text-primary"><?= number_format($item['shipping_costs']['gasoline'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['shipping_costs']['journey'])){ ?>
                        Проїзд: <span class="text-primary"><?= number_format($item['shipping_costs']['journey'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['shipping_costs']['transport_company'])){ ?>
                        Транспортні компанії: <span class="text-primary"><?= number_format($item['shipping_costs']['transport_company'],2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['shipping_costs']['packing_materials'])){ ?>
                        Пакувальні матеріали: <span class="text-primary"><?= number_format($item['shipping_costs']['packing_materials'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['shipping_costs']['for_auto'])){ ?>
                        Амортизація авто: <span class="text-primary"><?= number_format($item['shipping_costs']['for_auto'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['shipping_costs']['salary_courier'])){ ?>
                        Зарплата курєрам: <span class="text-primary"><?= number_format($item['shipping_costs']['salary_courier'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['shipping_costs']['supplies'])){ ?>
                        Витратні матеріали(інше): <span class="text-primary"><?= number_format($item['shipping_costs']['supplies'], 2) ?></span> <br>
                        <?php } ?>
                <?php } ?>

                <?php if (count($item) == 2) { ?>
                    <hr>
                <?php } ?>

                <?php if (isset($item['expenditures'])){ ?>
                    <?php if (isset($item['expenditures']['taxes'])){ ?>
                        Податки: <span class="text-primary"><?= number_format($item['expenditures']['taxes'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['expenditures']['investment'])){ ?>
                        Інвестиції: <span class="text-primary"><?= number_format($item['expenditures']['investment'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['expenditures']['mobile'])){ ?>
                        Мобільний звязок: <span class="text-primary"><?= number_format($item['expenditures']['mobile'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['expenditures']['rent'])){ ?>
                        Оренда: <span class="text-primary"><?= number_format($item['expenditures']['rent'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['expenditures']['social'])){ ?>
                        Соціальні програми: <span class="text-primary"><?= number_format($item['expenditures']['social'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['expenditures']['other'])){ ?>
                    Витратні матеріали: <span class="text-primary"><?= number_format($item['expenditures']['other'], 2) ?></span> <br>
                    <?php } ?>

                    <?php if (isset($item['expenditures']['advert'])){ ?>
                        Реклама: <span class="text-primary"><?= number_format($item['expenditures']['advert'], 2) ?></span> <br>
                    <?php } ?>
                <?php } ?>
            </div>
        <? } ?>
    </div>
<? } ?>

<?php include parts('foot') ?>
