<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

class OrderSettings extends Model
{
    public static function statuses($type)
    {
        $arr = [];
        switch ($type) {
            case 'sending':

                // Відправки
                $arr = [
                    '0' => get_object([
                        'text' => 'На доставку',
                        'color' => '#0fa80f',
                    ]),
                    '1' => get_object([
                        'text' => 'Доставляється',
                        'color' => '#0c0cf5',
                    ]),
                    '2' => get_object([
                        'text' => 'Відмінено', // відмінили з якихось причин. Товари відповідно повертаються по БД
                        'color' => '#ff0',
                    ]),
                    '3' => get_object([
                        'text' => 'Повернено', // Товари відповідно повертаються по БД
                        'color' => '#0f0',
                    ]),
                    '4' => get_object([
                        'text' => 'Виконано',
                        'color' => '#c2062c',
                    ])
                ];


                break;
            case 'shop':

                // МАГАЗИН
                $arr = [
                    '0' => get_object([
                        'text' => 'Доставляється',
                        'color' => '#0fa80f',
                    ]),
                    '2' => get_object([
                        'text' => 'Виконано',
                        'color' => '#c2062c',
                    ]),
                    '1' => get_object([
                        'text' => 'Повернено', // Товари відповідно повертаються по БД
                        'color' => '#0f0',
                    ])
                ];


                break;
            case 'self':

                // Самовивіз
                $arr = [
                    '0' => get_object([
                        'text' => 'На доставку', // нове замовлення, що потрібно доставити
                        'color' => '#0fa80f',
                    ]),
                    '1' => get_object([
                        'text' => 'Доставляється', // видали курьєру, поїхав доставляти
                        'color' => '#0c0cf5',
                    ]),
                    '2' => get_object([
                        'text' => 'Відмінено', // відмінили з якихось причин. Товари відповідно повертаються по БД
                        'color' => '#ff0',
                    ]),
                    '3' => get_object([
                        'text' => 'Повернено', // Товари відповідно повертаються по БД
                        'color' => '#0f0',
                    ]),
                    '4' => get_object([
                        'text' => 'Виконано',   // товар доставлено, гроші отримано, гроші зарахувалися у звіт менеджера,
                        // що поставив статус - Виконано
                        'color' => '#c2062c',
                    ])
                ];
                break;
            case 'delivery':

                // Доставки
                $arr = [
                    '0' => get_object([
                        'text' => 'На доставку', // нове замовлення, що потрібно доставити
                        'color' => '#0fa80f',
                    ]),
                    '1' => get_object([
                        'text' => 'Доставляється', // видали курьєру, поїхав доставляти
                        'color' => '#0c0cf5',
                    ]),
                    '2' => get_object([
                        'text' => 'Відмінено', // відмінили з якихось причин. Товари відповідно повертаються по БД
                        'color' => '#ff0',
                    ]),
                    '3' => get_object([
                        'text' => 'Повернено', // Товари відповідно повертаються по БД
                        'color' => '#0f0',
                    ]),
                    '4' => get_object([
                        'text' => 'Виконано',   // товар доставлено, гроші отримано, гроші зарахувалися у звіт менеджера,
                        // що поставив статус - Виконано
                        'color' => '#c2062c',
                    ])
                ];
                break;
        }
        return $arr;
    }

    public static function regions()
    {
        return [
            'Голосіївський',
            'Оболонський',
            'Печерський',
            'Подільський',
            'Святошинський',
            'Солом\'янський',
            'Шевченківський',
            'Дарницький',
            'Деснянський',
            'Дніпровський'
        ];
    }

