<?php

namespace Web\Model;

use RedBeanPHP\R;
use Web\App\Security;
use Web\App\ Model;

class User extends Model
{
    const  table = 'users';

    /**
     * @return bool|\RedBeanPHP\OODBBean
     */
    public static function getMe()
    {
        if (isset($_COOKIE['session'])) {
            $session = R::findOne('users_session', '`session` = ?', [$_COOKIE['session']]);
            $user = R::load('users', $session->user_id);

            if ($session->session == my_hash($user->login . $user->password . $_SERVER['HTTP_USER_AGENT'])) {
                return $user;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Обробка форми авторизації
     * @param $data
     */
    public static function post_login($data)
    {
        if (R::count('users', '`login` = ? AND `password` = ?', [$data->login, my_hash($data->password)])) {
            $user = R::findOne('users', '`login` = ? AND `password` = ?', [$data->login, my_hash($data->password)]);

            $bean = R::xdispense('users_session');

            $bean->session = my_hash($user->login . $user->password . $_SERVER['HTTP_USER_AGENT']);
            $bean->created = date('Y-m-d H:i:s');
            $bean->user_id = $user->id;

//            http_status(500);
//            dd($bean);
            R::store($bean);

            setcookie('session', my_hash($user->login . $user->password . $_SERVER['HTTP_USER_AGENT']));

            response(200);
        } else {
            response(400, 'Введені вами пароль або логін не вірні!');
        }
    }

    /**
     * @param $post
     */
    public static function register($post)
    {
        $bean = R::dispense('users');
        foreach ($post as $key => $value)
            $bean->$key = $value;

        $bean->password = my_hash($post->password);
        $bean->created_at = date('Y-m-d H:i:s');
        $bean->updated_at = date('Y-m-d H:i:s');
        R::store($bean);

        response(200, 'Дані успішно збережено!');
    }

    /**
     * RESET PASSWORD
     * @param $email
     */
    public static function reset($email)
    {
        if (!R::count('users', '`email` = ?', [$email]))
            response(400, 'Такий E-Mail не зареєстрований!');

        $password = Security::generateCode();

        $bean = R::findOne('users', '`email` = ?', [$email]);
        $bean->password = my_hash($password);
        R::store($bean);

        $subject = 'Скидання паролю';
        $message = date('Y-m-d') . " Ваш новий пароль: \"$password\"";
        $headers = 'From: roma4891@ukr.net' . "\r\n" .
            'Reply-To: roma4891@ukr.net' . "\r\n" .
            'X-Mailer: PHP/' . phpversion();

        mail($email, $subject, $message, $headers);
        response(200, '');
    }

    /**
     * @param $id
     * @return mixed
     */
    public static function getAccess($id)
    {
        return R::load('users_access', $id);
    }

    /**
     * @return array
     */
    public static function getItems()
    {
        $users = R::findAll('users', 'archive = 0');

        foreach ($users as $user) {
            $users[$user->id]->delivery = R::count('orders', "type = 'delivery' AND courier = ? AND status IN(0,1)", [$user->id]);
            $users[$user->id]->self = R::count('orders', "type = 'self' AND courier = ? AND status IN(0,1)", [$user->id]);
            $users[$user->id]->sending = R::count('orders', "type = 'sending' AND courier = ? AND status IN(0,1)", [$user->id]);
            $users[$user->id]->shop = R::count('orders', "type = 'shop' AND courier = ? AND status = 0", [$user->id]);
        }

        return $users;
    }

    public static function clean_session()
    {
        R::exec('DELETE FROM `users_session` WHERE UNIX_TIMESTAMP(`created`) + ? < ? + 0', [AUTH_TIME, time()]);
    }
}
