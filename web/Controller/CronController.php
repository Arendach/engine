<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Cron\Runner;

class CronController extends Controller
{
    public $exception = true;

    public function section_month(): void
    {
        new Runner('month');
    }

    public function section_day(): void
    {
        new Runner('day');
    }

    public function section_hour(): void
    {
        new Runner('hour');
    }
}