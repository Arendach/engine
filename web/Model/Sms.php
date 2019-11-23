<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;
use Mobizon\MobizonApi;

class Sms extends Model
{
    const table = 'sms_templates';

    public static function getAllByType($type)
    {
        return R::findAll('sms_templates', '`type` = ?', [$type]);
    }

    public static function save_log($params)
    {
        self::insert($params, 'sms_messages');
    }

    public static function getMessagesByOrderId($id)
    {
        // $api = new MobizonApi(SMS_API_KEY);
        $messages = R::findAll('sms_messages', '`order_id` = ?', [$id]);

        return $messages;
        $arr = [];
        foreach ($messages as $message) $arr[] = $message->message_id;

        $MS = $api->call('message', 'getSMSStatus', ['ids' => implode(',', $arr)], [], true);

        $new = [];
        foreach ($messages as $k => $message) {
            $new[] = $message;
            if (empty($MS)) {
                $message['status'] = 'Немає відповіді';
            } else {
                foreach ($MS as $item) {
                    if ($item->id == $message->message_id) {
                        $message['status'] = $item->status;
                    }
                }
            }
        }

        return $messages;
    }


    public static function updateStatusesOpenOrders()
    {
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
    }
}