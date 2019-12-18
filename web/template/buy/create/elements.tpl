<?php

function element($element, $data = [])
{
    extract($data);

    if ($element == 'fio') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="fio">Імя <span class="text-danger">*</span></label>
            <div class="col-md-5">
                <input id="fio" class="form-control" name="fio">
                <div class="search_clients"></div>
            </div>
        </div>
    <?php }

    if ($element == 'address') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="address">Адреса</label>
            <div class="col-md-5">
                <input id="address" class="form-control" name="address" value="<?= isset($value) ? $value : '' ?>">
            </div>
        </div>
    <?php }

    if ($element == 'phone') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="phone">Номер телефону <i class="text-danger">*</i></label>
            <div class="col-md-5">
                <input id="phone" name="phone" class="form-control">
            </div>
        </div>
    <?php }

    if ($element == 'phone2') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="phone2">Додатковий номер телефону</label>
            <div class="col-md-5">
                <input id="phone2" name="phone2" class="form-control">
            </div>
        </div>
    <?php }

    if ($element == 'email') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="email">E-mail</label>
            <div class="col-md-5">
                <input id="email" name="email" class="form-control" type="email">
            </div>
        </div>
    <?php }

    if ($element == 'hint') { ?>
        <div class="form-group">
            <label for="hints" class="col-md-4 control-label">
                <?php if (isset($type) && $type == 'sending') { ?>
                    <span style="color: red">Підказка</span> <i class="text-danger">*</i>
                <?php } else { ?>
                    Підказка
                <?php } ?>
            </label>
            <div class="col-md-5">
                <select
                    <?= isset($type) && $type == 'sending' ? 'required' : '' ?> name="hint_id" class="form-control">
                    <?php if (!isset($type) || $type != 'sending') { ?>
                        <option value="0"></option>
                    <?php } ?>
                    <?php foreach ($hints as $hint) { ?>
                        <option value="<?= $hint->id; ?>"><?= $hint->description; ?></option>
                    <?php } ?>
                </select>
            </div>
        </div>
    <?php }

    if ($element == 'date_delivery') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="date_delivery">
                <span style="color: red">!!! УВАГА  !!!! Дата доставки <span class="text-danger">*</span></span>
            </label>
            <div class="col-md-5">
                <input value="<?= date('Y-m-d') ?>" id="date_delivery" type="date" name="date_delivery"
                       class="form-control" required>
            </div>
        </div>
    <?php }

    if ($element == 'time') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label">Час доставки</label>
            <div class="col-md-5">
                <div class="row">
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-addon">З</span>
                            <input name="time_with" class="form-control">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-addon">По</span>
                            <input name="time_to" class="form-control">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <?php }


    if ($element == 'courier') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="courier">Курєр</label>
            <div class="col-md-5">
                <select name="courier_id" class="form-control">
                    <option value="0">Не вибрано</option>
                    <?php foreach ($users as $user) { ?>
                        <option value="<?= $user->id ?>"><?= $user->name ?></option>
                    <?php } ?>
                </select>
            </div>
        </div>
    <?php }

    if ($element == 'coupon') { ?>
        <div class="form-group">
            <label for="coupon" class="col-md-4 control-label">Номер дисконтної картки</label>
            <div class="col-md-5">
                <input id="coupon" name="coupon" class="form-control">
            </div>
        </div>

        <div class="form-group none">
            <label class="col-md-4 control-label" for="coupon_search"></label>
            <div class="col-md-5">
                <select id="coupon_search" class="form-control" multiple></select>
            </div>
        </div>
    <?php }

    if ($element == 'comment') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="comment">Коментар до замовлення</label>
            <div class="col-md-5">
                <textarea name="comment" class="form-control" id="comment"></textarea>
            </div>
        </div>
    <?php }

    if ($element == 'delivery_city') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="city">Місто <span class="text-danger">*</span></label>
            <div class="col-md-5">
                <input id="city" name="city" value="Київ" required class="form-control">
            </div>
        </div>

        <div class="form-group none" id="city_select_container">
            <label class="col-md-4 control-label" for="city_select"></label>
            <div class="col-md-5">
                <select id="city_select" class="form-control" multiple></select>
                <span class="btn btn-danger btn-xs hiden close_multiple" data-id="city_select_container">X</span>
            </div>
        </div>
    <?php }

    if ($element == 'street') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="street">Вулиця</label>
            <div class="col-md-5">
                <input id="street" name="street" class="form-control">
            </div>
        </div>

        <div class="form-group none" id="street_select_container">
            <label class="col-md-4 control-label" for="street_select"></label>
            <div class="col-md-5">
                <select id="street_select" class="form-control" multiple></select>
                <span class="btn btn-danger btn-xs hiden close_multiple" data-id="street_select_container">X</span>
            </div>
        </div>
    <?php }

    if ($element == 'comment_address') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="comment_address">Коментар до адреси</label>
            <div class="col-md-5">
                <textarea class="form-control" name="comment_address" id="comment_address"></textarea>
            </div>
        </div>
    <?php }

    if ($element == 'pay_method') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label">Варіант оплати</label>
            <div class="col-md-5">
                <select class="form-control" name="pay_id">
                    <?php foreach ($pays as $pay) { ?>
                        <option data-is_cashless="<?= $pay->is_cashless ?>" value="<?= $pay->id ?>">
                            <?= $pay->name ?>
                        </option>
                    <?php } ?>
                </select>
            </div>
        </div>
    <?php }

    if ($element == 'prepayment') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="prepayment">Предоплата</label>
            <div class="col-md-5">
                <input id="prepayment" class="form-control" name="prepayment">
            </div>
        </div>
    <?php }

    if ($element == 'delivery') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="delivery">Транспортна компанія</label>
            <div class="col-md-5">
                <select id="delivery" name="delivery" class="form-control">
                    <?php foreach ($deliveries as $delivery) { ?>
                        <option value="<?= $delivery->id ?>"><?= $delivery->name ?></option>
                    <?php } ?>
                </select>
            </div>
        </div>
    <?php }

    if ($element == 'sending_city') { ?>
        <div id="address_container">

            <div class="form-group">
                <label class="col-md-4 control-label" for="city_input">Місто <span class="text-danger">*</span></label>
                <div class="col-md-5">
                    <div class="input-group">
                        <input class="form-control" placeholder="Введіть 3 символи" id="city_input">
                        <span class="input-group-addon pointer clear" data-id="city_input">X</span>
                    </div>
                </div>
            </div>

            <input type="hidden" id="city" name="city" class="form-control">

            <div class="form-group none" id="city_select_container">
                <label class="col-md-4 control-label" for="city_select"></label>
                <div class="col-md-5">
                    <select id="city_select" class="form-control" multiple></select>
                    <span class="btn btn-danger btn-xs hiden close_multiple" data-id="city_select_container">X</span>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label" for="warehouse">
                    Відділення <span class="text-danger">*</span>
                </label>
                <div class="col-md-5">
                    <select disabled id="warehouse" name="warehouse" class="form-control"></select>
                </div>
            </div>

            <div class="form-group none">
                <label class="col-md-4 control-label" for="warehouse_search"></label>
                <div class="col-md-5">
                    <select id="warehouse_search" class="form-control" multiple></select>
                </div>
            </div>

        </div>
    <?php }

    if ($element == 'form_delivery') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="form_delivery">
                Форма оплати <i class="text-danger">*</i>
            </label>
            <div class="col-md-5">
                <select id="form_delivery" class="form-control" name="form_delivery">
                    <option disabled value="on_the_card">Безготівкова</option>
                    <option selected value="imposed">Готівка</option>
                </select>
            </div>
        </div>
    <?php }

    if ($element == 'pay_delivery') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="pay_delivery">
                Доставку оплачує <i class="text-danger">*</i>
            </label>
            <div class="col-md-5">
                <select id="pay_delivery" class="form-control" name="pay_delivery">
                    <option value=""></option>
                    <option value="recipient">Отримувач</option>
                    <option value="sender">Відправник</option>
                </select>
            </div>
        </div>
    <?php }

    if ($element == 'payment_status') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="payment_status">Статус оплати</label>
            <div class="col-md-5">
                <select id="payment_status" class="form-control" name="payment_status">
                    <option value="0">Не оплачено</option>
                    <option value="1">Оплачено</option>
                </select>
            </div>
        </div>
    <?php }

    if ($element == 'return_shipping') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="return_shipping_type">
                Тип <i class="text-danger">*</i>
            </label>
            <div class="col-md-5">
                <select id="return_shipping_type" name="return_shipping_type" class="form-control" >
                    <option value=""></option>
                    <option value="none">Немає</option>
                    <option value="documents">Документ</option>
                    <option value="remittance">Грошовий переказ</option>
                    <option value="other">Інше</option>
                </select>
            </div>
        </div>

        <div class="form-group none" id="return_shipping_remittance_type_container">
            <label class="col-md-4 control-label" for="return_shipping_remittance_type">Грошовий переказ</label>
            <div class="col-md-5">
                <select class="form-control" id="return_shipping_type_remittance"
                        name="return_shipping_type_remittance">
                    <option value="imposed">У відділенні</option>
                    <option disabled value="on_the_card">На картку</option>
                </select>
            </div>
        </div>

        <div class="form-group none" id="return_shipping_card_container">
            <label class="col-md-4 control-label" for="return_shipping_card">Карточка</label>
            <div class="col-md-5">
                <select disabled class="form-control" id="return_shipping_card" name="return_shipping_card">
                    <?php foreach ($cards as $item) { ?>
                        <option value="<?= $item['Ref'] ?>"><?= $item['MaskedNumber'] ?></option>
                    <?php } ?>
                </select>
            </div>
        </div>

        <div class="form-group none" id="return_shipping_sum_container">
            <label class="col-md-4 control-label" for="return_shipping_sum">Дані/сума</label>
            <div class="col-md-5">
                <input disabled class="form-control" id="return_shipping_sum" name="return_shipping_sum">
            </div>
        </div>

        <div class="form-group none" id="return_shipping_payer_container">
            <label class="col-md-4 control-label" for="return_shipping_payer">Платник зворотньої відправки</label>
            <div class="col-md-5">
                <select id="return_shipping_payer" class="form-control" name="return_shipping_payer">
                    <option selected value="receiver">Отримувач</option>
                    <option value="sender">Відправник</option>
                </select>
            </div>
        </div>
    <?php }

    if ($element == 'warehouse') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="warehouse">Магазин</label>
            <div class="col-md-5">
                <select id="warehouse" name="warehouse" class="form-control">
                    <?php foreach (\Web\Model\OrderSettings::getAll('shops') as $item) { ?>
                        <option value="<?= $item->id ?>"><?= $item->name ?></option>
                    <?php } ?>
                </select>
            </div>
        </div>
    <?php }


    if ($element == 'site') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label" for="site">Сайт</label>
            <div class="col-md-5">
                <select id="site" name="site" class="form-control">
                    <option value=""></option>
                    <?php foreach (\Web\App\Model::getAll('sites') as $site) { ?>
                        <option value="<?= $site->id ?>"><?= $site->name ?></option>
                    <?php } ?>
                </select>
            </div>
        </div>
    <?php }
    
    if ($element == 'sending_variant'){ ?>
        <div class="form-group">
            <label class="col-md-4 control-label">
                Варіант відправки <i class="text-danger">*</i>
            </label>
            <div class="col-md-5">
                <select name="sending_variant" id="sending_variant" class="form-control">
                    <?php foreach (\Web\Model\OrderSettings::sendingVariants() as $id => $item) { ?>
                        <option value="<?= $id ?>">
                            <?= $item['name'] ?>
                        </option>
                    <?php } ?>
                </select>
            </div>
        </div>
    <?php }


    if ($element == 'client_id') { ?>
        <div class="form-group">
            <label class="col-md-4 control-label">Клієнт</label>
            <div class="col-md-5">
                <select name="site" class="form-control">
                    <option value="0"></option>
                    <?php foreach (\Web\Eloquent\Client::all() as $item) { ?>
                        <option value="<?= $item->id ?>"><?= $item->name ?></option>
                    <?php } ?>
                </select>
            </div>
        </div>
    <?php }

}