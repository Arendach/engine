<?php

namespace Web\Cron;

use Web\App\Cron;

class CleanCache extends Cron
{
    /**
     * @var string
     */
    public $description = 'Системний кеш очищений';

    /**
     * @var string
     */
    public static $handDesc = 'Очистити системний кеш';

    /**
     * @return void
     */
    public function run(): void
    {
        dir_clean(ROOT . '/cache/');
        dir_clean(ROOT . '/server/export/');
        dir_clean(ROOT . '/server/temp_files');
    }
}