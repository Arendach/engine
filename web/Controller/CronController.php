<?php

namespace Web\Controller;

use Web\App\Backup;
use Web\App\Controller;
use Web\Model\Clients;
use Web\Model\Orders;
use Web\Model\Reports;
use Web\Model\Sms;
use Web\Model\User;

class CronController extends Controller
{
    /**
     * @var bool
     */
    public $exception = true;

    /**
     * Створення нових звітів для кожного менеджера!!!
     */
    public function report()
    {
        $report_model = new Reports();
        $report_model->createReportFromUsers();
    }

    public function section_task_manager()
    {
        $data = [
            'title' => 'Cron Task Manager',
        ];
    }

    /**
     * Бекап бази даних
     */
    public function backup()
    {
        Backup::init();
    }

    /**
     * Очищення кешу і тимчасових файлів
     */
    public function clean()
    {
        dir_clean(ROOT . '/cache/');
        dir_clean(ROOT . '/server/export/');
        dir_clean(ROOT . '/server/logs/');
        dir_clean(ROOT . '/server/temp_files');
    }

    /**
     * Оновлення статусів доставок
     */
    public function update_sending_status()
    {
        Orders::updateSendingStatus();
    }

    public function section_sms()
    {
        Sms::updateStatusesOpenOrders();
    }

    public function statistic()
    {

    }

    public function section_month()
    {
        Clients::bonuses();
        echo date_for_humans() . ' - Бонуси за роботу з івентами нараховано!' . PHP_EOL;
        $this->report();
        echo date_for_humans() . ' - Звіти заведені!';
    }

    public function section_day()
    {
        $this->clean();
        $this->backup();
        echo date_for_humans() . ' - Кеш очищений, бекап виконаний!';
    }

    public function section_hour()
    {
        $this->section_sms();
        echo 'Статуси СМС оновлені!<br>';
        $this->update_sending_status();
        echo 'Статуси доставок оновлені!<br>';
        User::clean_session();
        echo 'Сесії очищені<br>';
    }

    public function section_normalize_report()
    {
        $year = get('year') ? get('year') : date('Y');
        $month = get('month') ? get('month') : date('m');

        $model = new Reports();

        $model->normalizeCheck($year, $month);
    }
}