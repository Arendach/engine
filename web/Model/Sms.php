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
}