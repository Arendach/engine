<?php

namespace Web\Cron;

use Web\App\Cron;
use RedBeanPHP\R;
use Exception;

class CleanUserSessions extends Cron
{
    /**
     * @var string
     */
    public $description = 'Сесії користувачів очищені';

    /**
     * @var string
     */
    public static $handDesc = 'Очистити застарілі сесії користувачів';

    /**
     * @return void
     */
    public function run(): void
    {
        try {
            R::exec('DELETE FROM `user_session` WHERE UNIX_TIMESTAMP(`created`) + ? < ? + 0', [AUTH_TIME, time()]);
        } catch (Exception $exception) {
            $this->error = 'Не вдалось очистити сесії юзерів ' . PHP_EOL . $exception->getMessage() . PHP_EOL;
        }
    }
}