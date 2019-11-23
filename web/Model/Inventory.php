<?php

namespace Web\Model;

use Web\App\Model;
use RedBeanPHP\R;
use Web\App\NewPaginate;

class Inventory extends Model
{
    const table = 'inventory';

    public static function getItems()
    {
        $p = (new NewPaginate('inventory'))->setGroupBy('inventory.id')->setOrderBy('inventory.id')->get();

        return object(R::getAll("
            SELECT inventory.*,
                COUNT(inventory_products.id) AS count_products,
                manufacturers.name AS manufacturer_name,
                storage.name AS storage_name
            FROM inventory
            LEFT JOIN inventory_products ON (inventory_products.inventory_id = inventory.id)
            LEFT JOIN manufacturers ON (manufacturers.id = inventory.manufacturer)
            LEFT JOIN storage ON (storage.id = inventory.storage) {$p->query_string}"));
    }

    public static function findProducts($m_id, $s_id, $category)
    {
        $sql = $category != 0 ? " AND products.category = '$category' " : '';

        return object(R::getAll("SELECT products.*, pts.count as count_on_storage
            FROM products
            LEFT JOIN product_to_storage AS pts ON (pts.product_id = products.id AND pts.storage_id = $s_id)
            WHERE pts.storage_id = $s_id AND 
                products.manufacturer = $m_id AND 
                products.archive = 0 AND 
                products.combine = 0 AND
                products.accounted = 1
                $sql
            GROUP BY products.id"));
    }

    public static function create($post)
    {
        $bean = R::dispense('inventory');

        $bean->date = date('Y-m-d H:i:s');
        $bean->user = user()->id;
        $bean->comment = $post->comment;
        $bean->manufacturer = $post->manufacturer;
        $bean->storage = $post->storage;

        $inventory_id = R::store($bean);

        foreach ($post->products as $product_id => $amount) {
            // загружаємо pts
            $pts = Orders::create_pts_if_not_exists($product_id, $post->storage);

            // додаємо товар до інвентаризації
            $bean = R::xdispense('inventory_products');
            $bean->inventory_id = $inventory_id;
            $bean->product_id = $product_id;
            $bean->amount = $amount;
            $bean->old_count = $pts->count;
            R::store($bean);

            // історія товару
            Orders::history_product('inventory', json(['before' => $pts->count, 'after' => $amount]), $product_id);

            // додаємо/віднімаємо і зберігаємо
            $pts->count += $amount;
            R::store($pts);
        }
    }

    public static function getData($id)
    {
        return object(R::getRow("SELECT inventory.*, manufacturers.name as manufacturer_name, storage.name AS storage_name
            FROM inventory
            LEFT JOIN manufacturers ON (manufacturers.id = inventory.manufacturer)
            LEFT JOIN storage ON (storage.id = inventory.storage)
            WHERE inventory.id = ?
            GROUP BY inventory.id", [$id]));
    }

    public static function getProducts($id)
    {
        return object(R::getAll("SELECT inventory_products.*, products.name as name
            FROM inventory_products
            LEFT JOIN products ON (products.id = inventory_products.product_id)
            WHERE inventory_products.inventory_id = ?
            GROUP BY inventory_products.id", [$id]));
    }
}