<?php

namespace Web\Controller;

use RedBeanPHP\R;
use Web\App\Controller;
use Web\Model\Access;
use Web\Model\Position;
use Web\Model\User;

class UserController extends Controller
{
    public $access = 'users';

    public $allowed_methods = ['section_instruction'];

    public $main_section = 'section_list';

    public function section_login()
    {
        $this->view->display('login');
    }

    public function section_list()
    {
        $data = [
            'title' => 'Менеджери',
            'css' => ['users.css'],
            'breadcrumbs' => [['Менеджери']],
            'items' => User::getItems()
        ];

        $this->view->display('users.list', $data);
    }


    public function section_archive()
    {
        $data = [
            'title' => 'Менеджери :: Архів',
            'css' => ['users.css'],
            'breadcrumbs' => [
                ['Менеджери', uri('user')],
                ['Архів']
            ],
            'items' => User::findAll('users', 'archive = 1')
        ];

        $this->view->display('users.archive', $data);
    }

    public function section_view()
    {
        if (!get('id')) $this->display_404();

        $manager = User::getOne(get('id'));
        if ($manager->id == 0) $this->display_404();

        $manager = $this->get_access($manager);

        $data = [
            'title' => 'Менеджери :: ' . $manager->login,
            'components' => ['sweet_alert'],
            'manager' => $manager,
            'breadcrumbs' => [
                ['Менеджери', uri('user', ['section' => 'list'])],
                [$manager->first_name . ' ' . $manager->last_name]
            ],
        ];

        $this->view->display('users.view', $data);
    }

    public function section_update()
    {
        if (!get('id')) $this->display_404();
        $manager = User::getOne(get('id'));


        $data = [
            'title' => 'Менеджери :: Редагування даних',
            'scripts' => ['ckeditor/ckeditor.js'],
            'manager' => $manager,
            'access_groups' => get_object(Access::get_all_groups()),
            'positions' => Position::getAll(),
            'breadcrumbs' => [
                ['Менеджери', uri('user', ['section' => 'list'])],
                [$manager->first_name . ' ' . $manager->last_name]
            ]
        ];

        $this->view->display('users.update', $data);
    }

    public function section_register()
    {
        $data = [
            'title' => 'Менеджери :: Реєстрація',
            'access_groups' => get_object(Access::getAll()),
            'breadcrumbs' => [['Менеджери', uri('user', ['section' => 'list'])], ['Реєстрація']],
            'positions' => Position::getAll()
        ];

        $this->view->display('users.register', $data);
    }

    public function section_instruction()
    {
        $user = User::getOne(user()->id);

        $this->view->display('users.instruction', [
            'data' => htmlspecialchars_decode($user->instruction)
        ]);
    }

    public function section_profile()
    {
        $data = [
            'title' => 'Мій профіль',
            'breadcrumbs' => [['Мій профіль']]
        ];

        $this->view->display('users.profile.main', $data);
    }

    public function section_update_password()
    {
        $data = [
            'title' => 'Профіль :: Зміна паролю',
            'breadcrumbs' => [
                ['Профіль', uri('user', ['section' => 'profile'])],
                ['Зміна паролю']
            ]
        ];

        $this->view->display('users.profile.update_password', $data);
    }


    public function post_login($data)
    {
        if (isset($data->login) && !empty($data->login) && isset($data->password) && !empty($data->password)) {
            User::post_login($data);
        } else {
            response(400, 'Введіть логін і пароль');
        }
    }

    public function action_update($post)
    {
        if (cannot('managers')) response(403, 'У вас немає доступу до даної дії!');

        User::update($post, $post->id);

        response(200, ['message' => 'Дані вдало оновлено!', 'action' => 'close']);
    }

    public function action_register($post)
    {
        $error = 0;
        foreach ($post as $key => $value)
            if (empty($value))
                $error++;

        if ($error > 0)
            response(400, 'Заповніть всі поля правильно!');

        if (!preg_match('/^[A-z0-9]+$/', $post->login) || strlen($post->login) < 3)
            response(400, 'Логін тільки англійські букви і цифри! Не менше 3 символів!');

        if (strlen($post->password) < 4 || !preg_match('/^[A-z0-9]+$/', $post->password))
            response(400, 'Пароль не може бути кортше 4 символів! Тільки англійські букви і цифри!');

        if (User::count('users', '`email` = ?', [$post->email]) > 0)
            response(400, 'Користувач з таким E-Mail уже існує в БД!');

        if (User::count('users', '`login` = ?', [$post->login]) > 0)
            response(400, 'Користувач з таким логіном уже існує в БД!');

        User::register($post);

        response(200, [
            'action' => 'redirect',
            'uri' => uri('user', ['section' => 'list']),
            'message' => 'Користувач вдало зареєстрований!'
        ]);
    }

    public function action_update_password($post)
    {
        if ($post->password != $post->password_confirmation)
            response(400, 'Паролі не співпадають');

        if (mb_strlen($post->password) < 6)
            response(400, 'Занадто короткий пароль!');

        User::update(['password' => my_hash($post->password)], $post->id);

        response(200, 'Пароль вдало змінено!');
    }

    public function action_update_pin($post)
    {
        if ($post->pin != $post->pin_confirmation)
            response(400, 'PIN-коди не співпадають!');

        if (mb_strlen($post->pin) != 3)
            response(400, 'Пін код повинен містити 3 символи!');

        User::update(['pin' => $post->pin], $post->id);

        response(200, 'Пін код вдало змінений!');
    }

    public function get_reset_password()
    {
        $this->view->display('/pages/reset_password');
    }

    public function post_reset_password($post)
    {
        if (!isset($post->email) || !filter_var($post->email, FILTER_VALIDATE_EMAIL))
            response(200, 'Введіть коректний E-Mail');

        User::reset($post->email);
    }

    /**
     * Функція вертає назву групи доступу менеджера
     */
    private function get_access($manager)
    {
        if ($manager->access == 9999)
            $manager->access_name = 'ROOT';
        elseif ($manager->access == 0)
            $manager->access_name = 'Безправний';
        else {
            $access = User::getAccess($manager->access);
            if (!$access)
                $manager->access_name = 'Незнайдено';
            else {
                $manager->access_name = $access->name;
                $manager->access_link = true;
            }
        }

        return $manager;
    }

    public function api_all_users()
    {
        $users = User::findAll('users', 'archive = 0');

        $result = [];
        foreach ($users as $i => $user) {
            $result[$i] = [
                'id' => $user->id,
                'login' => $user->login,
                'email' => $user->email,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'password' => $user->password,
                'phone' => ''
            ];
        }

        echo json($result);
    }
}