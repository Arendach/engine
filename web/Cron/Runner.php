<?php

namespace Web\Cron;

class Runner
{
    /**
     * @var string
     */
    private $response = '';

    /**
     * @var int
     */
    private $code = 200;

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
     * @param $command
     * @return array
     */
    private function parseCommand($command): array
    {
        $chunks = explode(' ', $command);

        if (!count($chunks)) {
            return [];
        }

        $command = array_shift($chunks);

        $params = [];
        foreach ($chunks as $chunk) {
            $p = explode('=', $chunk);
            $params[trim($p[0], '-')] = $p[1];
        }

        return [
            'command' => $command,
            'params' => $params
        ];
    }

    /**
     * @param string $period
     */
    private function runPeriod(string $period): void
    {
        foreach ($this->$period as $item)
            $this->runner($item, $period);

        $this->response = 'Задачі вдало виконані';
        $this->code = 200;
    }

    /**
     * @param string $command
     */
    private function runOne(string $command): void
    {
        $command = $this->parseCommand($command);

        $commands = $this->commands();

        if (isset($commands[$command['command']])) {
            $this->runner($commands[$command['command']], 'hand', $command['params']);
        } else {
            $this->response = 'Задача не знайдена';
            $this->code = 500;
        }
    }

    /**
     * @param string $command
     * @param string $period
     * @param array $params
     * @return string
     */
    private function runner(string $command, $period = 'hand', $params = []): string
    {
        /**
         * @var \Web\App\Cron $schedule
         */
        $schedule = new $command();

        $schedule->period = $period;
        $schedule->before($params);
        $schedule->run();

        $this->response = $schedule->after();
        $this->code = $schedule->getCode();

        return $this->response;
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

    /**
     * @return int
     */
    public function getCode(): int
    {
        return $this->code;
    }
}