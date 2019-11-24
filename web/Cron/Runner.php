<?php

namespace Web\Cron;

class Runner
{
    /**
     * @var string
     */
    private $response = '';

    /**
     * @var array
     */
    private $hour = [
        'sms-status-refresh' => SmsStatusRefresh::class,
        'update-sending-status' => UpdateSendingStatus::class,
        'clean-user-sessions' => CleanUserSessions::class,
    ];

    /**
     * @var array
     */
    private $day = [
        'data-base-backup' => DataBaseBackup::class,
        'clean-cache' => CleanCache::class,
    ];

    /**
     * @var array
     */
    private $month = [
        'reports-create-items' => ReportsCreateItems::class,
        'bonuses-from-clients' => BonusesFromClients::class,
    ];

    /**
     * @var array
     */
    private $hand = [
        'normalize-report' => NormalizeReport::class,
    ];

    /**
     * Runner constructor.
     * @param string $periodOrCommand
     */
    public function __construct(string $periodOrCommand)
    {
        if ($periodOrCommand == '')
            return;

        elseif (in_array($periodOrCommand, ['hour', 'day', 'month']))
            $this->runPeriod($periodOrCommand);

        else
            $this->runOne($periodOrCommand);
    }

    /**
     * @param string $period
     */
    private function runPeriod(string $period): void
    {
        foreach ($this->$period as $item)
            $this->runner($item, $period);

        $this->response = 'Задачі вдало виконані';
    }

    /**
     * @param string $command
     */
    private function runOne(string $command): void
    {
        $commands = $this->commands();

        if (isset($commands[$command]))
            $this->response = $this->runner($commands[$command], 'hand');
        else
            $this->response = 'Задача не знайдена';
    }

    /**
     * @param string $command
     * @param string $period
     */
    private function runner(string $command, $period = 'hand'): string
    {
        /**
         * @var \Web\App\Cron $schedule
         */
        $schedule = new $command();

        $schedule->period = $period;
        $schedule->before();
        $schedule->run();

        return $schedule->after();
    }

    /**
     * Команда => Опис
     * @return array
     */
    public function commands(): array
    {
        $commands = [];

        $commands = array_merge(
            $commands,
            $this->hour,
            $this->day,
            $this->month,
            $this->hand
        );

        return $commands;
    }

    /**
     * @return mixed
     */
    public function getResponse(): string
    {
        return $this->response;
    }
}