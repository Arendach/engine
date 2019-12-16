<?php

/**
 * @param $array
 * @return bool|object
 */
function get_object($array)
{
    if (!is_array($array) && !is_object($array)) {
        return false;
    } else {
        $result = new stdClass();
        foreach ($array as $k => $v) {
            if (is_array($v)) {
                $result->$k = get_object($v);
            } else {
                $result->$k = $v;
            }
        }
        return $result;
    }
}

/**
 * @param $object
 * @return array|bool
 */
function get_array($object)
{
    if (!is_object($object) && !is_array($object)) {
        return false;
    } else {
        $result = [];
        foreach ($object as $k => $v) {
            if (is_object($v)) {
                $result[$k] = get_array($v);
            } else {
                $result[$k] = $v;
            }
        }
        return $result;
    }
}

function my_file_size($bytes, $precision = 2)
{
    $units = array('B', 'KB', 'MB', 'GB', 'TB');
    $bytes = max($bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    $bytes /= pow(1024, $pow);
    return round($bytes, $precision) . ' ' . $units[$pow];
}

/**
 * @param string $key
 * @param null $default
 * @return mixed
 */
function get($key, $default = null)
{
    return request($key, $default);
}

/**
 * Очищення папки від файлів
 *
 * @param $dir
 */
function dir_clean(string $dir): void
{
    dir_delete($dir);
    mkdir($dir);
}

/**
 * Видалення папки з файлами
 *
 * @param $dir
 */
function dir_delete(string $dir): void
{
    if (!is_dir($dir))
        return;

    if (substr($dir, strlen($dir) - 1, 1) != '/') {
        $dir .= '/';
    }
    $files = glob($dir . '*', GLOB_MARK);
    foreach ($files as $file) {
        is_dir($file) ? dir_delete($file) : unlink($file);
    }
    rmdir($dir);
}

/**
 * @param $file
 * @return string
 */
function t_file($file)
{
    $file = preg_replace('/\./', '/', $file);
    return TEMPLATE_PATH . $file . '.tpl';
}

/**
 * @param $file
 * @return string
 */
function pages($file)
{
    return TEMPLATE_PATH . "pages/$file.tpl";
}

/**
 * @param string $file
 * @return string
 */
function asset(string $file): string
{
    return ASSET_PATH . $file . parameters(['v' => VERSION]);
}

/**
 * @param string $path
 * @return string
 */
function public_path(string $path): string
{
    return trim(ROOT, '/') . '/public/' . trim($path, '/');
}

/**
 * @param string $path
 * @return string
 */
function base_path(string $path): string
{
    return trim(ROOT, '/') . '/' . trim($path, '/');
}

/**
 * @param $int - 1-12
 * @return string - назва місяця на укрїнській
 */
function int_to_month($int, $v = 0)
{
    if ($int == '1' || $int == '01') {
        return $v ? 'Січня' : 'Січень';
    } elseif ($int == '2' || $int == '02') {
        return $v ? 'Лютого' : 'Лютий';
    } elseif ($int == '3' || $int == '03') {
        return $v ? 'Березня' : 'Березень';
    } elseif ($int == '4' || $int == '04') {
        return $v ? 'Квітня' : 'Квітень';
    } elseif ($int == '5' || $int == '05') {
        return $v ? 'Травня' : 'Травень';
    } elseif ($int == '6' || $int == '06') {
        return $v ? 'Червня' : 'Червень';
    } elseif ($int == '7' || $int == '07') {
        return $v ? 'Липня' : 'Липень';
    } elseif ($int == '8' || $int == '08') {
        return $v ? 'Серпня' : 'Серпень';
    } elseif ($int == '9' || $int == '09') {
        return $v ? 'Вересня' : 'Вересень';
    } elseif ($int == '10') {
        return $v ? 'Жовтня' : 'Жовтень';
    } elseif ($int == '11') {
        return $v ? 'Листопада' : 'Листопад';
    } elseif ($int == '12') {
        return $v ? 'Грудня' : 'Грудень';
    } else {
        return '';
    }
}

/**
 * @param $date - Y-m-d
 * @return null|string  - День тижня на українській
 */
function date_to_day($date)
{
    $day = date('D', strtotime($date));
    if ($day == 'Fri') {
        return 'Пятниця';
    } elseif ($day == 'Sat') {
        return 'Субота';
    } elseif ($day == 'Sun') {
        return 'Неділя';
    } elseif ($day == 'Mon') {
        return 'Понеділок';
    } elseif ($day == 'Tue') {
        return 'Вівторок';
    } elseif ($day == 'Wed') {
        return 'Середа';
    } elseif ($day == 'Thu') {
        return 'Четвер';
    }
    return null;
}

/**
 * @param $file
 * @return string
 */
function parts($file)
{
    if ($file == 'footer') $file = 'foot';
    return TEMPLATE_PATH . "parts/$file.tpl";
}

/**
 * @param $status - Код статуса http
 */
function http_status($status)
{
    $statuses = [
        /**
         * 1xx: Informational (информационные)
         */
        100 => 'Continue',
        101 => 'Switching Protocols',
        102 => 'Processing',

        /**
         * 2xx: Success (успешно)
         */
        200 => 'OK',
        201 => 'Created',
        202 => 'Accepted', // принято
        203 => 'Non-Authoritative Information', // информация не авторитетна
        204 => 'No Content', // нет содержимого
        205 => 'Reset Content', // сбросить содержимое
        206 => 'Partial Content', // частичное содержимое
        207 => 'Multi-Status', // многостатусный
        208 => 'Already Reported', // уже сообщалось
        226 => 'IM Used', // использовано IM

        /**
         * 3xx: Redirection (перенаправление)
         */
        300 => 'Multiple Choices', // множество выборов
        301 => 'Moved Permanently', // перемещено навсегда
        302 => 'Found', // перемещено временно
        303 => 'See Other', // смотреть другое
        304 => 'Not Modified', // не изменялось
        305 => 'Use Proxy', // использовать прокси
        306 => '', // зарезервировано (код использовался только в ранних спецификациях)[7];
        307 => 'Temporary Redirect', //' временное перенаправление
        308 => 'Permanent Redirect', // постоянное перенаправление.

        /**
         * 4xx: Client Error (ошибка клиента)
         */
        400 => 'Bad Request', // плохой, неверный запрос
        401 => 'Unauthorized', // не авторизован
        402 => 'Payment Required', // необходима оплата
        403 => 'Forbidden', // запрещено
        404 => 'Not Found', // не найдено
        405 => 'Method Not Allowed', // метод не поддерживается
        406 => 'Not Acceptable', // неприемлемо
        407 => 'Proxy Authentication Required', // необходима аутентификация прокси
        408 => 'Request Timeout', // истекло время ожидания
        409 => 'Conflict', // конфликт
        410 => 'Gone', // удалён
        411 => 'Length Required', // необходима длина
        412 => 'Precondition Failed', // условие ложно
        413 => 'Payload Too Large', // полезная нагрузка слишком велика
        414 => 'URI Too Long', // URI слишком длинный
        415 => 'Unsupported Media Type', // неподдерживаемый тип данных
        416 => 'Range Not Satisfiable', // диапазон не достижим
        417 => 'Expectation Failed', // ожидание не удалось
        418 => 'I’m a teapot', // я — чайник
        421 => 'Misdirected Request',
        422 => 'Unprocessable Entity', // необрабатываемый экземпляр
        423 => 'Locked', // заблокировано
        424 => 'Failed Dependency', // невыполненная зависимость
        426 => 'Upgrade Required', // необходимо обновление
        428 => 'Precondition Required', // необходимо предусловие
        429 => 'Too Many Requests', // слишком много запросов
        431 => 'Request Header Fields Too Large', // поля заголовка запроса слишком большие
        444 => '', //Закрывает соединение без передачи заголовка ответа. Нестандартный код
        449 => 'Retry With', //' повторить с
        451 => 'Unavailable For Legal Reasons', // недоступно по юридическим причинам

        /**
         * 5xx: Server Error (ошибка сервера)
         */
        500 => 'Internal Server Error', // внутренняя ошибка сервера
        501 => 'Not Implemented', // не реализовано
        502 => 'Bad Gateway', // плохой, ошибочный шлюз
        503 => 'Service Unavailable', // сервис недоступен
        504 => 'Gateway Timeout', // шлюз не отвечает
        505 => 'HTTP Version Not Supported', // версия HTTP не поддерживается
        506 => 'Variant Also Negotiates', // вариант тоже проводит согласование
        507 => 'Insufficient Storage', // переполнение хранилища
        508 => 'Loop Detected', // обнаружено бесконечное перенаправление
        509 => 'Bandwidth Limit Exceeded', // исчерпана пропускная ширина канала
        510 => 'Not Extended', // не расширено
        511 => 'Network Authentication Required', // требуется сетевая аутентификация
        520 => 'Unknown Error', // неизвестная ошибка
        521 => 'Web Server Is Down', // веб-сервер не работает
        522 => 'Connection Timed Out', // соединение не отвечает
        523 => 'Origin Is Unreachable', // источник недоступен
        524 => 'A Timeout Occurred', // время ожидания истекло
        525 => 'SSL Handshake Failed', // квитирование SSL не удалось
        526 => 'Invalid SSL Certificate', // недействительный сертификат SSL
    ];
    if (isset($statuses[$status]))
        header('HTTP/1.1 ' . $status . ' ' . $statuses[$status]);
}

/**
 * @param $status - http код відповіді сервера
 * @param bool $messageOrArray - Повідомлення або масив,
 * який буде передано клієнту в виді JSON - строки
 *
 * @return null|\Web\App\Response
 */
function response($status = null, $messageOrArray = null)
{
    if (is_null($status) && is_null($messageOrArray)) return container(\Web\App\Response::class);

    http_status($status);

    if (is_array($messageOrArray))
        echo json_encode($messageOrArray);
    elseif (is_string($messageOrArray))
        echo json_encode(['message' => $messageOrArray]);

    exit;
}

/**
 * @param $url - Адреса на яку робиться переадресація
 */
function redirect($url)
{
    header('Location: ' . $url);
}

/**
 * @param array $parameters - Масив виду [key => value,....]
 * @return bool|string - строка виду ?key=value...
 */
function parameters(array $parameters)
{
    $string = '?';
    foreach ($parameters as $key => $value)
        $string .= $key . '=' . $value . '&';
    return substr($string, 0, strlen($string) - 1);
}

/**
 * @param string $key - Перевірка користувача на відсутність ключа доступу
 * @return bool - false - якщо ключ існує, true - якщо не існує
 */
function cannot($key = 'ROOT')
{
    $my_access = user()->access;

    if ($my_access === true) {
        return false;
    } elseif ($my_access === false) {
        return true;
    } elseif (count($my_access) > 0) {
        $my_access = get_array($my_access);
        if (!in_array($key, $my_access)) {
            return true;
        } else {
            return false;
        }
    } else {
        return true;
    }
}

/**
 * @param string $key - Перевірка користувача на наявніть ключа доступу
 * @return bool - true - якщо ключ існує, false - якщо не існує
 */
function can($key = 'ROOT')
{
    $my_access = user()->access;
    if ($my_access === true) {
        return true;
    } elseif ($my_access === false) {
        return false;
    } elseif (count($my_access) > 0) {
        $my_access = get_array(user()->access);
        if (!in_array($key, $my_access)) {
            return false;
        } else {
            return true;
        }
    } else {
        return false;
    }
}

/**
 * @param array $array
 * @return bool
 */
function can_keys(array $array)
{
    foreach ($array as $key)
        if (cannot($key))
            return false;

    return true;
}

/**
 * @param $string
 * @return string
 */
function my_hash($string)
{
    return trim(\Web\App\Security::p_hash($string));
}

/**
 * @param int $month
 * @param int $year
 * @return int|mixed
 */
function day_in_month($month = 1, $year = 2017)
{
    $array = [
        1 => 31,
        2 => type_year($year),
        3 => 31,
        4 => 30,
        5 => 31,
        6 => 30,
        7 => 31,
        8 => 31,
        9 => 30,
        10 => 31,
        11 => 30,
        12 => 31
    ];
    if (isset($array[$month]))
        return $array[$month];
    else
        return 30;
}

/**
 * @param $year
 * @return int
 */
function type_year($year)
{
    $start = 2016;

    $high = [];
    for ($i = $start; $i < 2056; $i = $i + 4) {
        $high[] = $i;
    }

    if (in_array($year, $high)) {
        return 29;
    } else {
        return 28;
    }
}

/**
 * @param int $id
 * @return bool|object|\Web\Eloquent\User
 */
function user($id = 0)
{
    if ($id == 0) return get_object(app()->me);
    else return \Web\Eloquent\User::find($id);
}

/**
 * @param $string
 * @return bool
 */
function is_json($string)
{
    json_decode(htmlspecialchars_decode($string));
    return (json_last_error() == JSON_ERROR_NONE);
}

/**
 * @param $string
 * @return bool
 */
function is_json_array($string)
{
    if (!is_string($string)) return false;

    return preg_match('/\[(\"[\w]+\",?){0,}\]/', $string) ? true : false;
}

/**
 * @param $str
 * @return string
 */
function string_to_time($str)
{
    if (preg_match('/[0-9]{1,2}:[0-9]{1,2}/', $str)) $str = time_to_string($str);

    if (mb_strlen($str) == 4)
        return $str[0] . $str[1] . ':' . $str[2] . $str[3];
    elseif (mb_strlen($str) == 3)
        return $str[0] . $str[1] . ':' . $str[2] . '0';
    elseif (mb_strlen($str) == 2)
        return $str[0] . $str[1] . ':' . '00';
    else if (mb_strlen($str) == 1)
        return '0' . $str[0] . ':00';
    else
        return '00:00';
}

/**
 * @param $time
 * @return string
 */
function time_to_string($time)
{
    if (mb_strlen($time) > 5) $time = substr($time, 0, 5);

    if (preg_match('/^([0-9]{1,2}):([0-9]{1,2})$/', $time, $matches)) {
        return $matches[1] . $matches[2];
    } elseif (preg_match('/^[0-9]{1,4}$/', $time, $matches)) {
        return time_to_string(string_to_time($matches[0]));
    } else {
        return '0000';
    }
}

/**
 * Возвращает сумму прописью
 * @author runcore
 * @uses morph(...)
 */
function num2str($num)
{
    $nul = 'нуль';
    $ten = array(
        array('', 'один', 'два', 'три', 'чотири', 'пять', 'шість', 'сім', 'вісім', 'девять'),
        array('', 'одна', 'дві', 'три', 'чотири', 'пять', 'шість', 'сім', 'вісім', 'девять'),
    );
    $a20 = array('десять', 'одиннадцать', 'дванадцать', 'тринадцать', 'чотирнадцать', 'пятнадцать', 'шістнадцать', 'сімнадцать', 'вісімнадцать', 'девятнадцять');
    $tens = array(2 => 'двадцать', 'тридцать', 'сорок', 'пятдесят', 'шістьдесят', 'сімдесят', 'вісімьдесят', 'девяносто');
    $hundred = array('', 'сто', 'двісті', 'триста', 'чотириста', 'пятсот', 'шістсот', 'сімсот', 'вісімсот', 'девятсот');
    $unit = array( // Units
        array('копійка', 'копійки', 'копійок', 1),
        array('гривня', 'гривні', 'гривнів', 0),
        array('тисяча', 'тисячі', 'тисяч', 1),
        array('мільйон', 'мільйони', 'мільйонів', 0),
        array('мільярд', 'мільярди', 'мільярдів', 0),
    );
    //
    list($rub, $kop) = explode('.', sprintf("%015.2f", floatval($num)));
    $out = array();
    if (intval($rub) > 0) {
        foreach (str_split($rub, 3) as $uk => $v) { // by 3 symbols
            if (!intval($v)) continue;
            $uk = sizeof($unit) - $uk - 1; // unit key
            $gender = $unit[$uk][3];
            list($i1, $i2, $i3) = array_map('intval', str_split($v, 1));
            // mega-logic
            $out[] = $hundred[$i1]; # 1xx-9xx
            if ($i2 > 1) $out[] = $tens[$i2] . ' ' . $ten[$gender][$i3]; # 20-99
            else $out[] = $i2 > 0 ? $a20[$i3] : $ten[$gender][$i3]; # 10-19 | 1-9
            // units without rub & kop
            if ($uk > 1) $out[] = morph($v, $unit[$uk][0], $unit[$uk][1], $unit[$uk][2]);
        } //foreach
    } else $out[] = $nul;
    $out[] = morph(intval($rub), $unit[1][0], $unit[1][1], $unit[1][2]); // rub
    $out[] = $kop . ' ' . morph($kop, $unit[0][0], $unit[0][1], $unit[0][2]); // kop
    return trim(preg_replace('/ {2,}/', ' ', join(' ', $out)));
}

/**
 * Склоняем словоформу
 * @ author runcore
 */
function morph($n, $f1, $f2, $f5)
{
    $n = abs(intval($n)) % 100;
    if ($n > 10 && $n < 20) return $f5;
    $n = $n % 10;
    if ($n > 1 && $n < 5) return $f2;
    if ($n == 1) return $f1;
    return $f5;
}

/**
 * @param $int
 * @return string
 */
function month_valid($int)
{
    if (mb_strlen($int) == 1) return "0" . $int;
    else return $int;
}

/**
 * @param array $parameters
 * @return null|string|string[]
 */
function params(array $parameters)
{
    return preg_replace('@^\?@', '', parameters($parameters));
}

/**
 * @param $part
 * @param string $parameters
 * @param string $hash
 * @return string
 */
function uri($part, $parameters = '', $hash = '')
{
    if (preg_match('/^\//', $part))
        $part = preg_replace('/^(\/)/', '', $part);

    $str = SITE . '/' . $part;

    if (is_array($parameters))
        $str .= parameters($parameters);

    if ($hash != '')
        $str .= '#' . $hash;

    return $str;
}

/**
 * @param $phone
 * @return string
 */
function get_number_world_format($phone)
{
    if (preg_match('/\+38[0-9]{10,10}/', $phone)) {
        return $phone;
    }

    if (preg_match('@38[0-9]{10,10}@', $phone)) {
        return '+' . $phone;
    }

    if (preg_match('@[0-9]{10,10}@', $phone)) {
        return '+38' . $phone;
    }

    if (preg_match('@[0-9]{9,9}@', $phone)) {
        return '+380' . $phone;
    }

    return 'error!!';
}

/**
 * @param $key
 * @return null|string
 */
function setting($key = false)
{
    $settings = app()->settings;
    if ($key != false)
        return isset($settings[$key]) ? $settings[$key] : null;
    else
        return $settings;
}

/**
 * @param string|null $key
 * @param mixed|null $value
 * @return mixed|null|object
 */
function app($key = null, $value = null)
{
    if (is_null($key) && is_null($value))
        return (object)\Web\App\Container::getContainer();
    elseif (!is_null($key) && is_null($value))
        return \Web\App\Container::get($key, null);
    else
        \Web\App\Container::set($key, $value);

    return null;
}

/**
 * @return string
 */
function rand32(): string
{
    return md5(md5(rand(1000, 9999) . date('YmdHis') . rand(10000, 99999)));
}

/**
 * Point to slash
 *
 * @param $str
 * @return mixed
 */
function p2s(string $str): string
{
    $str = str_replace('.js', '', $str);
    $str = str_replace('.css', '', $str);
    $str = str_replace('.', '/', $str);
    return (string)$str;
}


/**
 * snake_case to CamelCase
 *
 * @param string $str
 * @return string
 */
function s2c(string $str): string
{
    $str = ucwords($str, "_");
    $str = str_replace('_', '', $str);
    return ($str);
}

/**
 * CamelCase to snake_case
 *
 * @param string $str
 * @return string
 */
function c2s(string $str): string
{
    preg_match_all('!([A-Z][A-Z0-9]*(?=$|[A-Z][a-z0-9])|[A-Za-z][a-z0-9]+)!', $str, $matches);
    $ret = $matches[0];
    foreach ($ret as &$match) {
        $match = $match == strtoupper($match) ? strtolower($match) : lcfirst($match);
    }
    return implode('_', $ret);

}

function time_load_stat()
{
    create_folder('/server/stat/');
    $file = fopen(ROOT . '/server/stat/' . date('Y-m-d') . '.txt', 'a+');

    if (preg_match('/\/[a-zA-Z_]+/', $_SERVER['REQUEST_URI'], $matches)) {
        $controller = $matches[0];
    } else {
        $controller = 'Undefined';
    }

    $string = $_SERVER['REQUEST_METHOD'];
    $string .= '@';
    $string .= $controller;
    $string .= '@';
    $string .= $_SERVER['REQUEST_URI'];
    $string .= '@';
    $string .= round(microtime(1) - START, 3);
    $string .= PHP_EOL;

    fwrite($file, $string);

    fclose($file);
}

/**
 * Створює папку якщо не існує
 *
 * @param string $name
 */
function create_folder(string $name): void
{
    if (!file_exists(ROOT . $name))
        mkdir(ROOT . $name, 0777, true);
}

/**
 * Створює файл якщо не існує
 *
 * @param string $name
 * @param string $content
 */
function create_file(string $name, string $content = '')
{
    if (!file_exists(ROOT . $name)) {
        $fp = fopen(ROOT . $name, 'w');
        fwrite($fp, $content);
        fclose($fp);
    }
}

function start($name = 'test')
{
    app('process_time_' . $name, microtime(1));
}

function finish($name = 'test')
{
    create_folder('/server/stat/');

    $file = fopen(ROOT . '/server/stat/stat.txt', 'a+');
    $name = 'process_time_' . $name;

    $string = $name . ' - ';
    $string .= (microtime(1) - app()->{$name}) * 1000;
    $string .= 'мс.';
    $string .= PHP_EOL;

    fwrite($file, $string);

    fclose($file);

    return $string;
}

function count_working_days($year = null, $month = null): int
{
    if ($year == null) $year = date('Y');
    if ($month == null) $month = date('m');

    $working_days = 0;
    $count_days = date('t', strtotime($year . '-' . $month . '-01'));

    for ($i = 1; $i <= $count_days; $i++) {
        $day = date('D', strtotime($year . '-' . $month . '-' . $i));
        if ($day != 'Sat' && $day != 'Sun') $working_days++;
    }

    return $working_days;
}

function count_holidays($year = null, $month = null)
{
    if ($year == null) $year = date('Y');
    if ($month == null) $month = date('m');

    $working_days = count_working_days($year, $month);

    $holidays = date('t', strtotime($year . '-' . $month . '-1')) - $working_days;

    return $holidays;
}

/**
 * @param $abstract
 * @param null $parameter
 * @return object|mixed
 */
function container($abstract, $parameter = null)
{
    return (new \Web\App\Container())->getClassObject($abstract, $parameter);
}

/**
 * @param int $code
 * @param string $message
 */
function abort(int $code, string $message = ''): void
{
    container(\Web\App\Response::class)->abort($code, $message);
}

/**
 * @param bool $bool
 * @param $code
 * @param string $message
 */
function abort_if(bool $bool, $code, $message = ''): void
{
    if ($bool)
        abort($code, $message);
}

/**
 * @param null $key
 * @param null $default
 * @return mixed|\Web\App\Request
 */
function request($key = null, $default = null)
{
    if ($key == null && $default == null)
        return container(\Web\App\Request::class);

    return container(\Web\App\Request::class)->get($key, $default);
}

/**
 * @param string $asset
 * @return array
 */
function assets(string $asset): array
{
    return require base_path("assets/$asset.php");
}