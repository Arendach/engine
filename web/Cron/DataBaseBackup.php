<?php

namespace Web\Cron;

use Web\App\Cron;
use Exception;
use Web\App\Backup;

class DataBaseBackup extends Cron
{
    /**
     * @var string
     */
    public $description = 'Бекап бази даних створений';

    /**
     * @var string
     */
    public static $handDesc = 'Створити бекап бази даних';

    /**
     * @return void
     */
    public function run(): void
    {
        try {
            Backup::init();
        } catch (Exception $exception) {
            $this->error = 'Не вдалось стоворити бекап бази даних!' . PHP_EOL . $exception->getMessage() . PHP_EOL;
        }
    }

}