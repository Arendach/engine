<?php

namespace Web\Tools;

use Web\Model\User;

class ImageUpload
{
    /**
     * @var array
     */
    private static $types = ['jpg', 'png', 'jpeg', 'gif'];

    /**
     * @param $handler
     * @return array
     */
    public static function run($handler)
    {
        $file = $_FILES[$handler];
        $name = basename($file['name']);
        $ext = self::getExt($name);
        $new = date('Ymdhis') . rand(1000, 9999);

        if (!in_array(strtolower(self::getExt($name)), self::$types))
            return ['status' => '0', 'error' => 'Не підходить тип файлу!'];
        elseif ($file['size'] > 5000000)
            return ['status' => '0', 'error' => 'Файл занадто великий'];
        elseif (!move_uploaded_file($file['tmp_name'], self::get_folder() . $new . '.' . $ext))
            return ['status' => '0', 'error' => 'Не вдалося завантажити файл'];
        else
            return ['status' => '1', 'message' => 'Файл успішно завантажено!', 'url' => self::get_folder(true) . $new . '.' . $ext];
    }

    /**
     * @param bool $type
     * @return string
     */
    public static function get_folder($type = false)
    {
        $path = ROOT . '/server/temp_files/';
        $session_path = date('Y.m.d') . '/' . user()->id;

        if (is_dir($path . $session_path)) {
            $path .= $session_path;
        } else {
            mkdir($path . $session_path, 0777, true);
            $path .= $session_path;
        }

        if ($type === false) {
            return $path . '/';
        } else {
            return ROOT . '/server/temp_files/' . $session_path . '/';
        }
    }

    /**
     * @param $filename
     * @return mixed
     */
    private static function getExt($filename)
    {
        $path_info = pathinfo($filename);
        return $path_info['extension'];
    }

    /**
     * @param $path
     * @return array
     */
    public static function delete($path)
    {
        if (is_file(ROOT . $path)) {
            if (unlink(ROOT . $path)) {
                return ['status' => '1', 'message' => 'Файл видалено!'];
            } else {
                return ['status' => '0', 'message' => 'Файл не видалено!'];
            }
        } else {
            response(400, 'Файл "' . $path . '\" не знайдено');
        }
    }

    /**
     * @return array
     */
    public static function get_temp_folder_files()
    {
        $scan = scandir(self::get_folder());
        $files = [];
        foreach ($scan as $file) {
            $base = pathinfo($file);
            if (in_array(strtolower($base['extension']), self::$types))
                $files[] = self::get_folder(true) . $file;
        }

        return $files;
    }

    /**
     * @param $id
     * @return array|bool
     */
    public static function get_product_photos($id)
    {
        $folder = ROOT . '/server/uploads/products/' . $id . '/';
        if (!is_dir($folder))
            return false;

        $scan = scandir($folder);

        $files = [];
        foreach ($scan as $file) {
            $base = pathinfo($file);
            if (in_array(strtolower($base['extension']), self::$types)) {
                $files[] = '/server/uploads/products/' . $id . '/' . $file;
            }
        }
        return $files;
    }

    /**
     * @param $id
     * @return array
     */
    public static function save_images($id)
    {
        $result = [];
        $files = self::get_temp_folder_files();
        foreach ($files as $file) {
            $rand = rand(0, 999);
            $path = ROOT . $file;
            $path_info = pathinfo($path);
            $name = $rand . $path_info['filename'] . '.' . $path_info['extension'];
            if (!is_dir(ROOT . '/server/uploads/products/' . $id . '/'))
                mkdir(ROOT . '/server/uploads/products/' . $id . '/', 0777, true);
            $dir = ROOT . '/server/uploads/products/' . $id . '/';
            $new = $dir . $rand . $path_info['filename'] . '.' . $path_info['extension'];

            if (is_file($path)) {
                if (rename($path, $new)) {
                    $url = '/server/uploads/products/' . $id . '/' . $name;
                    $result[] = ['status' => '1', 'message' => 'Файл вдало завантажено!', 'file' => $url];
                } else {
                    $result[] = ['status' => '0', 'message' => "Файл '$name' не завантажено!", 'file' => ''];
                }
            } else {
                $result[] = ['status' => '0', 'message' => "Помилка! '$name' не являється файлом!", 'file' => ''];
            }
        }

        $temp_dir = ROOT . '/server/temp_files/' . date('Y.m.d') . '/' . User::info()->id . '/';
        if (is_dir($temp_dir))
            dir_delete($temp_dir);

        return $result;
    }

    /**
     * @param $handler
     * @param $id
     * @return array
     */
    public static function upload($handler, $id)
    {
        $file = $_FILES[$handler];
        $name = rand(0, 999) . basename($file['name']);
        $folder = 'server/uploads/products/' . $id . '/';
        $path = ROOT . '/' . $folder;
        if (!is_dir($path))
            mkdir($path, 0777, true);

        if (!in_array(strtolower(self::getExt($name)), self::$types)) {
            return ['status' => '0', 'message' => 'Не підходить тип файлу!'];
        } elseif ($file['size'] > 5000000) {
            return ['status' => '0', 'message' => 'Файл занадто великий'];
        } elseif (!move_uploaded_file($file['tmp_name'], $path . $name)) {
            return ['status' => '0', 'message' => 'Не вдалося завантажити файл'];
        } else {
            return ['status' => '1', 'message' => 'Файл успішно завантажено!', 'url' => SITE . '/' . $folder . $name];
        }
    }

}