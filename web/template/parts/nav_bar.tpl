<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" id="map-signs" href="#"><i class="fa fa-map-signs"></i></a>
            <a class="navbar-brand" href="#">Система управління WMS</a>
        </div>

        <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right">
                <li>
                    <a href="<?= uri('dialog') ?>">
                        <i class="fa fa-envelope"></i>
                        Пошта
                        <span style="color: red">
                            <sup>
                                <?php
                                //$nr = \Web\Model\Dialog::get_notification();
                                //echo $nr != 0 ? $nr : '';
                                ?>
                            </sup>
                        </span>
                    </a>
                </li>
                <?= can() ? '<li><a target="_blank" href="/explorer/index.php">Файловий менеджер</a></li>' : ''; ?>
                <?= can() ? '<li><a target="_blank" href="/phpmyadmin/index.php">PHPMyAdmin</a></li>' : ''; ?>
                <li>
                    <a href="#" class="dropdown-toggle"
                       data-toggle="dropdown"><i class="fa fa-user"></i> <?= user()->login; ?> <span
                                class="caret"></span></a>
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
