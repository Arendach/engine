<?php

/**
 * @param $id
 * @param string $default
 * @return string
 */
function template_class($id, $default = 'default')
{
    return isset($_COOKIE[$id . '_template_class']) ? $_COOKIE[$id . '_template_class'] : $default;
}

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

function get_keys($array)
{
    $temp = [];

    foreach ($array as $k => $v) $temp[] = $k;

    return $temp;
}

/**
 * @param $param
 * @return int
 */
function my_count($param)
{
    if (is_object($param)) {
        $tmp = (array)$param;
        $result = count($tmp);
    } elseif (is_array($param)) {
        $result = count($param);
    } else {
        $result = 0;
    }

    return (int)$result;
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
 * @param bool $assoc
 * @return array|bool|float|int|object|string
 */
function get($key = 'get_all_in_object', $value = false)
{
    if ($key == 'get_all_in_object') {
        return get_object($_GET);
    } elseif ($key == 'page') {
        if (isset($_GET['page']) && is_numeric($_GET['page'])) {
            return abs(intval($_GET['page']));
        } else
            return 1;
    } else {
        if ($value !== false) {
            $_GET[$key] = $value;
            return $value;
        }

        if (isset($_GET[$key])) {
            if (is_numeric($_GET[$key]))
                return (int)htmlspecialchars($_GET[$key]);
            else
                return (string)htmlspecialchars($_GET[$key]);
        } else
            return false;
    }
}

/**
 * @param $key
 * @return bool|string
 */
function post($key)
{
    if (isset($_POST[$key])):
        return (string)$_POST[$key];
    else:
        return (bool)false;
    endif;
}

/**
 * @param $var
 */
function dd($var)
{
    echo '<pre style="z-index: 9999999;">';
    print_r($var);
    echo '</pre>';
    exit;
}

/**
 * @param $var
 */
function res($var)
{
    echo json_encode($var);
}

/**
 * @param $str
 * @return string
 */
function to_bd($str)
{
    return htmlspecialchars($str);
}

/**
 * @param $var
 * @return bool
 */
function val($var)
{
    if ($var == '0')
        return false;
    elseif ($var === false)
        return false;
    elseif ($var === 0)
        return false;
    elseif ($var == 'null')
        return false;
    elseif ($var === null)
        return false;
    elseif ($var == '')
        return false;
    else
        return $var;
}

/**
 * Очищення папки від файлів
 * @param $dir
 */
function dir_clean($dir)
{
    dir_delete($dir);
    mkdir($dir);
}

/**
 * Видалення папки з файлами
 * @param $dir
 */
function dir_delete($dir)
{
    if (!is_dir($dir)) {
        mkdir($dir);
    }
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
 * Валідацтор, провіряє перемінну на пустоту, число, строку, масив
 * @param $value
 * @param string $rule
 * @return bool
 */
function validator($value, $rule = 'required')
{
    switch ($rule) {
        case 'required':
            return $value == '' ? false : true;
            break;
        case 'int':
            return !is_numeric($value) ? false : true;
            break;
        case 'string':
            return !is_string($value) ? false : true;
            break;
        case 'array':
            if (my_count($value) == 0)
                return false;
            else
                return true;
            break;
        default:
            return false;
            break;
    }
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
 * @param $file
 * @return string
 */
function asset($file)
{
    return ASSET_PATH . $file . parameters(['v' => VERSION]);
}

/**
 * @param $path
 * @return string
 */
function script($path)
{
    return '<script src="' . tpl($path) . '"></script>';
}

/**
 * @param $name
 * @return string
 */
function get_order($name)
{
    $default = 'desc';
    if (get('order_field') == $name)
        return get('order') == 'asc' ? 'desc' : 'asc';
    else
        return $default;
}

/**
 * @param $name
 * @return string
 */
function get_sym($name)
{
    if (get('order_field') == $name)
        return get('order') == 'asc' ? '&#9650;' : '&#9660;';
    else
        return '';
}

/**
 * @param $id - Статус
 * @param $type - Тип замовлення
 * @return string - <span style="color: #000">Description</span>
 */
function get_order_status($id, $type)
{
    $id = $id == 'default' ? '0' : $id;
    $status = \Web\Model\OrderSettings::statuses($type);

    if (!isset($status[$id])) return '';

    return '<span style="color: ' . $status[$id]->color . ';">' . $status[$id]->text . '</span>';
}

/**
 * @param $type - Тип замовлення
 * @param null $sel - Вибраний статус
 * @return string - <option value="1">Description</option>.....
 */
function get_order_statuses($type)
{
    $str = '<option value=""></option>';
    foreach (\Web\Model\OrderSettings::statuses($type) as $k => $status) {
        $str .= '<option value="' . $k . '">' . $status->text . '</option>';
    }
    return $str;
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
    return TEMPLATE_PATH . "parts/$file.tpl";
}

/**
 * @param $arr - асоціативний масив виду [key => value]
 * @return mixed - строка виду <script> var key = 'value'; </script>
 */
function to_javascript($arr)
{
    $core = '<script>%s</script>';
    $obj = '';
    foreach ($arr as $key => $item)
        $obj .= "var $key = " . json_encode($item, JSON_UNESCAPED_UNICODE) . ';';
    return str_replace('%s', $obj, $core);
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
 */
function response($status, $messageOrArray = false)
{
    // header('Content-Type: application/json');

    http_status($status);

    if (is_array($messageOrArray))
        echo json($messageOrArray);
    elseif (is_string($messageOrArray))
        echo json(['message' => $messageOrArray]);

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
 * @param $type
 * @return string - Тип замовлення на українській
 */
function type_parse($type)
{
    switch ($type) {
        case 'delivery':
            return 'Доставка';
            break;
        case 'shop':
            return 'Магазин';
            break;
        case 'self':
            return 'Самовивіз';
            break;
        case 'sending':
            return 'Відправка';
            break;
        default:
            return '';
            break;
    }
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
    } elseif (my_count($my_access) > 0) {
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
    } elseif (my_count($my_access) > 0) {
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
        if (can($key))
            return true;

    return false;
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
 * @return bool|object|\RedBeanPHP\OODBBean
 */
function user($id = 0)
{
    if ($id == 0)
        return get_object(app()->me);
    else
        return \Web\Model\User::getOne($id);
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
 * @param $string
 * @return array
 */
function parse_street($string)
{
    preg_match('/^([А-яії]+)(.*)\(([А-я\'ІЇ]+)\)$/ui', $string, $matches);
    $result = [];

    $result['type'] = isset($matches[1]) ? $matches[1] : 'Вулиця';
    $result['name'] = isset($matches[2]) ? $matches[2] : 'Не заповнено';
    $result['region'] = isset($matches[3]) ? $matches[3] : 'Не заповнено';

    return $result;
}

/**
 * @param $time
 * @param string $format
 * @return string
 */
function my_df($time, $format = 'd-m-Y')
{
    $date = new DateTime($time);
    return $date->format($format);
}

/**
 * @param $date
 * @return string
 */
function diff_for_humans($date)
{
    \Carbon\Carbon::setLocale('uk');
    $d = date_parse($date);
    $parts = ['year', 'month', 'day', 'hour', 'minute', 'second'];
    foreach ($parts as $item)
        if (!isset($d[$item]) || empty($d[$item]))
            $d[$item] = '00';

    return \Carbon\Carbon::create(
        $d['year'],
        $d['month'],
        $d['day'],
        $d['hour'],
        $d['minute'],
        $d['second'],
        'Europe/Kiev')
        ->diffForHumans();
}

/**
 * @return string
 */
function date_for_humans($string = false)
{
    if ($string == false) {
        return date('d') . ' ' . int_to_month(date('m'), 1) . ' ' . date('Y');
    } else {
        $d = date_parse($string);
        return $d['day'] . ' ' . int_to_month($d['month'], 1) . ' ' . $d['year'];
    }
}

function get_number($string)
{
    return preg_replace('/-/', '', $string);
}

/**
 * @param $code
 */
function nova_statuses($code)
{
    $arr = [
        '1' => 'Нова пошта очікує надходження від відправника',
        '2' => 'Видалено',
        '3' => 'Номер не знайдено',
        '4' => 'Відправлення у місті.',
        '41' => 'Відправлення у місті.',
        '5' => 'Відправлення прямує до міста.',
        '6' => 'Відправлення у місті.',
        '7' => 'Прибув на відділення',
        '8' => 'Прибув на відділення',
        '9' => 'Відправлення отримано',
        '10' => 'Відправлення отримано! Протягом доби ви одержите SMS-повідомлення про надходження грошового переказу та зможете отримати його в касі відділення «Нова пошта».',
        '11' => 'Відправлення отримано. Грошовий переказ видано одержувачу.',
        '14' => 'Відправлення передано до огляду отримувачу',
        '101' => 'На шляху до одержувача',
        '102' => 'Відмова одержувача',
        '103' => 'Відмова одержувача',
        '108' => 'Відмова одержувача',
        '104' => 'Змінено адресу',
        '105' => 'Припинено зберігання',
        '106' => 'Одержано і є ТТН грошовий переказ',
        '107' => 'Нараховується плата за зберігання'
    ];

    return isset($arr[$code]) ? $arr[$code] : 'Невідомо';
}

/**
 * @param $int
 * @return string
 */
function month_valid($int)
{
    if (mb_strlen($int) == 1)
        return "0" . $int;
    else
        return $int;

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


function app()
{
    return $GLOBALS['app'];
}

function app_set($key, $value)
{
    if (!isset($GLOBALS['app']->{$key})) {
        $GLOBALS['app']->{$key} = $value;
    } else {
        $message = '<span style="color: red">Не можливо перезаписати існуючу перемінну в APP! Ключ: ' . $key . ' </span>';
        \Web\App\Log::error($message);
        throw new \Exception($message);
    }
}

function rand32()
{
    return md5(md5(rand(1000, 9999) . date('YmdHis') . rand(10000, 99999)));
}

function p2s($str)
{
    $str = str_replace('.js', '', $str);
    $str = str_replace('.css', '', $str);
    $str = str_replace('.', '/', $str);
    return $str;
}

/**
 * @param $date
 * @return bool
 */
function is_online($date)
{
    return time() - $date < 300 ? true : false;
}


function s2c($str)
{
    $str = ucwords($str, "_");
    $str = str_replace('_', '', $str);
    return ($str);
}

function c2s($str)
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
    create_folder_if_not_exists('/server/stat/');
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

function create_folder_if_not_exists($name)
{
    if (!file_exists(ROOT . $name))
        mkdir(ROOT . $name, 0777, true);
}

function create_file_if_not_exists($name, $content = '')
{
    if (!file_exists(ROOT . $name)) {
        $fp = fopen(ROOT . $name, 'w');
        fwrite($fp, $content);
        fclose($fp);
    }
}

function start($name = 'test')
{
    app_set('process_time_' . $name, microtime(1));
}

function finish($name = 'test')
{
    create_folder_if_not_exists('/server/stat/');

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

/**
 * @param $object
 * @return string
 */
function json($object)
{
    return json_encode($object, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
}

/**
 * @param string $string
 * @return stdClass
 */
function with_json($string)
{
    return json_decode(htmlspecialchars_decode($string));
}

/**
 * @param $number
 * @return string
 */
function nf($number)
{
    return number_format($number, 2);
}

/**
 * @param $array
 * @return bool|object
 */
function object($array)
{
    return get_object($array);
}

function count_working_days($year = null, $month = null): int
{
    if ($year == null) $year = date('Y');
    if ($month == null) $month = date('m');

    $working_days = 0;
    $count_days =  date('t', strtotime($year . '-' . $month . '-01'));

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