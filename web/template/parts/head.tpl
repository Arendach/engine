<!DOCTYPE html>
    <html lang="uk">
    <head>
        <meta charset="UTF-8">
        <title><?= $title ?? 'ENTER TITLE' ?></title>
        <link rel="shortcut icon" href="<?= asset('favicon.ico'); ?>" type="image/x-icon">
        <link rel="stylesheet" href="<?= asset('css/app.css') ?>">
        <link rel="stylesheet" id="baze-theme" href="<?= asset('css/themes/' . user()->theme . '.css') ?>">
    </head>
<body>
    <input style="display: none" name="login" type="text">
    <input style="display: none" name="password" type="password">

    <div class="content-left content-left-<?= $_COOKIE['left-content-state'] ?? 'open' ?>">
        <ul>
            <?php foreach (assets('menu') as $k => $item) { ?>
                <?php if (!isset($item['access']) || $item['access'] == false || can($item['access'])) { ?>
                    <li <?= isset($item['menu']) ? 'class="dropdown"' : '' ?>>
                        <a href="<?= $item['url'] ?>">
                            <i class="fa fa-<?= $item['icon'] ?>"></i>
                            <span><?= $item['name'] ?></span>

                            <?php if (isset($item['menu'])) { ?>
                                <ul class="dropdown-<?= $k ?>">
                                    <?php foreach ($item['menu'] as $key => $inner) { ?>
                                        <?php if (!isset($inner['access']) || $inner['access'] == false || can($inner['access'])) { ?>
                                            <li>
                                                <a href="<?= $inner['url'] ?>">
                                                    <i class="fa fa-angle-double-right"></i>
                                                    <span><?= $inner['name'] ?></span>
                                                </a>
                                            </li>
                                        <?php } ?>
                                    <?php } ?>
                                </ul>
                            <?php } ?>
                        </a>
                    </li>
                <?php } ?>
            <?php } ?>
        </ul>
    </div>
    <div class="content-right content-right-<?= $_COOKIE['left-content-state'] ?? 'open' ?>">
        <nav class="navbar navbar-<?= $_COOKIE['left-content-state'] ?? 'open' ?> navbar-inverse navbar-fixed-top">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button style="display: block" class="navbar-toggle map-signs"
                            data-state="<?= $_COOKIE['left-content-state'] ?? 'open' ?>">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </div>

                <div id="navbar" class="navbar-collapse collapse">
                    <ul class="nav navbar-nav navbar-right">
                        <?php foreach (assets('menu') as $k => $item) { ?>
                            <?php if (!isset($item['access']) || $item['access'] == false || can($item['access'])) { ?>
                                <li <?= isset($item['menu']) ? 'class="dropdown"' : '' ?>>
                                    <a href="<?= $item['url'] ?>" class="dropdown-toggle" data-toggle="dropdown">
                                        <span><?= $item['name'] ?></span>
                                        <?php if (isset($item['menu'])){ ?>
                                            <span class="caret"></span>
                                        <?php } ?>
                                    </a>
                                    <?php if (isset($item['menu'])) { ?>
                                        <ul class="dropdown-menu">
                                            <?php foreach ($item['menu'] as $key => $inner) { ?>
                                                <?php if (!isset($inner['access']) || $inner['access'] == false || can($inner['access'])) { ?>
                                                    <li>
                                                        <a href="<?= $inner['url'] ?>">
                                                            <span><?= $inner['name'] ?></span>
                                                        </a>
                                                    </li>
                                                <?php } ?>
                                            <?php } ?>
                                        </ul>
                                    <?php } ?>
                                </li>
                            <?php } ?>
                        <?php } ?>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <span id="theme-name">
                                <?= assets('themes')[user()->theme]['name'] ?>
                            </span>
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu" role="menu">
                                <?php foreach (assets('themes') as $key => $item) { ?>
                                    <li>
                                        <a class="change-theme"
                                           data-href="<?= $item['href'] ?>"
                                           data-name="<?= $item['name'] ?>"
                                           data-theme="<?= $key ?>">
                                            <?= $item['name'] ?>
                                        </a>
                                    </li>
                                <?php } ?>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <i class="fa fa-user"></i> <?= user()->login; ?>
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu" role="menu">
                                <li>
                                    <a href="<?= uri('user', ['section' => 'instruction']) ?>">
                                        Посадова інструкція
                                    </a>
                                </li>
                                <li>
                                    <a href="<?= uri('schedule', ['section' => 'view']) ?>">
                                        Мій графік роботи
                                    </a>
                                </li>
                                <li>
                                    <a data-type="pin_code" href="#" data-href="<?= uri('reports', ['section' => 'my']) ?>">
                                        Мої звіти
                                    </a>
                                </li>
                                <li>
                                    <a href="<?= uri('task', ['section' => 'list', 'user' => user()->id]) ?>">
                                        Мої задачі
                                    </a>
                                </li>
                                <li>
                                    <a href="<?= uri('user', ['section' => 'profile']) ?>">
                                        Профіль
                                    </a>
                                </li>
                                <li class="divider"></li>
                                <li>
                                    <a href="<?= uri('exit.php') ?>">
                                        Вихід
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="content-page">
<?php if (isset($breadcrumbs)) { ?>
    <?php include parts('breadcrumbs') ?>
<?php } ?>