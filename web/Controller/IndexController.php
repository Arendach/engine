<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Model\Index;
use Web\Model\Notification;
use Web\Model\Products;
use Web\Model\Task;

class IndexController extends Controller
{
    public function index()
    {
        if (user()->schedule_notice) {
            $schedules = Index::work_schedule();
            $schedules_month = Index::work_schedules_month();
        } else {
            $schedules = 0;
            $schedules_month = ['work_schedules_month' => 0];
        }

        $data = [
            'title' => 'Адмінка',
            'section' => 'WMS Control Panel',
            'schedules' => $schedules,
            'schedules_month' => $schedules_month,
            'notification' => Notification::getNotification(),
            'nco' => Index::not_close_orders(),
            'moving_money' => Index::moving_money(),
            'not_moving_money' => Index::not_moving_money(),
            'tasks' => Task::getMyTasks(),
            'scripts' => ['reports.close_moving', 'index'],
            'components' => ['sweet_alert', 'modal'],
            'liable_orders' => Index::liable_orders(),
            'product_moving' => Products::findAll('product_moving', 'user_to = ? AND status = 0', [user()->id])
        ];

        $nco = $data['nco'];
        if ($nco->delivery == 0 && $nco->self == 0 && $nco->shop == 0 && $nco->sending == 0) {
            $data['nco'] = 0;
        }

        $this->view->display('index', $data);
    }
}

?>