<?php

namespace Web\Orders;

use RedBeanPHP\OODBBean;
use RedBeanPHP\R;

class ProductHistory
{
    /**
     * @var OODBBean
     */
    private $product;

    /**
     * ProductHistory constructor.
     * @param OODBBean $product
     */
    public function __construct(OODBBean $product)
    {
        $this->product = $product;
    }

    /**
     * @param int $order_id
     * @return void
     */
    public function drop(int $order_id): void
    {
        $this->save('removed_from_order', ['order' => $order_id]);
    }

    /**
     * @param string $type
     * @param string|array $data
     */
    private function save(string $type, $data): void
    {
        if (is_array($data) && !count($data)) return;

        if (is_array($data))
            $data = json_encode($data);

        $bean = R::xdispense('history_product');

        $bean->product = $this->product->id;
        $bean->type = $type;
        $bean->data = $data;
        $bean->date = date('Y-m-d H:i:s');
        $bean->author = user()->id;

        R::store($bean);
    }
}