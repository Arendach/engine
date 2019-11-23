<?php

function parse_type($k)
{
    $arr = [
        'purchases' => 'Закупка',
        'add_to_order' => 'Додано в замовлення',
        'original' => 'Оригінал',
        'deleted_product_with_order' => 'Видалено з замовлення',
        'add_product_to_order' => 'Додано в замовлення',
        'update_in_order' => 'Оновлено в замовленні',
        'inventory' => 'Інвентаризація'
    ];

    return isset($arr[$k]) ? $arr[$k] : '';
}

function getHead($author, $type, $date)
{
    $str = '<span>';
    $str .= date('Y.m.d H:i', strtotime($date)) . ' ';
    $str .= '<span style="color: green">';
    $str .= user($author)->login . ' ';
    $str .= '</span>';
    $str .= parse_type($type);
    $str .= '</span>';

    return $str;
}

function purchases($data)
{
    return $data;
}

function inventory($data)
{
    $data = json_decode($data);

    $str = '';
    $str .= 'Було: ' . $data->before . '<br>';
    $str .= 'Змінено: ' . $data->after . '<br>';
    $str .= 'Стало: ' . ($data->after + $data->before) . '<br>';

    return $str;
}

function add_to_order($data)
{
    $data = json_decode($data);

    $str = "Замовлення: <a target='_blank' href=\"" . uri('orders', ['section' => 'update', 'id' => $data->order_id]) . "\">№" . $data->order_id . "</a><br>";
    $str .= "Кількість => <b style='color: blue'>{$data->amount}</b><br>";
    $str .= "Ціна: => <b style='color: blue'>{$data->price}</b> грн<br>";

    return $str;
}

function deleted_product_with_order($data)
{
    $data = json_decode($data);

    $str = '';
    $str .= 'Товар видалено з замовлення ';
    $str .= '<a href="' . uri('orders', ['section' => 'update', 'id' => $data->order]) . '">№' . $data->order . '</a>';

    return $str;
}

function update_in_order($data)
{
    $data = json_decode($data);

    if (!isset($data->order)) $data->order = 1;

    $str = '';

    if (isset($data->order)) $str .= 'Замовлення: <a href="' . uri('orders', ['section' => 'update', 'id' => $data->order]) . '" target="_blank">№' . $data->order . '</a><br>';

    if (isset($data->amount)) $str .= "$data->amount<br>";

    if (isset($data->price)) $str .= "$data->price<br>";

    return $str;

}

function original($data)
{
    $data = json_decode($data);

    $str = '';

    if (isset($data->name))
        $str .= 'Назва: ' . $data->name . '<br>';

    if (isset($data->articul))
        $str .= 'Артикул: ' . $data->articul . '<br>';

    if (isset($data->model))
        $str .= 'Модель: ' . $data->model . '<br>';

    if (isset($data->identefire_storage))
        $str .= 'Ідентифікатор складу: ' . $data->identefire_storage . '<br>';

    if (isset($data->manufacturer))
        $str .= 'Виробник: ' . $data->manufacturer . '<br>';

    if (isset($data->storage))
        $str .= 'Склад: ' . $data->storage . '<br>';

    if (isset($data->weight))
        $str .= 'Вага: ' . $data->weight . '<br>';

    if (isset($data->procurement_costs))
        $str .= 'Закупівельна вартість: ' . $data->procurement_costs . '<br>';

    if (isset($data->services_code))
        $str .= 'Сервісний код: ' . $data->services_code . '<br>';

    if (isset($data->type_product))
        $str .= 'Тип товару: ' . ($data->type_product == 'once' ? 'Одиничний<br>' : 'Комбінований<br>');

    if (isset($data->costs))
        $str .= 'Ціна: ' . $data->costs . '<br>';

    if (isset($data->sort))
        $str .= 'Сортування: ' . $data->sort . '<br>';

    if (isset($data->description))
        $str .= 'Опис: ' . $data->description . '<br>';

    return $str;

}

?>

<?php include parts('head') ?>

    <div class="panel-group" id="accordion">
        <?php foreach ($items as $item) { ?>
            <?php $rand32 = rand32(); ?>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapse<?= $rand32 ?>">
                            <?= getHead($item->author, $item->type, $item->date) ?>
                        </a>
                    </h4>
                </div>
                <div id="collapse<?= $rand32 ?>" class="panel-collapse collapse">
                    <div class="panel-body">
                        <?php if (function_exists($item->type)) {
                            $func_name = $item->type;
                            echo $func_name($item->data);
                        } ?>
                    </div>
                </div>
            </div>
        <?php } ?>

    </div>

    <div class="centered">
        <?php \Web\App\NewPaginate::display() ?>
    </div>

<?php include parts('foot') ?>