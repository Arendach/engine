<?php

namespace Web\Cron;

use Web\App\Cron;
use Exception;
use RedBeanPHP\R;
use Web\Model\Schedule;

class BonusesFromClients extends Cron
{
    /**
     * @var string
     */
    public $description = 'Бонуси за роботу з івентами вдало нараховано';

    /**
     * @var string
     */
    public static $handDesc = 'Нарахувати бонуси за роботу з івентами';

    /**
     * @return void
     */
    public function run(): void
    {
        try {
            $date = time() - 60 * 60 * 24 * 20;

            $orders = R::findAll('orders', 'YEAR(date) = ? AND MONTH(date) = ? AND status = 4', [date('Y', $date), date('m', $date)]);

            $temp = [];
            foreach ($orders as $order) {
                if (R::count('client_orders', 'order_id = ?', [$order->id])) {
                    $client_id = (R::findOne('client_orders', 'order_id = ?', [$order->id]))->client_id;
                    $client = R::load('clients', $client_id);
                    if ($client->manager != 0) {
                        $temp[$order->id] = new \stdClass();
                        $temp[$order->id]->full_sum = $order->full_sum;
                        $temp[$order->id]->delivery_cost = $order->delivery_cost;
                        $temp[$order->id]->discount = $order->discount;
                        $temp[$order->id]->client_id = $client->id;
                        $temp[$order->id]->percentage = $client->percentage;
                        $temp[$order->id]->manager = $client->manager;
                    }
                }
            }

            if (count($temp) > 0) {
                foreach ($temp as $id => $item) {
                    if (R::count('bonuses', 'data = ? AND source = ?', [$id, 'event']))
                        continue;

                    $sum = ($item->full_sum + $item->delivery_cost - $item->discount) / 100 * $item->percentage;

                    if ($sum == 0) continue;

                    $bean = R::dispense('bonuses');

                    $bean->data = $id;
                    $bean->type = 'bonus';
                    $bean->sum = $sum;
                    $bean->user_id = $item->manager;
                    $bean->date = date('Y-m-d H:i:s');
                    $bean->source = 'event';

                    R::store($bean);

                    if (!R::count('work_schedule_month', 'user = ? AND month = ? AND year = ?', [$item->manager, date('m'), date('Y')])) {
                        Schedule::create_schedule(date('Y'), date('m'), $item->manager);
                    }

                    $wsm = R::findOne('work_schedule_month', 'user = ? AND month = ? AND year = ?', [$item->manager, date('m'), date('Y')]);
                    $wsm->bonus += $sum;
                    R::store($wsm);
                }
            }
        } catch (Exception $exception) {
            $this->error = 'Нарахування бонусів за роботу з постійними клієнтами не вдалось!' . PHP_EOL . $exception->getMessage() . PHP_EOL;
        }
    }
}