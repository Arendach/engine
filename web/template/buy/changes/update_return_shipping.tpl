<?php $data = json_decode($item->data);

$data = json_decode($item->data);
/**
 * History Class Object
 */
$history = new History($data);

/**
 * Header
 */
echo $history->getHead($i, $item, 'Оновлено інформацію про зворотню доставку');

/**
 * Body
 */
$types = ['documents' => 'Документи', 'remittance' => 'Грошовий переказ', 'none' => 'Немає', 'other' => 'Інше'];
$type = isset($data->type) && in_array($data->type, $types) ? $types[$data->type] : 'Інше';
$type_remittance = isset($data->type_remittance) && $data->type_remittance == 'imposed' ? 'У відділенні' : 'На карточку';
$payer = isset($data->payer) && $data->payer == 'sender' ? 'Відправник' : 'Отримувач';

echo $history->getHistoryKV('type', 'Тип', $type);
echo $history->getHistoryKV('type_remittance', 'Грошовий переказ', $type_remittance);
echo $history->getHistory('card', 'Банківська карта');
echo $history->getHistory('sum', 'Сума/дані');
echo $history->getHistoryKV('payer', 'Платник', $payer);

/**
 * Footer
 */
echo $history->getFoot();

?>