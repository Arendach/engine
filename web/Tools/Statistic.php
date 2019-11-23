<?php declare(strict_types=1);

namespace Web\Tools;

use stdClass;

class Statistic
{
    private $stream;

    public $content;

    const folder = '/server/statistic_files/%folder%/%part%/';

    const file = '%file%.json';


    public function push_orders(stdClass $data): void
    {
        // дані з файлу розкодовані з json
        $content = with_json($this->get_content());

        $content->{$data->storage} = $content->{$data->storage} ?? new stdClass();

        // поля статистики
        $fields = ['sum', 'products', 'purchase', 'profit'];

        // записуємо нові дані в статистику
        foreach ($fields as $field) {
            $content->{$data->storage}->$field = $content->{$data->storage}->$field ?? 0;
            $content->{$data->storage}->$field += $data->$field ?? 0;
        }

        $this->put(json($content));
    }

    public function get_path(string $date, string $part): string
    {
        [$year, $month, $day] = explode('.', $date);

        $folder = $this->get_folder($year, $month, $part);
        $file = $this->get_file($day);

        return $folder . $file;
    }

    public function get_order_content(string $date, string $date2 = ''): Statistic
    {
        [$year, $month, $day] = explode('.', $date);

        // получаємо шлях до папки з файлами статистики і назву файлу
        $folder = $this->get_folder($year, $month, 'orders');
        $file = $this->get_file($day);

        $path = ROOT . $folder . $file;

        $this->content = is_file($path) ? file_get_contents($path) : '';

        return $this;
    }

    public function group_by_month()
    {

    }


    private function get_folder(string $year, string $month, string $part): string
    {
        $folder = str_replace('%folder%', "$year.$month", $this::folder);
        $folder = str_replace('%part%', $part, $folder);
        return $folder;
    }

    private function get_file(string $file): string
    {
        $file = str_replace('%file%', $file, $this::file);
        return $file;
    }

    private function put(string $content): void
    {
        // поміщаємо курсор на початок файлу
        rewind($this->stream);

        // пишемо модифіковані дані в файл
        fwrite($this->stream, $content);

        // знімаємо блокіровку
        flock($this->stream, LOCK_UN);

        // закриваємо поток
        fclose($this->stream);

        // чистимо довбаний кеш
        clearstatcache();
    }

    private function get_content(string $part = 'orders'): string
    {
        // получаємо шлях до папки з файлами статистики і назву файлу
        $folder = $this->get_folder(year, month, $part);
        $file = $this->get_file(day);

        // створюємо файл і папку якщо таких не існує
        create_folder_if_not_exists($folder);
        create_file_if_not_exists($folder . $file, '{}');

        // відкриваємо файл і поміщаємо поток в $this->stream
        $this->stream = fopen(ROOT . $folder . $file, 'r+');

        // читаємо дані з файлу
        $content = fread($this->stream, filesize(ROOT . $folder . $file));

        // чистимо файл
        ftruncate($this->stream, 0);

        // заблоковуємо файл
        flock($this->stream, LOCK_EX);

        // вертаємо дані з файлу
        return $content;
    }
}