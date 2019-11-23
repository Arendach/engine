<?php

namespace Web\Tools;

class Log
{
    // масив кодів помилок
    private $error_codes = [];

    // получити всі логи
    public function getNewPostLogs(): array
    {
        // створюємо папку і сам файл лога якщо не існує
        create_folder_if_not_exists('/server/logs/');
        create_file_if_not_exists('/server/logs/new_post.json', '[]');

        // шлях до лога
        $file_path = ROOT . '/server/logs/new_post.json';

        // зміст лога
        $file_content = file_get_contents($file_path);

        // якщо файл порожній то робимо його пустим json масивом
        if ($file_content == '')
            $file_content = '[]';

        // вертаємо дедодований файл
        return with_json($file_content);
    }

    // записати новий лог
    public function appendNewPostLog(string $json): void
    {
        // глях до файлу з логами
        $file_path = ROOT . '/server/logs/new_post.json';

        // масив з логами
        $logs = $this->getNewPostLogs();

        // додаємо новий лог в масив
        $logs[] = with_json($json);

        // закодовуємо все в json
        $content = json($logs);

        // зберігаємо
        file_put_contents($file_path, $content);
    }

    // получаємо код вертаємо текст помилки
    public function getTextByCode(string $code): string
    {
        if (my_count($this->error_codes) == 0) $this->loadErrorCodes();

        return isset($this->error_codes->{$code}) ? $this->error_codes->{$code} : '<b style="color: red">Помилка незнайдена! Писати до Тараса!!!</b>';
    }

    // загрузка в масив кодів помилок
    private function loadErrorCodes(): void
    {
        $file_path = ROOT . '/server/static_files/nova.json';
        $content = file_get_contents($file_path);
        $this->error_codes = with_json($content);
    }
}