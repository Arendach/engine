<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\App\Log;
use Web\Tools\Log as ToolLog;

class LogController extends Controller
{
    public function write($data)
    {
        Log::parse_ajax_log($data);
    }

    public function section_main()
    {
        $data = [
            'title' => 'Логи',
            'breadcrumbs' => [['Логи']]
        ];

        $this->view->display('log.main', $data);
    }

    public function section_new_post()
    {
        $tool_log = new ToolLog();

        $logs = $tool_log->getNewPostLogs();

        krsort($logs);

        $data = [
            'title' => 'Логи :: Нова Пошта',
            'breadcrumbs' => [['Логи', uri('log')], ['Нова Пошта']],
            'logs' => $logs,
            'tool_log' => $tool_log
        ];

        $this->view->display('log.new_post', $data);
    }
}