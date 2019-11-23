<?php include parts('head'); ?>

    <h2 class="sub-header">Замовлення №<?= $data['id']; ?> </h2>

    <div class="pull-right">
        <a target="_blank" href="<?= route('print_order', ['id' => $data['id']]); ?>" class="btn btn-primary"
           style="margin-bottom: 10px">Рахунок-фактура</a>
    </div>

    <div class="content-section">

        <ul class="nav nav-tabs" style="margin-top: 54px; margin-bottom: 10px;">
            <li class="active"><a href="#data" data-toggle="tab">Дані</a></li>
            <li><a href="#products" data-toggle="tab">Товари</a></li>
        </ul>

        <div class="tab-content">
            <div class="tab-pane active" id="data">
                <table class="table table-bordered">
                    <tr>
                        <td>Імя</td>
                        <td>Телефон</td>
                        <td>Додатковий телефон</td>
                        <td>Електронна пошта:</td>
                    </tr>
                    <tr>
                        <td><?= $data['fio']; ?></td>
                        <td><?= $data['phone']; ?></td>
                        <td><?= val($data['phone2']) !== false ? $data['phone2'] : 'Не вказано'; ?></td>
                        <td><?= $data['email']; ?></td>
                    </tr>
                </table>
                <table class="table table-bordered" style="font-size: 12px;">
                    <tr>
                        <td>Замовлення створено:</td>
                        <td><?= $data['date']; ?></td>
                    </tr>
                    <tr>
                        <td>Дата доставки:</td>
                        <td><?= $data['date_delivery']; ?></td>
                    </tr>
                    <?php if ($data['type'] != 'sending') { ?>
                        <tr>
                            <td>Градація по часу доставки:</td>
                            <td><?= $data['time_with'] . ' - ' . $data['time_to']; ?></td>
                        </tr>
                    <?php } ?>
                    <tr>
                        <td>Адреса:</td>
                        <td><?php if ($data['type'] == 'sending')
                                echo $data['city'];
                            elseif ($data['type'] == 'shop')
                                echo $data['address'];
                            elseif ($data['type'] == 'delivery')
                                echo $data['city'] . ' ' . $data['region'] . ' ' . $data['address'];
                            else
                                echo $data['region'] . ' ' . $data['address'];
                            ?></td>
                    </tr>
                    <?php if ($data['type'] == 'sending' && $data['type'] == 'self') { ?>
                        <tr>
                            <td>Ідентифікатор складу:</td>
                            <td><?= $data['warehouse']; ?></td>
                        </tr>
                    <?php } ?>
                    <?php if ($data['type'] != 'sending' && $data['type'] == 'self') { ?>
                        <tr>
                            <td>Коментар до адреси:</td>
                            <td><?= $data['comment_address']; ?></td>
                        </tr>
                    <?php } ?>
                    <?php if ($data['type'] == 'self') { ?>
                        <tr>
                            <td>Спосіб оплати:</td>
                            <td><?php if ($data['form_delivery'] == 'bank_transfer')
                                    echo 'Безготівковий';
                                else
                                    echo 'Готівковий';
                                ?></td>
                        </tr>
                    <?php } ?>
                    <tr>
                        <td>Кур`єр:</td>
                        <td><?= $data['courier']; ?></td>
                    </tr>
                    <tr>
                        <td>Купон:</td>
                        <td><?= $data['coupon']; ?></td>
                    </tr>
                    <tr>
                        <td>Коментар:</td>
                        <td><?= $data['comment']; ?></td>
                    </tr>
                    <?php if ($data['type'] != 'sending' && $data['type'] != 'self') { ?>
                        <?php if ($data['type'] != 'delivery') { ?>
                            <tr>
                                <td>Доставка:</td>
                                <td><?= $data['delivery']; ?></td>
                            </tr>
                        <?php } ?>
                        <?php if ($data['type'] != 'sending') { ?>
                            <tr>
                                <td>Доставку оплачує:</td>
                                <td>
                                    <?php if ($data['cod'] == 'sender')
                                        echo 'Відправник';
                                    else
                                        echo 'Отримувач';
                                    ?>
                                </td>
                            </tr>
                        <?php } ?>
                        <tr>
                            <td>Форма оплати:</td>
                            <td><?= $data['pay_method']; ?></td>
                        </tr>
                    <?php } ?>
                    <tr>
                        <table class="table table-bordered">
                            <tr>
                                <td>Ціна за товари:</td>
                                <td>Знижка:</td>
                                <td>Ціна доставки:</td>
                                <td>Загальна сума</td>
                            </tr>
                            <tr>
                                <td><?= $data['sum']; ?></td>
                                <td><?= $data['discount']; ?></td>
                                <td><?= $data['delivery_cost']; ?></td>
                                <td><?= $data['full_sum']; ?></td>
                            </tr>
                        </table>
                    </tr>
                </table>
            </div>
            <div class="tab-pane" id="products">
                <?php if ($products != false) { ?>
                <table class="product">
                    <tr class="heading">
                        <td><b>Товар</b></td>
                        <td><b>Модель</b></td>
                        <td align="right"><b>Кількість</b></td>
                        <td align="right"><b>Ціна за одиницю</b></td>
                        <td align="right"><b>Всього</b></td>
                    </tr>
                    <?php foreach (get_object($products) as $item) { ?>
                        <tr>
                            <td><?= $item->name; ?>
                            </td>
                            <td><?= $item->model ?></td>
                            <td align="right"><?= $item->amount ?></td>
                            <td align="right"><?= $item->price ?></td>
                            <td align="right"><?= $item->amount * $item->price; ?></td>
                        </tr>
                    <?php }
                    } ?>
                </table>

            </div>
        </div>

    </div>
<?php $this->inc('/parts/footer'); ?>