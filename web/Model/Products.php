<?php

namespace Web\Model;

use RedBeanPHP\R;
use Web\App\NewPaginate;
use Web\App\Model;
use stdClass;
use Web\App\Exception;

class Products extends Model
{
    const table = 'products';

    const combine = 'combine_product';

    // Пошук товарів для замовлення
    public static function search($where, $storage)
    {
        $result = R::getAll("SELECT 
                `products`.*,
                `pts`.`count` AS `count_on_storage`, 
                `pts`.`storage_id` AS `storage_id`
            FROM `products`
            LEFT JOIN `product_to_storage` as `pts` ON(`pts`.`product_id` = `products`.`id`)
            WHERE 
                (`pts`.`storage_id` = $storage AND $where)                 
             AND `archive` = 0");

        $tmp = (object)[];
        foreach ($result as $item) {
            $tmp->{$item['id']} = $item;
        }

        return $tmp;
    }

    public static function getAttributes(int $id)
    {
        $product_attributes = R::getAll('
            SELECT product_attributes.*, attributes.name 
            FROM product_attributes
            LEFT JOIN attributes ON attributes.id = product_attributes.attribute_id
            WHERE product_attributes.product_id = ?
        ', [$id]);

        foreach ($product_attributes as $i => $item) {
            $product_attributes[$i]['variants'] = R::getAll("SELECT * FROM product_attribute_variants WHERE product_attribute_id = ?", [$item['id']]);
        }

        return get_object($product_attributes);
    }

    // Вертаємо вибрані товари при пошуку
    public static function get_by_ids($data)
    {
        $result = (object)[];

        foreach ($data->products as $item) {
            $result->{$item->id} = (object)R::getRow("
                SELECT 
                  `products`.*, 
                  `pts`.`storage_id` AS `storage_id`,
                  `pts`.`count` AS `count_on_storage`,
                  `storage`.`name` AS `storage_name` 
                FROM `products`
                LEFT JOIN `product_to_storage` AS `pts` ON (`pts`.`product_id` = `products`.`id` AND `pts`.`storage_id` = '{$item->storage}' )
                LEFT JOIN `storage` ON `storage`.`id` = `pts`.`storage_id`
                WHERE `products`.`id` = {$item->id}");
        }

        return $result;
    }

    public static function search_products_to_combine($like, $not)
    {
        $n = '';
        if (my_count($not) > 0) $n = " AND  `id` NOT IN(" . implode(',', (array)$not) . ")";
        return R::findAll('products', "`name` LIKE '%$like%' $n LIMIT 10");
    }

    // Товари для списку
    public static function getAll($archive = false)
    {
        $items = ITEMS;
        if (app()->section == 'print') {
            $_GET['page'] = 1;
            $items = 999;
        }

        $sort = get('order_by') == 'desc' ? 'DESC' : 'ASC';
        $by = 'products.id';
        if (get('order_field') == 'costs') $by = 'products.' . get('order_field') . '';

        $sql_filter = $archive === true ? 'products.archive = 1' : 'products.archive = 0';
        $like = ['name', 'identefire_storage', 'articul', 'costs'];
        $sum = ['accounted', 'combine', 'manufacturer', 'category'];
        foreach ($_GET as $k => $v) {
            if (in_array($k, $like) || in_array($k, $sum)) {
                if (in_array($k, $like)) $sql_filter .= " \n AND \n products.$k LIKE '%$v%'";
                elseif (in_array($k, $sum)) $sql_filter .= " \n AND \n products.$k = '$v'";
            }
        }

        $p = (new NewPaginate('products'))->setSQLFilter($sql_filter)->setOrderBy($by, $sort)->setItems($items)->get();

        return get_object(R::getAll("
            SELECT products.*,
                manufacturers.name AS manufacturer_name,
                categories.name AS category_name,
                (SELECT SUM(pto.amount) FROM product_to_order AS pto RIGHT JOIN orders ON (orders.id = pto.order_id AND orders.type != 'shop' AND orders.status = 0) WHERE pto.product_id = products.id) AS delivery_count,
                (SELECT SUM(pts.count) FROM product_to_storage AS pts WHERE pts.product_id = products.id) AS count_on_storage
            FROM products
            LEFT JOIN manufacturers ON manufacturers.id = products.manufacturer
            LEFT JOIN categories ON categories.id = products.category
            $p->query_string"));
    }

    // Компоненти комбінованого товару
    public static function get_combine_products($id)
    {
        return R::getAll("SELECT `combine_product`.*, `products`.`name`, `products`.`id` AS `id`
            FROM `combine_product`
            LEFT JOIN `products` ON (`products`.`id` = `combine_product`.`linked_id`)
            WHERE `combine_product`.`product_id` = ?
            GROUP BY `combine_product`.`id`", [$id]);
    }

    // Історія товару
    public static function getHistory($id)
    {
        $p = (new NewPaginate('history_product'))
            ->setOrderBy('id', 'DESC')
            ->setItems(ITEMS)
            ->setSQLFilter("`product` = $id")
            ->get();

        return R::findAll('history_product', $p->query_string);
    }

    // зберегти товар
    public static function save($data)
    {
        $product = R::dispense('products');

        foreach ($data as $k => $v) $product->$k = $v;

        $product->volume = json_encode(get_array($data->volume));
        $product->date = date('Y-m-d H:i:s');
        $product->author = user()->id;

        return R::store($product);
    }

    // копіювати товар
    public static function copy($id, $amount)
    {
        $fields = [
            'articul',
            'model',
            'model_ru',
            'identefire_storage',
            'services_code',
            'procurement_costs',
            'combine',
            'costs',
            'archive',
            'attributes',
            'manufacturer',
            'category',
            'weight',
            'volume',
            'accounted',
            'description',
            'description_ru',
            'meta_title_uk',
            'meta_title_ru',
            'meta_keywords_uk',
            'meta_keywords_ru',
            'meta_description_uk',
            'meta_description_ru',
        ];

        $product = R::load('products', $id);
        $product_attributes = R::findAll('product_attributes', 'product_id = ?', [$id]);
        $product_characteristics = R::findAll('product_characteristics', 'product_id = ?', [$id]);
        $product_to_storage = R::findAll('product_to_storage', 'product_id = ?', [$id]);


        for ($i = 0; $i < $amount; $i++) {
            // Новий товар
            $copy_product = R::xdispense('products');

            // Присвоювання полів новому товару
            foreach ($fields as $key) $copy_product->$key = $product->$key;

            /**
             * Унікальні поля
             */
            $copy_product->name = '** Копія ' . ($i + 1) . ' ** ' . $product->name;
            $copy_product->name_ru = '** Копия ' . ($i + 1) . ' ** ' . $product->name_ru;
            $copy_product->services_code = self::get_service_code($product->category);
            $copy_product->date = date('Y-m-d H:i:s');
            $copy_product->author = user()->id;

            // ІД створеного товару
            $id = R::store($copy_product);

            /**
             * Копіювання аттрибутів
             */
            foreach ($product_attributes as $product_attribute) {
                $product_attribute_new = R::xdispense('product_attributes');
                $product_attribute_new->product_id = $id;
                $product_attribute_new->attribute_id = $product_attribute->attribute_id;
                $product_attribute_id = R::store($product_attribute_new);

                $variants = R::findAll('product_attribute_variants', 'product_attribute_id = ?', [$product_attribute->id]);

                foreach ($variants as $variant) {
                    $variant_new = R::xdispense('product_attribute_variants');
                    $variant_new->product_attribute_id = $product_attribute_id;
                    $variant_new->value = $variant->value;
                    $variant_new->value_ru = $variant->value_ru;
                    R::store($variant_new);
                }
            }

            /**
             * Копіювання характеристик
             */
            foreach ($product_characteristics as $product_characteristic) {
                $product_characteristic_new = R::xdispense('product_characteristics');
                $product_characteristic_new->characteristic_id = $product_characteristic->characteristic_id;
                $product_characteristic_new->product_id = $id;
                $product_characteristic_new->value_uk = $product_characteristic->value_uk;
                $product_characteristic_new->value_ru = $product_characteristic->value_ru;
                R::store($product_characteristic_new);
            }

            /**
             * Копіювання даних по складу
             */
            foreach ($product_to_storage as $pts) {
                $product_to_storage_new = R::xdispense('product_to_storage');
                $product_to_storage_new->product_id = $id;
                $product_to_storage_new->storage_id = $pts->storage_id;
                $product_to_storage_new->count = 0;
                R::store($product_to_storage_new);
            }

            /**
             * Якщо товар комбінований то копіюємо компоненти
             */
            if ($product->combine) {
                // Всі звязані товари
                $combine_all = R::findAll('combine_product', '`product_id` = ?', [$product->id]);

                // Перебираєм привязані товари і створюєм нові записи в БД
                foreach ($combine_all as $item) {
                    $combine = R::xdispense('combine_product');
                    $combine->product_id = $id;
                    $combine->linked_id = $item->linked_id;
                    $combine->combine_price = $item->combine_price;
                    $combine->combine_minus = $item->combine_minus;
                    R::store($combine);
                }
            }
        }
    }

    // Получаємо сервісний код від категорії
    public static function get_service_code($category_id)
    {
        $bean = R::load('categories', $category_id);

        if ($bean->id == 0) return (bool)false;

        $service_code = $bean->service_code * 100;

        $bean = R::findOne('products', 'WHERE `category` = ? ORDER BY `id` DESC', [$category_id]);

        if (!empty($bean)) $service_code = $bean->services_code + 1;

        return (int)$service_code;
    }

    public static function get_products_to_print()
    {

    }

    // пошук атрибутів
    public static function search_attributes($name)
    {
        return R::find('attributes', 'name LIKE :name', ['name' => '%' . $name . '%']);
    }

    // товар на складах
    public static function get_pts($id)
    {
        $pts = [];
        foreach (Products::findAll('product_to_storage', '`product_id` = ?', [$id]) as $item)
            $pts[$item->storage_id] = $item;

        return $pts;
    }

    // Оновлення товару на складі
    public static function update_storage($product_id, $storage_id, $check)
    {
        // загружаємо товар
        $product = R::load('products', $product_id);

        // якщо товар числиться на складі
        if (R::count('product_to_storage', 'product_id = ? AND storage_id = ?', [$product_id, $storage_id])) {

            // якщо галочка знята
            if (!$check) {
                $bean = R::findOne('product_to_storage', 'product_id = ? AND storage_id = ?', [$product_id, $storage_id]);

                // якщо кількість не дорівнює нулю то вертаємо помилку інакше видаляємо товар зі складу
                if ($bean->count != 0 && $product->accounted) {
                    $storage = R::load('storage', $storage_id);

                    return "На складі <b>$storage->name</b> знаходиться товар в кількості <b>$bean->count</b> одиниць!";
                } else {
                    R::trash($bean);
                }
            }
        } else {

            // якщо товару на складі немає і поставлена галочка
            if ($check) {
                // якщо товар комбінований то провіряємо наяввність кожного компонента на складі
                if ($product->combine) {
                    $cps = R::findAll('combine_product', '`product_id` = ?', [$product_id]);

                    // Перебираємо кожний товар
                    foreach ($cps as $cp) {

                        // якщо компонента немає на складі то загружаємо інфо про компонент
                        if (!R::count('product_to_storage', '`product_id` = ? AND `storage_id` = ?', [$cp->linked_id, $storage_id])) {
                            $p = R::load('products', $cp->linked_id);

                            // якщо компонент обіковується то додаємо його на склад якщо ні то пропускаємо
                            if ($p->accounted) {
                                $bean = R::xdispense('product_to_storage');
                                $bean->storage_id = $storage_id;
                                $bean->product_id = $p->id;
                                $bean->count = 0;
                                R::store($bean);
                            }
                        }
                    }
                }

                // якщо все гуд то записуємо товар на склад
                $bean = R::xdispense('product_to_storage');

                $bean->product_id = $product_id;
                $bean->storage_id = $storage_id;
                $bean->count = 0;

                R::store($bean);
            }
        }

        return true;
    }

    // Підчіплюємо комбіновані товари
    public static function update_combine_product($product_id, $component_data)
    {
        // Загружаємо компонент
        $component = R::load('products', $component_data['id']);

        // Якщо компонент обіковий
        if ($component['accounted']) {
            // Получаємо всі склади на яких знаходиться товар
            $pts = R::findAll('product_to_storage', '`product_id` = ?', [$product_id]);

            // Перебипрємо склади
            foreach ($pts as $item) {

                // Якщо компонент не знайдений на складі
                // то добавляємо компонент на склад
                if (!R::count('product_to_storage', '`product_id` = ? AND `storage_id` = ?', [$component->id, $item->storage_id])) {
                    $bean = R::xdispense('product_to_storage');
                    $bean->storage_id = $item->storage_id;
                    $bean->product_id = $component['id'];
                    $bean->count = 0;
                    R::store($bean);
                }
            }
        }

        // Добавляємо компонент до товара
        $bean = R::xdispense('combine_product');
        $bean->product_id = $product_id;
        $bean->linked_id = $component_data['id'];
        $bean->combine_price = $component_data['price'];
        $bean->combine_minus = $component_data['amount'];
        R::store($bean);
    }

    public static function update_attribute($post)
    {
        $old_attributes = static::getAttributes($post->id);
        foreach ($old_attributes as $old_attribute) {
            R::exec('DELETE FROM product_attribute_variants WHERE product_attribute_id = ?', [$old_attribute->id]);
            R::exec('DELETE FROM product_attributes WHERE id = ?', [$old_attribute->id]);
        }

        foreach ($post->attributes as $attribute_id => $variants) {
            $product_attribute = R::xdispense('product_attributes');
            $product_attribute->product_id = $post->id;
            $product_attribute->attribute_id = $attribute_id;
            $product_attribute_id = R::store($product_attribute);

            foreach ($variants as $variant) {
                $product_attribute_variant = R::xdispense('product_attribute_variants');
                $product_attribute_variant->product_attribute_id = $product_attribute_id;
                $product_attribute_variant->value = $variant->value;
                $product_attribute_variant->value_ru = $variant->value_ru;
                R::store($product_attribute_variant);
            }
        }
    }

    public static function getAllAssets()
    {
        $sql = '';
        $sql .= isset($_GET['archive']) ? 'products_assets.archive = 1' : 'products_assets.archive = 0';

        $p = (new NewPaginate('products_assets'))
            //->setItems(1)
            ->setSQLFilter($sql)
            ->setOrderBy('products_assets.id')
            ->setGroupBy('products_assets.id')
            ->get();

        return object(R::getAll("SELECT products_assets .*, storage . name AS storage_name
            FROM products_assets 
            LEFT JOIN storage ON storage . id = products_assets . storage {$p->query_string}"));
    }

    public static function getAllMoving()
    {
        $p = (new NewPaginate('product_moving'))
            ->setOrderBy('id', 'desc')
            ->get();

        return object(R::getAll("SELECT 
                product_moving.*, 
                sf.name AS sf_name, 
                st.name AS st_name,
                uf.login AS uf_login,
                ut.login AS ut_login
            FROM product_moving
            LEFT JOIN storage AS sf ON sf.id = product_moving.storage_from
            LEFT JOIN storage AS st ON st.id = product_moving.storage_to
            LEFT JOIN users AS uf ON uf.id = product_moving.user_from
            LEFT JOIN users AS ut ON ut.id = product_moving.user_to
            {$p->query_string}"));
    }


    public static function getMoving($id)
    {
        return object(R::getRow("SELECT 
                product_moving.*, 
                sf.name AS sf_name, 
                st.name AS st_name,
                uf.login AS uf_login,
                ut.login AS ut_login
            FROM product_moving
            LEFT JOIN storage AS sf ON sf.id = product_moving.storage_from
            LEFT JOIN storage AS st ON st.id = product_moving.storage_to
            LEFT JOIN users AS uf ON uf.id = product_moving.user_from
            LEFT JOIN users AS ut ON ut.id = product_moving.user_to
            WHERE product_moving.id = ? LIMIT 1", [$id]));
    }

    public static function getProductsByMoving($id)
    {
        return object(R::getAll("SELECT product_moving_item.*, products.name AS product_name
            FROM product_moving_item
            LEFT JOIN products ON products.id = product_moving_item.product_id
            WHERE product_moving_item.product_moving_id = ?", [$id]));
    }

    public static function searchProductsToMoving($storage, $name)
    {
        return object(R::getAll("SELECT products.name, pts.count, products.id
            FROM products
            LEFT JOIN product_to_storage AS pts ON (pts.product_id = products.id AND pts.storage_id = :storage)
            WHERE products.name LIKE :name AND 
                products.archive = 0 AND 
                products.combine = 0 AND 
                products.accounted = 1 AND 
                pts.storage_id = :storage
            ", [':storage' => $storage, ':name' => "%$name%"]));
    }

    public static function getProductByMoving($id, $storage)
    {
        return object(R::getRow("SELECT products.name, products.id, pts.count
            FROM products
            LEFT JOIN product_to_storage AS pts ON pts.product_id = products.id AND pts.storage_id = $storage
            WHERE products.id = $id AND pts.storage_id = $storage"));
    }

    public static function createMoving($post, $products)
    {
        $bean = R::xdispense('product_moving');

        $bean->storage_from = $post->storage_from;
        $bean->storage_to = $post->storage_to;
        $bean->user_to = $post->user_to;
        $bean->user_from = user()->id;
        $bean->status = 0;
        $bean->date = date('Y-m-d H:i:s');

        $id = R::store($bean);

        foreach ($products as $product_id => $product_count) {
            $bean = R::xdispense('product_moving_item');

            $bean->count = $product_count;
            $bean->product_id = $product_id;
            $bean->product_moving_id = $id;

            R::store($bean);
        }
    }

    public static function close_moving($post)
    {
        // початок транзакції
        R::begin();

        try {
            // загрузка переміщення
            $bean = R::load('product_moving', $post->id);

            // товари
            $products = R::findAll('product_moving_item', 'product_moving_id = ?', [$bean->id]);

            foreach ($products as $item) {
                $pts_from = Orders::create_pts_if_not_exists($item->product_id, $bean->storage_from);
                $pts_to = Orders::create_pts_if_not_exists($item->product_id, $bean->storage_to);

                $pts_from->count -= $item->count;
                $pts_to->count += $item->count;

                R::store($pts_from);
                R::store($pts_to);
            }

            // міняємо статус на виконано
            $bean->status = 1;
            R::store($bean);

            R::commit();

        } catch (Exception $e) {
            R::rollback();

            response(500, 'На сервері помилка! Переміщення не відбулось!');
        }
    }

    public static function getCharacteristics($id)
    {
        $sql = "SELECT product_characteristics.*, characteristics.name_uk , characteristics.name_ru 
            FROM product_characteristics
            LEFT JOIN characteristics ON characteristics.id = product_characteristics.characteristic_id
            WHERE product_characteristics.product_id = ?
          ";

        return get_object(R::getAll($sql, [$id]));
    }

    public static function api_on_storage()
    {
        return R::getAll('
            SELECT 
                products.product_key,
                SUM(product_to_storage.count) AS count
            FROM product_to_storage
            LEFT JOIN products ON products.id = product_to_storage.product_id
            WHERE products.archive = 0
            GROUP BY product_to_storage.product_id
            ');
    }
}
