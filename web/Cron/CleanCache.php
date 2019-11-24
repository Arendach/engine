<?php

namespace Web\Cron;

use Web\App\Cron;
use Exception;

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
        try {
            $params = $this->getParams();

            if (!isset($params['year']))
                throw new Exception('Year not approved');

        } catch (Exception $exception) {
            $this->error = $exception->getMessage();
        }

        dir_clean(ROOT . '/cache/');
        dir_clean(ROOT . '/server/export/');
        dir_clean(ROOT . '/server/temp_files');
    }
}