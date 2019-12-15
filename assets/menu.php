<?php

return [
    [
        'name' => 'Панель управління',
        'url' => uri('/'),
        'access' => false,
        'icon' => 'dashboard',
    ],
    [
        'name' => 'Каталог',
        'url' => '#',
        'access' => false,
        'icon' => 'book',
        'menu' => [
            [
                'name' => 'Закупки',
                'url' => uri('purchases'),
                'access' => 'purchases',
            ],
            [
                'name' => 'Інвентаризація',
                'url' => uri('inventory'),
                'access' => 'inventory',
            ],
            [
                'name' => 'Категорії',
                'url' => uri('category'),
                'access' => 'category',
            ],
            [
                'name' => 'Постачальники',
                'url' => uri('manufacturer'),
                'access' => 'manufacturer',
            ],
            [
                'name' => 'Товари',
                'url' => uri('product'),
                'access' => 'product',
            ],
            [
                'name' => 'Активи',
                'url' => uri('product?section=assets'),
                'access' => 'product',
            ],
            [
                'name' => 'Склади',
                'url' => uri('storage'),
                'access' => 'storage',
            ]
        ]
    ],
    [
        'name' => 'Замовлення',
        'url' => '#',
        'access' => 'orders',
        'icon' => 'shopping-basket',
        'menu' => [
            [
                'name' => 'Доставки',
                'url' => uri('orders/view', ['type' => 'delivery'])
            ],
            [
                'name' => 'Відправки',
                'url' => uri('orders/view', ['type' => 'sending'])
            ],
            [
                'name' => 'Самовивози',
                'url' => uri('orders/view', ['type' => 'self'])
            ],
        ]
    ],
    [
        'name' => 'Інше',
        'url' => '#',
        'access' => false,
        'icon' => 'cogs',
        'menu' => [
            [
                'name' => 'Налаштування',
                'url' => uri('settings'),
                'access' => 'settings'
            ],
            [
                'name' => 'Статистика',
                'url' => uri('statistic'),
                'access' => 'statistic'
            ],
            [
                'name' => 'Відпустки',
                'url' => uri('vacation'),
                'access' => 'vacation'
            ],
            [
                'name' => 'Транзакції',
                'url' => uri('pb'),
                'access' => 'transactions'
            ],
            [
                'name' => 'Логи',
                'url' => uri('log'),
                'access' => 'logs'
            ],
        ]
    ],
    [
        'name' => 'Менеджери',
        'url' => uri('users'),
        'icon' => 'users',
        'access' => 'users',
        'menu' => [
            [
                'name' => 'Доступ',
                'url' => uri('access'),
                'access' => 'ROOT'
            ],
            [
                'name' => 'Список',
                'url' => uri('user',['section' => 'list']),
                'access' => 'ROOT'
            ],
            [
                'name' => 'Посади',
                'url' => uri('position'),
                'access' => 'ROOT'
            ],
            [
                'name' => 'Графыки роботи',
                'url' => uri('schedule', ['section' => 'users']),
                'access' => 'ROOT'
            ],
        ]
    ],
    [
        'name' => 'Адмін',
        'url' => '#',
        'icon' => 'cogs',
        'access' => 'ROOT',
        'menu' => [
            [
                'name' => 'PhpMyAdmin',
                'url' => uri('phpmyadmin/index.php'),
                'access' => 'ROOT'
            ],
            [
                'name' => 'Файл менеджер',
                'url' => uri('explorer/index.php'),
                'access' => 'ROOT'
            ],
            [
                'name' => 'Команди',
                'url' => uri('commands'),
                'access' => 'ROOT'
            ]
        ]
    ]
];