<?php

namespace Web\Orders;

use RedBeanPHP\R;
use stdClass;
use RedBeanPHP\OODBBean;
use Web\Model\Purchases;

abstract class Order
{
    /**
     * Створити запис історії товару
     * @param string $type
     * @param array $data
     * @param int $product_id
     * @return void
     */
    public function historyProduct(string $type, array $data, int $product_id)
    {
        $bean = R::xdispense('history_product');

        $bean->product = $product_id;
        $bean->type = $type;
        $bean->data = json_encode($data);
        $bean->date = date('Y-m-d H:i:s');
        $bean->author = user()->id;

        R::store($bean);
    }

    /**
     * @param int $product_id
     * @param int $storage_id
     * @return OODBBean
     */
    protected function getPTS(int $product_id, int $storage_id): OODBBean
    {
        if (!R::count('product_to_storage', '`product_id` = ? AND `storage_id` = ?', [$product_id, $storage_id])) {
            $pts = R::xdispense('product_to_storage');
            $pts->product_id = $product_id;
            $pts->storage_id = $storage_id;
            $pts->count = 0;
            R::store($pts);

            return $pts;
        } else {
            return R::findOne('product_to_storage', '`product_id` = ? AND `storage_id` = ?', [$product_id, $storage_id]);
        }
    }

    /**
     * @param OODBBean $pts
     * @param int $amount
     * @return void
     */
    protected function createPurchase(OODBBean $pts, $amount = 1): void
    {
        $product = R::load('products', $pts->product_id);

        if ($pts->count <= 2) {
            Purchases::create((object)[
                'manufacturer_id' => $product->manufacturer,
                'products' => [
                    [
                        'id' => $product->id,
                        'amount' => $amount,
                        'price' => $product->procurement_costs,
                        'course' => app()->course
                    ]
                ],
                'sum' => $product->procurement_costs * app()->course,
                'comment' => 'Створено автоматично!!!',
                'storage_id' => $pts->storage_id
            ]);
        }
    }
}