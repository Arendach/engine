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
        if (empty($post->command))
            response(400, ['message' => '<div style="color: red">Введіть команду</div>']);

        $runner = new Runner($post->command);

        $response = $runner->getResponse();
        $code = $runner->getCode();

        response($code, [
            'message' => "<div style='color: " . ($code == 200 ? 'white' : 'red') . "'>-- $response</div>"
        ]);
    }
}