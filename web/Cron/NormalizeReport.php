<?php

namespace Web\Cron;

use Web\App\Cron;
use Web\Model\Reports;
use Exception;

class NormalizeReport extends Cron
{
    /**
     * @var string
     */
    public $description = 'Звіти нормалізовані';

    /**
     * @var string
     */
    public static $handDesc = 'Нормалізувати звіти';

    /**
     * @var Reports
     */
    private $reportsModel;

    /**
     * NormalizeReport constructor.
     */
    public function __construct()
    {
        $this->reportsModel = new Reports();
    }

    /**
     * @return void
     */
    public function run(): void
    {
        try {
            $year = get('year') ? get('year') : date('Y');
            $month = get('month') ? get('month') : date('m');

            $this->reportsModel->normalizeCheck($year, $month);
        } catch (Exception $exception) {
            $this->error = 'Не вдалось нормалізувати звіти ' . PHP_EOL . $exception->getMessage() . PHP_EOL;
        }
    }
}