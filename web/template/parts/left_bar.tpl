<div class="<?= template_class('left_bar', 'navigation'); ?>" id="left_bar">
    <ul>
        <li>
            <a href="<?= uri(''); ?>">
                <i class="fa fa-dashboard"></i>
                <span>Панель управліня</span>
            </a>
        </li>

        <?php if (can_keys(['purchases', 'inventory', 'category', 'manufacturer', 'products', 'storage'])) { ?>
            <li class="dropdown">
                <a href="#">
                    <i class="fa fa-book"></i><span>Каталог</span>
                    <ul class="dropdown-1">

                        <?php if (can('purchases')) { ?>
                            <li>
                                <a href="<?= uri('purchases'); ?>">
                                    <i class="fa fa-shopping-cart"></i>
                                    <span>Закупки</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('inventory')) { ?>
                            <li>
                                <a href="<?= uri('inventory'); ?>">
                                    <i class="fa fa-shopping-cart"></i>
                                    <span>Інвентаризація</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('category')) { ?>
                            <li>
                                <a href="<?= uri('category'); ?>">
                                    <i class="fa fa-list"></i>
                                    <span>Категорії</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('manufacturer')) { ?>
                            <li>
                                <a href="<?= uri('manufacturer'); ?>">
                                    <i class="fa fa-users"></i>
                                    <span>Постачальники</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('products')) { ?>
                            <li>
                                <a href="<?= uri('product'); ?>">
                                    <i class="fa fa-tags"></i><span>Товари</span>
                                </a>
                            </li>

                            <li>
                                <a href="<?= uri('product', ['section' => 'assets']); ?>">
                                    <i class="fa fa-tags"></i><span>Матеріальні активи</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('storage')) { ?>
                            <li>
                                <a href="<?= uri('storage'); ?>">
                                    <i class="fa fa-bank"></i>
                                    <span>Склади</span>
                                </a>
                            </li>
                        <?php } ?>
                    </ul>
                </a>
            </li>
        <?php } ?>

        <?php if (can_keys(['orders', 'orders_view', 'coupons', 'clients'])) { ?>
            <li class="dropdown">
                <a href="#">
                    <i class="fa fa-shopping-basket"></i>
                    <span>Продажі</span>
                    <ul class="dropdown-1">
                        <?php if (can('orders') || can('orders_view')) { ?>
                            <li class="dropdown">
                                <a href="<?= uri('orders', ['type' => 'delivery']) ?>">
                                    <i class="fa fa-sitemap"></i>
                                    <span>Замовлення</span>
                                    <ul class="dropdown-8">
                                        <li>
                                            <a href="<?= uri('orders', ['type' => 'delivery']) ?>">
                                                <i class="fa fa-angle-right"></i>
                                                <span>Доставка</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="<?= uri('orders', ['type' => 'shop']) ?>">
                                                <i class="fa fa-angle-right"></i>
                                                <span>Магазин</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="<?= uri('orders', ['type' => 'self']) ?>">
                                                <i class="fa fa-angle-right"></i>
                                                <span>Самовивіз</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="<?= uri('orders', ['type' => 'sending']) ?>">
                                                <i class="fa fa-angle-right"></i>
                                                <span>Відправка</span>
                                            </a>
                                        </li>
                                    </ul>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('coupons')) { ?>
                            <li>
                                <a href="<?= uri('coupon'); ?>">
                                    <i class="fa fa-id-card-o"></i>
                                    <span>Дисконтна система</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('clients')) { ?>
                            <li>
                                <a href="<?= uri('clients'); ?>">
                                    <i class="fa fa-user"></i>
                                    <span>Постійні клієнти</span>
                                </a>
                            </li>
                        <?php } ?>
                    </ul>
                </a>
            </li>
        <?php } ?>

        <?php if (can_keys(['settings', 'statistic', 'vacation', 'transaction', 'logs'])) { ?>
            <li class="dropdown">
                <a href="#">
                    <i class="fa fa-cogs"></i>
                    <span>Інше</span>
                    <ul class="dropdown-8">
                        <?php if (can('settings')) { ?>
                            <li>
                                <a href="<?= uri('settings'); ?>">
                                    <i class="fa fa-cogs"></i>
                                    <span>Налаштування</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('statistic')) { ?>
                            <li class="dropdown">
                                <a href="<?= uri('statistic') ?>">
                                    <i class="fa fa-pie-chart"></i><span>Статистика</span>
                                    <ul class="dropdown-1">
                                        <li>
                                            <a href="<?= uri('statistic') . parameters(['section' => 'orders']); ?>">
                                                <i class="fa fa-list"></i>
                                                <span>Замовлення</span>
                                            </a>
                                        </li>
                                    </ul>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('vacation')) { ?>
                            <li>
                                <a href="<?= uri('vacation') ?>">
                                    <i class="fa fa-list"></i>
                                    <span>Планувальник відпусток</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('transaction')) { ?>
                            <li>
                                <a href="<?= uri('pb') ?>">
                                    <i class="fa fa-list"></i>
                                    <span>Транзакції</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('logs')) { ?>
                            <li>
                                <a href="<?= uri('log') ?>">
                                    <i class="fa fa-list"></i>
                                    <span>Логи</span>
                                </a>
                            </li>
                        <?php } ?>
                    </ul>
                </a>
            </li>
        <?php } ?>

        <?php if (can_keys(['users', 'access', 'schedule'])) { ?>
            <li class="dropdown">
                <a href="#">
                    <i class="fa fa-users"></i><span>Менеджери</span>
                    <ul class="dropdown-1">
                        <?php if (can('access')) { ?>
                            <li>
                                <a href="<?= uri('access'); ?>">
                                    <i class="fa fa-key"></i>
                                    <span>Налаштування доступу</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('users')) { ?>
                            <li>
                                <a href="<?= uri('user', ['section' => 'list']) ?>">
                                    <i class="fa fa-list"></i>
                                    <span>Список менеджерів</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('users')) { ?>
                            <li>
                                <a href="<?= uri('position') ?>">
                                    <i class="fa fa-list"></i>
                                    <span>Посади</span>
                                </a>
                            </li>
                        <?php } ?>

                        <?php if (can('schedule')) { ?>
                            <li>
                                <a href="<?= uri('schedule', ['section' => 'users']); ?>">
                                    <i class="fa fa-bar-chart"></i>
                                    <span>Графіки роботи</span>
                                </a>
                            </li>
                        <?php } ?>
                    </ul>
                </a>
            </li>
        <?php } ?>
    </ul>
</div>