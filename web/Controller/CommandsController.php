<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Cron\Runner;

class CommandsController extends Controller
{
    public function section_main()
    {
        $runner = new Runner('');

        $data = [
            'title' => 'Cron Task Manager',
            'commands' => $runner->commands(),
            'breadcrumbs' => [['Крон - Менеджер задач']]
        ];

        $this->view->display('cron.main', $data);
    }

    public function action_run($post)
    {
        $response = (new Runner($post->command))
            ->getResponse();

        response(200, [
            'message' => "<div>-- $response</div>"
        ]);
    }
}