    public static function sending_statuses($key = false)
    {
        $statuses = [
            '1' => [
                'text' => 'Нова пошта очікує надходження від відправника',
                'color' => '#000'
            ],
            '2' => [
                'text' => 'Видалено',
                'color' => '#000'
            ],
            '3' => [
                'text' => 'Номер не знайдено',
                'color' => '#000'
            ],
            '4' => [
                'text' => 'Відправлення у місті(4)',
                'color' => '#000'
            ],
            '41' => [
                'text' => 'Відправлення у місті(41)',
                'color' => '#000'
            ],
            '5' => [
                'text' => 'Відправлення прямує до міста',
                'color' => '#000'
            ],
            '6' => [
                'text' => 'Відправлення у місті(6)',
                'color' => '#000'
            ],
            '7' => [
                'text' => 'Прибув на відділення(7)',
                'color' => '#000'
            ],
            '8' => [
                'text' => 'Прибув на відділення(8)',
                'color' => '#000'
            ],
            '9' => [
                'text' => 'Відправлення отримано(9)',
                'color' => '#000'
            ],
            '10' => [
                'text' => 'Відправлення отримано! Протягом доби ви одержите SMS-повідомлення про надходження грошового переказу та зможете отримати його в касі відділення «Нова пошта»',
                'color' => '#000'
            ],
            '11' => [
                'text' => 'Відправлення отримано. Грошовий переказ видано одержувачу',
                'color' => '#000'
            ],
            '14' => [
                'text' => 'Відправлення передано до огляду отримувачу',
                'color' => '#000'
            ],
            '101' => [
                'text' => 'На шляху до одержувача',
                'color' => '#000'
            ],
            '102' => [
                'text' => 'Відмова одержувача(102)',
                'color' => '#000'
            ],
            '103' => [
                'text' => 'Відмова одержувача(103)',
                'color' => '#000'
            ],
            '108' => [
                'text' => 'Відмова одержувача(108)',
                'color' => '#000'
            ],
            '104' => [
                'text' => 'Змінено адресу',
                'color' => '#000'
            ],
            '105' => [
                'text' => 'Припинено зберігання',
                'color' => '#000'
            ],
            '106' => [
                'text' => 'Одержано і є ТТН грошовий переказ',
                'color' => '#000'
            ],
            '107' => [
                'text' => 'Нараховується плата за зберігання',
                'color' => '#000'
            ]
        ];

        if ($key === false)
            return $statuses;
        else
            return isset($statuses[$key]) ? $statuses[$key] : ['text' => 'Невідомо', 'color' => '#000'];
    }

    public static function update_currency($post)
    {
        foreach ($post as $id => $currency) {
            $bean = R::load('course', $id);
            $bean->currency = $currency;
            R::store($bean);
        }

        response(200, 'Дані вдало оновлені!');
    }

    public static function getCourse()
    {
        $result = R::findOne('course', '`code` = ?', [setting('currency')]);
        return $result['currency'];
    }

    public static function sendingVariants()
    {
        return [
            '1' => [
                'name' => 'Наложений платіж за все платить отримувач',
                'params' => [
                    // Форма оплати imposed | on_the_card
                    // для другого пункта немаэ прописаної логіки
                    'form_delivery' => 'imposed',

                    // Доставку оплачує
                    // Отримувач - recipient
                    // Відправник - sender
                    'pay_delivery' => 'recipient',

                    // Тип зворотньої доставки
                    // none - Немає
                    // remittance - Грошовий переказ
                    // documents - Документи(* Не підтримується)
                    // other - Інше(* Не підтримується)
                    'type' => 'remittance',

                    // Грошовий переказ
                    // imposed - На відділення
                    // on_the_card - На карту(* Не підтримується)
                    'type_remittance' => 'imposed',

                    // Платник зворотньої доставки
                    // sender - Відправник
                    // receiver - Отримувач
                    'payer' => 'receiver'
                ]
            ],
            '2' => [
                'name' => 'За доставку ми, грошовий переказ отримувач',
                'params' => [
                    'form_delivery' => 'imposed', //
                    'pay_delivery' => 'sender',
                    'type' => 'remittance',
                    'type_remittance' => 'imposed', //
                    'payer' => 'receiver'
                ]
            ],
            '3' => [
                'name' => 'За доставку і грошовий переказ плптимо ми',
                'params' => [
                    'form_delivery' => 'imposed', //
                    'pay_delivery' => 'sender',
                    'type' => 'remittance',
                    'type_remittance' => 'imposed', //
                    'payer' => 'sender'
                ]
            ],
            '4' => [
                'name' => 'Оплата на карту, за доставку платимо ми',
                'params' => [
                    'form_delivery' => 'imposed', //
                    'pay_delivery' => 'sender',
                    'type' => 'none',
                    'type_remittance' => 'imposed', //
                    'payer' => 'sender'
                ]
            ],
            '5' => [
                'name' => 'Оплата на карту, за доставку платить отримувач',
                'params' => [
                    'form_delivery' => 'imposed', //
                    'pay_delivery' => 'recipient',
                    'type' => 'none',
                    'type_remittance' => 'imposed', //
                    'payer' => 'sender'
                ]
            ],
            '6' => [
                'name' => 'Адресна доставка',
                'params' => null
            ]
        ];
    }

    public static function getSendingVariant($id): array
    {
        $variants = static::sendingVariants();

        if (isset($variants[$id])) {
            return $variants[$id];
        } else {
            return [
                'name' => 'Не найдено',
                'params' => null
            ];
        }
    }
}
