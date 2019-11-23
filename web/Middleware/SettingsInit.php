<?php

namespace Web\Middleware;

use Web\Model\Settings\Model;

class SettingsInit
{
    public function handle()
    {
        $GLOBALS['settings_init'] = Model::getSettings();
    }
}