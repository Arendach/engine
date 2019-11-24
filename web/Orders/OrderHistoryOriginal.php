<?php

namespace Web\Orders;

use Web\Model\OrderSettings;
use RedBeanPHP\R;
use stdClass;
use Web\Services\NewPostService;

class OrderHistoryOriginal
{
    /**
     * @var NewPostService;
     */
    private $newPost;

    /**
     * Пишимо історію замовлення (оригінал)
     * @param stdClass $data
     * @param stdClass $products
     * @param int $id
     * @return void
     */
    public function __construct(stdClass $data, stdClass $products, int $id)
    {
        $this->newPost = container(NewPostService::class);

        $this->prepareCity($data);

        $this->deleteImposed($data);

        $this->replaceIds($data);

        $this->sendingVariant($data);

        $this->prepareHint($data);

        $this->prepareProducts($data, $products);

        $this->unsetEmptyFields($data);

        $this->saveChanges('original', $data, $id);
    }

    /**
     * @param stdClass $data
     * @return void
     */
    private function prepareCity(stdClass &$data): void
    {
        if (!isset($data->delivery)) return;

        $delivery_company = R::load('logistics', $data->delivery);

        if ($delivery_company->name != 'НоваПошта') return;

        $names = $this->newPost->getWarehouseName($data->city, $data->warehouse);

        // init
        $data->city = $names['city'];
        $data->warehouse = $names['warehouse'];
    }

    /**
     * @param stdClass $data
     * @return void
     */
    private function deleteImposed(stdClass &$data): void
    {
        // видаляємо
        if (isset($data->form_delivery) && $data->form_delivery == 'imposed')
            unset($data->imposed);
    }

    /**
     * @param stdClass $data
     * @return void
     */
    private function replaceIds(stdClass &$data): void
    {
        // Заміняємо ідентифікатори на значення
        $assets = [
            // field => table
            'courier' => 'users',
            'pay_method' => 'pays',
            'delivery' => 'logistics',
            'site' => 'sites'
        ];

        foreach ($assets as $field => $table) {
            if (!isset($data->$field)) continue;

            $data->$field = (R::load($table, $data->$field))->name;
        }
    }

    /**
     * @param stdClass $data
     * @return void
     */
    private function sendingVariant(stdClass &$data): void
    {
        if (!isset($data->sending_variant)) return;

        $data->sending_variant = OrderSettings::getSendingVariant($data->sending_variant)['name'];
    }

    /**
     * Визначаємо підказку
     * @param stdClass $data
     * @return void
     */
    private function prepareHint(stdClass &$data): void
    {
        if (!isset($data->hint) || $data->hint == 0) return;

        $temp = R::load('colors', $data->hint);
        $data->hint = '<span style="color: #' . $temp->color . '">' . $temp->description . '</span>';
    }

    /**
     * додавання назв товарів у історію
     * @param stdClass $data
     * @param stdClass $products
     * @return void
     */
    private function prepareProducts(stdClass &$data, stdClass $products): void
    {
        foreach ($products as $i => $product) {
            $products->$i->name = (R::load('products', $product->id))->name;
            $products->$i->storage_name = (R::load('storage', $product->storage))->name;
        }

        $data->products = $products;
    }

    /**
     * Видалення пустих полів з обєкта даних
     * @param stdClass $data
     * @return void
     */
    private function unsetEmptyFields(stdClass &$data): void
    {
        foreach ($data as $key => $value)
            if ($value == '')
                unset($data->$key);
    }

    /**
     * Запис в історію замовлення
     * @param string $type
     * @param stdClass $data
     * @param int $id
     * @return void
     */
    private function saveChanges(string $type, stdClass $data, int $id): void
    {
        $bean = R::dispense('changes');

        $bean->type = $type;
        $bean->data = json_encode($data);
        $bean->id_order = $id;
        $bean->date = date('Y-m-d H:i:s');
        $bean->author = user()->id;

        R::store($bean);
    }
}