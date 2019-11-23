<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Model\Dialog;

class DialogController extends Controller
{
    public $middleware = ['users_list_init'];

    public function section_main()
    {
        $data = [
            'title' => 'Діалоги',
            'dialogs' => Dialog::getDialogs(),
            'css' => ['dialog.css', 'elements.css'],
            'scripts' => ['dialog.js', 'elements.js'],
            'components' => ['jquery'],
            'not_read' => Dialog::get_notification('array')
        ];

        $this->view->display('dialog.main', $data);
    }

    public function section_view($get)
    {
        // Провірка на існування діалогу
        if (!isset($get->dialog_id)) $this->display_404();

        // Провірка доступу
        if (!Dialog::access_check(user()->id, $get->dialog_id)) $this->display_403();

        Dialog::delete_notification($get->dialog_id);

        $data = [
            'title' => 'Діалоги',
            'dialog' => Dialog::getOne($get->dialog_id),
            'components' => ['jquery'],
            'users' => Dialog::get_dialog_users($get->dialog_id),
            'messages' => Dialog::get_messages($get->dialog_id),
            'dialogs' => Dialog::getDialogs(),
            'css' => ['dialog.css', 'elements'],
            'scripts' => ['dialog.js', 'elements'],
            'not_read' => Dialog::get_notification('array'),
            'to_js' => [
                'dialog_id' => $get->dialog_id
            ]
        ];


        $this->view->display('dialog.view', $data);
    }

    public function section_task($get)
    {
        $dialog = Dialog::exists_task_dialog($get->task_id);

        if ($dialog != false)
            $dialog_id = $dialog;
        else
            $dialog_id = Dialog::create_task_dialog($get->task_id);

        redirect('/dialog'.parameters(['section' => 'view', 'dialog_id' => $dialog_id]));
    }


    public function action_send_text_message($post)
    {
        if (!isset($post->message) || empty($post->message)) response(400, 'Заповніть повідомлення!');

        Dialog::send_message($post);
    }

    public function action_send_youtube_message($post)
    {
        if (!isset($post->link) || empty($post->link)) response(400, 'Заповніть ссилку!');

        if (preg_match('@^[\w\d]+$@', $post->link)) $link = $post->link;

        $link = parse_url($post->link);
        $post->link = ltrim($link['path'], '/');

        Dialog::send_youtube_message($post);
    }

    public function action_send_file($post)
    {
        if(isset($_FILES['upl']) && $_FILES['upl']['error'] == 0){
            $file_array = $_FILES['upl'];

            if ($file_array['error'] != 0) response(400, 'Помилка! Файл не завантажено!');

            if($file_array['size'] > 20000000) response(400, 'Розмір файлу не може перевищувати 20Мб');

            $name = $file_array['name'];
            $path = '/server/uploads/dialogs/files/' . date('His') . rand(100, 999) . '/';

            mkdir(ROOT . $path,0777,true);

            if(move_uploaded_file($_FILES['upl']['tmp_name'], ROOT . $path . $name)){
                Dialog::send_file_message($post, $path . $name);
            } else {
                response(400, 'Файл вдало завантажено!');
            }
        } else {
            response(400, 'Виберіть файл!');
        }
    }

    public function action_send_photo($post)
    {
        $allowed = array('png', 'jpg', 'gif','jpeg', 'bmp');

        if(isset($_FILES['photo']) && $_FILES['photo']['error'] == 0){
            $file_array = $_FILES['photo'];

            $extension = pathinfo($file_array['name'], PATHINFO_EXTENSION);

            if(!in_array(strtolower($extension), $allowed)){
                response(400, 'Дозволено вивантажувати тільки фото!');
            }

            if ($file_array['error'] != 0) response(400, 'Помилка! Файл не завантажено!');

            if($file_array['size'] > 20000000) response(400, 'Розмір файлу не може перевищувати 20Мб');

            $name = $file_array['name'];
            $path = '/server/uploads/dialogs/photos/' . date('His') . rand(100, 999) . '/';

            mkdir(ROOT . $path,0777,true);

            if(move_uploaded_file($file_array['tmp_name'], ROOT . $path . $name)){
                Dialog::send_photo_message($post, $path . $name);
            } else {
                response(400, 'Файл вдало завантажено!');
            }
        } else {
            response(400, 'Виберіть файл!');
        }
    }

    public function action_create_dialog($post)
    {
        if (my_count($post->users) < 1) response(400, 'Виберіть хоча-б одного користувача!');
        if (empty($post->name)) response(400, 'Введіть назу діалогу!');
        if (empty($post->message)) response(400, 'Введіть повідомлення!');

        $post->type = 'dialog';
        $post->data = '';

        Dialog::create_dialog($post);
    }

    public function action_search_new_message($post)
    {
        $users = Dialog::get_dialog_users($post->dialog_id);

        foreach (Dialog::search_new_message($post->dialog_id, $post->last_message) as $message) {
            include t_file('dialog.message_types.' . $message->type);
        }
    }
}

?>
