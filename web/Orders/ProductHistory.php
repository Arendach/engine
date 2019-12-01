<?php

namespace Web\Orders;

use Web\Eloquent\Product;
use Web\Eloquent\ProductHistory as ProductHistoryModel;

class ProductHistory
{
    /**
     * @var Product
     */
    private $product;

    /**
     * @var ProductHistoryModel
     */
    private $history;

    /**
     * ProductHistory constructor.
     * @param Product $product
     */
    public function __construct(Product $product)
    {
        $this->product = $product;
        $this->history = new ProductHistoryModel();
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
     * @param array $data
     */
    public function updateInOrder(array $data): void
    {
        $this->save('update_in_order', $data);
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

        $this->history->product = $this->product->id;
        $this->history->type = $type;
        $this->history->data = $data;
        $this->history->date = date('Y-m-d H:i:s');
        $this->history->author = user()->id;

        $this->history->save();
    }
}