<?php

namespace Web\Cron;

use Web\App\Cron;
use Exception;
use RedBeanPHP\R;
use Web\Model\Reports;

class ReportsCreateItems extends Cron
{
    /**
     * @var string
     */
    public $description = 'Звіти ініціалізовано';

    /**
     * @var string
     */
    public static $handDesc = 'Ініціалізувати звіти';

    /**
     * @var Reports
     */
    private $reportModel;

    /**
     * ReportsCreateItems constructor.
     */
    public function __construct()
    {
        $this->reportModel = new Reports();
    }

    /**
     * Run schedule
     *
     * @return void
     */
    public function run(): void
    {
        try {
            $users = R::findAll('users', 'archive = 0');

            foreach ($users as $user) {
                $this->reportModel->createReportIfNotExists($user->id);
            }
        } catch (Exception $exception) {
            $this->error = 'Помилка! Не вдалось ініціалізувати звіти! ' . PHP_EOL . $exception->getMessage() . PHP_EOL;
        }
    }
}