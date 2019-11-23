<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

class Task extends Model
{
    const table = 'tasks';

    public static function findByUser($user)
    {
        $sql = '`user` = ?';
        if (get('status') !== false) $sql .= ' AND success = \'' . get('status') . '\'';

        if (get('id')) $sql .= ' AND `id` = \'' . get('id') . '\'';

        $sql .= ' ORDER BY id DESC';
        return R::findAll('tasks', $sql, [$user]);
    }

    public static function getMyTasks()
    {
        return R::findAll('tasks', 'user = ? AND success = 0', [user()->id]);
    }

    public static function approve_task($post)
    {
        $task = R::load('tasks', $post->id);

        if ($task->success != 1) response(500, 'Задача не виконана!');
        if ($task->approve == 1) response(500, 'Задача підтверджена!');

        $bonuses = R::dispense('bonuses');
        $bonuses->data = $post->id;
        $bonuses->type = 'bonus';
        $bonuses->sum = $task->price;
        $bonuses->user_id = $task->user;
        $bonuses->date = date('Y-m-d H:i:s');
        $bonuses->source = 'task';
        R::store($bonuses);

        if (!R::count('work_schedule_month', 'user = ? AND month = ? AND year = ?', [$task->user, date('m'), date('Y')])){
            Schedule::create_schedule(date('Y'), date('m'), $task->user);
        }

        $wsm = R::findOne('work_schedule_month', 'user = ? AND month = ? AND year = ?', [$task->user, date('m'), date('Y')]);
        $wsm->bonus += $task->price;
        R::store($wsm);

        $task->approve = 1;
        R::store($task);

        response(200, 'Дані вдало збережено!');
    }

}