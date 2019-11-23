<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;

class Dialog extends Model
{
    const table = 'dialog';

    public static function getDialogs()
    {
        return get_object(R::getAll("
            SELECT 
                `dialog`.*,
                `dialog_access`.*,
                (
                    SELECT 
                        `dialog_message`.`data` 
                    FROM 
                        `dialog_message`
                    WHERE 
                        `dialog_message`.`dialog_id` = `dialog`.`id`
                    ORDER BY 
                        `dialog_message`.`id` DESC 
                    LIMIT 1
                ) AS `data`,
                (
                    SELECT 
                        `dialog_message`.`user_id` 
                    FROM 
                        `dialog_message`
                    WHERE 
                        `dialog_message`.`dialog_id` = `dialog`.`id`
                    ORDER BY 
                        `dialog_message`.`id` DESC 
                    LIMIT 1
                ) AS `user_id`,
                (
                    SELECT 
                        `dialog_message`.`type` 
                    FROM 
                        `dialog_message`
                    WHERE 
                        `dialog_message`.`dialog_id` = `dialog`.`id`
                    ORDER BY 
                        `dialog_message`.`id` DESC 
                    LIMIT 1
                ) AS `type`
            FROM
                `dialog_access`
            LEFT JOIN `dialog` ON(`dialog`.`id` = `dialog_access`.`dialog_id`)
            LEFT JOIN `dialog_message` ON(`dialog_message`.`dialog_id` = `dialog`.`id`)
            WHERE 
                `dialog_access`.`user_id` = :user_id
            GROUP BY `dialog`.`id`
            ORDER BY `dialog_message`.`id` DESC
            ", [':user_id' => user()->id]));
    }

    public static function get_dialog_users($dialog_id)
    {
        $beans = R::findAll('dialog_access', 'dialog_id = ?', [$dialog_id]);

        $users = [];
        foreach ($beans as $bean) {
            $users[$bean->user_id] = user($bean->user_id);
        }

        return $users;
    }

    public static function get_messages($dialog_id)
    {
        return R::findAll('dialog_message', 'dialog_id = ? ORDER BY id DESC', [$dialog_id]);
    }

    public static function get_notification($type = 'count')
    {
        if ($type == 'count') {
            return R::count('dialog_notification', 'user_id = ?', [user()->id]);
        } else {
            $result = R::findAll('dialog_notification', 'user_id = ?', [user()->id]);

            $new = [];
            foreach ($result as $item) {
                $new[] = $item->dialog_id;
            }

            return $new;
        }
    }

    public static function search_new_message($dialog_id, $last_message)
    {
        return R::findAll('dialog_message', '`id` > ? AND `dialog_id` = ?', [$last_message, $dialog_id]);
    }


    public static function send_message($post)
    {
        $bean = R::xdispense('dialog_message');
        $bean->dialog_id = $post->dialog_id;
        $bean->data = $post->message;
        $bean->user_id = user()->id;
        $bean->type = 'text';
        $bean->date = date('Y-m-d H:i:s');
        $id = R::store($bean);

        self::set_notifications($post->dialog_id);

        $message = '<div class="message-container message-me" data-id="' . $id . '"><span style="font-size: 12px">' . diff_for_humans(date('Y-m-d H:i:s')) . '</span><br><div class="message">' . $post->message . '</div></div>';
        response(200, $message);
    }

    public static function send_youtube_message($post)
    {
        $bean = R::xdispense('dialog_message');
        $bean->dialog_id = $post->dialog_id;
        $bean->data = $post->link;
        $bean->user_id = user()->id;
        $bean->type = 'youtube';
        $bean->date = date('Y-m-d H:i:s');
        $id = R::store($bean);

        self::set_notifications($post->dialog_id);

        $message = '<div class="message-container message-me" data-id="' . $id . '"><span style="font-size: 12px">' . diff_for_humans(date('Y-m-d H:i:s')) . '</span><br><div class="message"><iframe width="490" height="370" src="https://www.youtube.com/embed/' . $post->link . '" frameborder="0" allowfullscreen="allowfullscreen" data-link="https://www.youtube.com/watch?v=' . $post->link . '"></iframe></div></div>';
        response(200, $message);
    }

    public static function send_file_message($post, $file)
    {
        $bean = R::xdispense('dialog_message');
        $bean->dialog_id = $post->dialog_id;
        $bean->data = $file;
        $bean->user_id = user()->id;
        $bean->type = 'file';
        $bean->date = date('Y-m-d H:i:s');
        $id = R::store($bean);

        self::set_notifications($post->dialog_id);

        $message = '<div class="message-container message-me" data-id="' . $id . '"><span style="font-size: 12px">' . diff_for_humans(date('Y-m-d H:i:s')) . '</span><br><div class="message">Файл: <br><a download href="' . uri($file) . '">' . pathinfo($file, PATHINFO_BASENAME) . '</a></div></div>';

        response(200, $message);
    }

    public static function send_photo_message($post, $file)
    {
        $bean = R::xdispense('dialog_message');
        $bean->dialog_id = $post->dialog_id;
        $bean->data = $file;
        $bean->user_id = user()->id;
        $bean->type = 'photo';
        $bean->date = date('Y-m-d H:i:s');
        $id = R::store($bean);

        self::set_notifications($post->dialog_id);

        $message = '<div class="message-container message-me" data-id="' . $id . '"><span style="font-size: 12px">' . diff_for_humans(date('Y-m-d H:i:s')) . '</span><br><div class="message"><a download href="' . uri($file) . '"><img width="100%" src="' . uri($file) . '"></a></div></div>';


        response(200, $message);
    }

    public static function create_dialog($post, $response = true)
    {
        $users = get_array($post->users);
        $users = self::delete_me($users);
        $users[] = user()->id;

        if (my_count($users) < 2) response(400, 'Діалог повинен мати більше одного учасника!');

        $bean = R::dispense('dialog');
        $bean->name = $post->name;
        $bean->type = $post->type;
        $bean->data = $post->data;
        $bean->created_id = user()->id;
        $dialog_id = R::store($bean);

        $bean = R::xdispense('dialog_message');
        $bean->user_id = user()->id;
        $bean->dialog_id = $dialog_id;
        $bean->type = 'text';
        $bean->data = $post->message;
        $bean->date = date('Y-m-d H:i:s');
        R::store($bean);

        foreach ($users as $id) {
            $bean = R::xdispense('dialog_access');
            $bean->dialog_id = $dialog_id;
            $bean->user_id = $id;
            R::store($bean);

            $bean = R::xdispense('dialog_notification');
            $bean->dialog_id = $dialog_id;
            $bean->user_id = $id;
            R::store($bean);
        }

        if ($response)
            response(200, ['id' => $dialog_id]);
        else
            return $dialog_id;
    }

    public static function create_task_dialog($task_id)
    {
        $task = R::load('tasks', $task_id);

        $data = [
            'name' => 'Обговорення задачі №' . $task_id,
            'type' => 'task',
            'data' => $task_id,
            'users' => [$task->author, $task->user],
            'message' => 'Створено автоматично!'
        ];

        $data = get_object($data);

        return self::create_dialog($data, 0);
    }


    public static function access_check($user_id, $dialog_id)
    {
        return R::count('dialog_access', 'user_id = ? AND dialog_id = ?', [$user_id, $dialog_id]);
    }

    public static function exists_task_dialog($task_id)
    {
        if (R::count('dialog', 'type = ? AND data = ?', ['task', $task_id])) {
            $bean = R::findOne('dialog', 'type = ? AND data = ?', ['task', $task_id]);
            return $bean->id;
        } else {
            return false;
        }
    }


    public static function delete_notification($dialog_id)
    {
        R::exec('DELETE FROM `dialog_notification` WHERE `dialog_id` = ? AND `user_id` = ?', [$dialog_id, user()->id]);
    }


    private static function set_notifications($dialog_id)
    {
        foreach (self::get_dialog_users($dialog_id) as $user) {
            if ($user->id != user()->id) {
                $bean = R::xdispense('dialog_notification');
                $bean->user_id = $user->id;
                $bean->dialog_id = $dialog_id;
                R::store($bean);
            }
        }
    }

    private static function delete_me($users)
    {
        $temp = [];
        foreach ($users as $id) {
            if ($id != user()->id)
                $temp[] = $id;
        }

        return $temp;
    }
}