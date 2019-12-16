<?php
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