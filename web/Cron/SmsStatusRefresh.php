<?php

namespace Web\Cron;

use Web\App\Cron;
use Exception;
use RedBeanPHP\R;
use Mobizon\MobizonApi;

class SmsStatusRefresh extends Cron
{
    /**
     * @var string
     */
    public $description = 'Статуси смс оновлено!';

    /**
     * @var string
     */
    public static $handDesc = 'Оновити статуси СМС';

    /**
     * @return void
     */
    public function run(): void
    {
        try {
            $orders = R::findAll('orders', "`type` != 'shop' AND `status` IN(0,1) OR type = 'shop' AND `status` = 0");
            $api = new MobizonApi(SMS_API_KEY);

            foreach ($orders as $order) {
                $messages = R::findAll('sms_messages', '`order_id` = ?', [$order->id]);
                $arr = [];
                foreach ($messages as $message) $arr[] = $message->message_id;

                $MS = $api->call('message', 'getSMSStatus', ['ids' => implode(',', $arr)], [], true);

                if (!empty($MS)) {
                    foreach ($MS as $item) {
                        $bean = R::findOne('sms_messages', '`message_id` = ?', [$item->id]);
                        $bean->status = $item->status;
                        R::store($bean);
                    }
                }
            }
        } catch (Exception $exception) {
            $this->error = 'Помилка! Не вдалось оновити статуси смс! ' . PHP_EOL . $exception->getMessage() . PHP_EOL;
        }
    }
}