<?php

namespace Web\Controller;

use RedBeanPHP\R;
use Web\App\Controller;
use Web\Model\Orders;
use Web\Model\Sms;
use Mobizon\MobizonApi;

class SmsController extends Controller
{
    public function section_templates()
    {
        if (cannot('settings')) $this->display_403();

        $data = [
            'title' => 'Налаштування :: Смс шаблони',
            'components' => ['modal'],
            'items' => Sms::getAll(),
            'scripts' => ['sms.js'],
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Смс шаблони']]
        ];

        $this->view->display('sms.templates', $data);
    }

    public function action_update($post)
    {
        Sms::update($post, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_delete($post)
    {
        Sms::delete($post->id);

        response(200, DATA_SUCCESS_DELETED);
    }

    public function action_create_form()
    {
        $this->view->display('sms.create_form');
    }

    public function action_create($post)
    {
        if ($post->name == '') response(400, 'Заповніть назву шаблону!');
        if ($post->text == '') response(400, 'Заповніть текст шаблону!');

        Sms::insert($post);

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_prepare_template($post)
    {
        $order = Orders::getOrderById($post->order_id);
        $template = Sms::getOne($post->template_id);
        $site = R::load('sites', $order->site);
        $site_name = isset($site->name) ? $site->name : '';
        $site_url = isset($site->url) ? $site->url : '';

        $patterns = [
            ['@date@', date_for_humans(date('Y-m-d'))],
            ['@date2@', date('Y-m-d')],
            ['@datetime@', date('Y-m-d H:i:s')],
            ['@ttn@', $order->street],
            ['@delivery_cost@', $order->delivery_cost],
            ['@discount@', $order->discount],
            ['@sum@', $order->full_sum],
            ['@time_with@', string_to_time($order->time_with)],
            ['@time_to@', string_to_time($order->time_to)],
            ['@id@', $order->id],
            ['@date_delivery@', $order->date_delivery],
            ['@full_sum@', $order->full_sum],
            ['@site_name@', $site_name],
            ['@site_url@', $site_url]
        ];

        $result = $template->text;
        foreach ($patterns as $pattern) {
            $result = preg_replace("/{$pattern[0]}/", $pattern[1], $result);
        }

        echo $result;
    }

    public function action_send_message($post)
    {
        $api = new MobizonApi(SMS_API_KEY);

        $parameters = [
            'recipient' => get_number_world_format($post->phone),
            'text' => trim($post->text),
            'from' => 'SkyFire'
        ];

        if ($api->call('message', 'sendSMSMessage', $parameters)) {

            Sms::save_log([
                'order_id' => $post->order_id,
                'phone' => get_number_world_format($post->phone),
                'message_id' => $api->getData('messageId'),
                'text' => $post->text,
                'date' => date('Y-m-d H:i:s'),
            ]);

            response(200, 'SMS повідомлення надіслано!');

        } else {
            $message = 'Помилка!<br>';
            $message .= $api->getMessage() . '<br>';
            $message .= 'Повідомлення не надіслано!<br>';

            response(400, $message);
        }
    }

}