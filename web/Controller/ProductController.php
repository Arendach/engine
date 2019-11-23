<?php

namespace Web\Controller;

use RedBeanPHP\R;
use Web\Model\Attributes;
use Web\Model\Products;
use Web\Model\User;
use Web\Tools\Categories;
use Web\Tools\ImageUpload;
use Web\Model\Manufacturers;
use Web\Model\Storage;
use Web\App\Controller;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class ProductController extends Controller
{
    public $access = 'products';

    public function section_main()
    {
        $products = Products::getAll(false);

        $sum = 0;
        foreach ($products as $product)
            if ($product->count_on_storage > 0)
                $sum += $product->procurement_costs * $product->count_on_storage;

        $data = [
            'title' => 'Каталог :: Товари',
            'scripts' => ['text_change.js', 'products/product.js', 'elements.js'],
            'products' => $products,
            'css' => ['elements.css'],
            'sum' => $sum,
            'storage' => Storage::getAll(),
            'manufacturers' => Manufacturers::getAll(),
            'category' => Categories::get(),
            'breadcrumbs' => [
                ['Архів', uri('product', ['section' => 'archive'])],
                ['Товари']
            ]
        ];

        if (get('category')) {
            $category = R::load('categories', get('category'));
            $data['category_name'] = $category->name;
        }

        $this->view->display('product.main', $data);
    }

    public function section_archive()
    {
        $data = [
            'title' => 'Каталог :: Архів товарів',
            'scripts' => ['text_change.js', 'products/product.js'],
            'products' => Products::getAll(true),
            'breadcrumbs' => [
                ['Товари', uri('product')],
                ['Архів']
            ]
        ];

        $this->view->display('product.main', $data);
    }

    public function section_create()
    {
        $data = [
            'title' => 'Товари :: Новий товар',
            'scripts' => ['text_change.js', 'products/product.js', 'products/add.js', 'ckeditor/ckeditor.js'],
            'manufacturers' => Manufacturers::getAll(),
            'categories' => Categories::get(),
            'breadcrumbs' => [
                ['Товари', uri('product')],
                ['Новий товар']
            ],
            'ids' => Storage::getIds()
        ];

        $this->view->display('product.create', $data);
    }

    public function section_update()
    {
        $id = get('id');

        $product = Products::getOne($id);
        if (my_count($product) == 0) $this->display_404();

        $product->category_name = (R::load('categories', $product->category))->name;

        [$product->level1, $product->level2] = explode('-', $product->identefire_storage);

        $data = [
            'title' => 'Товари :: Редагування товару',
            'to_js' => ['id' => $id],
            'css' => ['elements.css'],
            'scripts' => ['products/product.js', 'products/edit.js', 'elements.js', 'ckeditor/ckeditor.js'],
            'components' => ['ajax_upload', 'jquery'],
            'product' => $product,
            'photos' => ImageUpload::get_product_photos($id),
            'imgsize' => get_object(['width' => 150, 'height' => 150]),
            'manufacturers' => Manufacturers::all(),
            'categories' => Categories::get(),
            'typeStorage' => ['const=0', '+/-'],
            'storage' => Storage::findAll('storage', '`accounted` = 1'),
            'breadcrumbs' => [
                ['Товари', uri('product')],
                ['Редагування товару']
            ],
            'ids' => Storage::getIds(),
            'pts' => Products::get_pts((integer)$id),
            'characteristics' => Products::getCharacteristics($id),
            'attributes' => Products::getAttributes($id)
        ];


        if (!is_json_array($product->volume)) $data['volume'] = [0, 0, 0];
        else $data['volume'] = json_decode($product->volume);

        $data['combine_products'] = Products::get_combine_products($id);

        $this->view->display('product.update.main', $data);
    }

    public function action_update_accounted($post)
    {
        Products::update($post, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_update_storage($post)
    {
        if (!isset($post->pts)) response(400, 'Виберіть хоча-б один склад!');

        if (empty($post->pts)) response(400, 'Виберіть хоча-б один склад!');

        $c = 0;
        foreach ($post->pts as $pt) if ($pt) $c++;

        if (!$c) response(400, 'Виберіть хоча-б один склад!');

        $res = [];
        foreach ($post->pts as $storage_id => $check) $res[] = Products::update_storage($post->id, $storage_id, $check);

        $t = '';
        foreach ($res as $re) if (is_string($re)) $t .= $re . '<br>';

        if ($t == '') response(200, DATA_SUCCESS_UPDATED);
        else response(200, ['alert_type' => 'warning', 'message' => $t]);
    }

    public function action_update_combine($post)
    {
        if (my_count($post->ids) < 2) response(400, 'Виберіть хоча б два товари!');

        // Видаляємо всі компоненти
        R::exec('DELETE FROM `combine_product` WHERE `product_id` = ?', [$post->id]);

        // перебираємо всі товари з форми
        foreach ($post->ids as $i => $id) {

            // якщо немає кількості або ціни то пропускаємо
            if (!isset($post->amounts->{$i})) break;
            if (!isset($post->prices->{$i})) break;

            // Добавляємо компонент до товару
            Products::update_combine_product($post->id, [
                'amount' => $post->amounts->{$i}, 'price' => $post->prices->{$i}, 'id' => $id
            ]);
        }

        // обновляємо ціну товару
        Products::update(['costs' => $post->costs], $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_update_info($post)
    {
        $post->identefire_storage = $post->level1 . '-' . $post->level2;
        unset($post->level1, $post->level2);

        if (empty($post->name) || empty($post->name_ru))
            response(400, 'Заповніть назву товару двома мовами!');

        if (empty($post->articul))
            response(400, 'Заповніть артикул!');

        if (empty($post->model) || empty($post->model_ru))
            response(400, 'Заповніть модель двома мовами!');

        if (empty($post->services_code) || !is_numeric($post->services_code))
            response(400, 'Заповніть сервісний код!');

        if (empty($post->procurement_costs) || !is_numeric($post->procurement_costs))
            response(400, 'Заповніть закупівельну вартість!');

        if (isset($post->costs))
            if (empty($post->costs) || !is_numeric($post->costs))
                response(400, 'Заповніть ціну!');

        $post->volume = json_encode(get_array($post->volume));

        $bean = R::load('products', $post->id);
        foreach ($post as $k => $v) {
            if ($k == 'volume') $bean->$k = $v;
            else $bean->$k = htmlspecialchars($v);
        }

        R::store($bean);

        // Products::update($post, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_update_seo($post)
    {
        Products::update($post, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function section_to_archive()
    {
        R::exec('UPDATE `products` SET `archive` = 1 WHERE `id` = ?', [get('id')]);
        redirect(uri('product', ['section' => 'update', 'id' => get('id')]));
    }

    public function section_un_archive()
    {
        R::exec('UPDATE `products` SET `archive` = 0 WHERE `id` = ?', [get('id')]);
        redirect(uri('product', ['section' => 'update', 'id' => get('id')]));
    }

    public function action_search_products_to_combine($post)
    {
        if (!isset($post->not)) $post->not = [];
        $this->view->display('product.part.combine_search', [
            'products' => Products::search_products_to_combine($post->value, $post->not)
        ]);
    }

    public function action_search_attribute($post)
    {
        $result = '';

        foreach (Products::search_attributes($post->value) as $item) {
            $link = '<span data-id="%1" class="list-group-item pointer get_searched_attribute">%2</span>';
            $link = str_replace('%1', $item->id, $link);
            $link = str_replace('%2', $item->name, $link);
            $result .= $link;
        }

        echo $result;
    }

    public function action_get_searched_attribute($post)
    {
        $this->view->display('product.part.searched_attribute', [
            'attribute' => Attributes::getOne($post->id)
        ]);
    }

    public function action_update_attribute($post)
    {
        Products::update_attribute($post);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function upload_image($data)
    {
        res(ImageUpload::upload('image_upload', $data->id));
    }

    public function new_upload_image()
    {
        res(ImageUpload::run('image_upload'));
    }

    public function delete_temp_file($data)
    {
        ImageUpload::delete($data->path);
    }

    public function action_create($post)
    {
        $post->identefire_storage = $post->level1 . '-' . $post->level2;
        unset($post->level1, $post->level2);

        if (empty($post->name)) response(400, 'Заповніть назву!');
        if (empty($post->articul)) response(400, 'Заповніть артикул!');
        if (empty($post->model)) response(400, 'Заповніть модель!');
        if (empty($post->procurement_costs)) response(400, 'Заповніть закупівельну вартість!');
        if (empty($post->costs)) response(400, 'Заповніть ціну!');

        $id = Products::save($post);

        response(200, [
            'action' => 'redirect',
            'uri' => uri('product', ['section' => 'update', 'id' => $id]),
            'message' => 'Товар вдало створено'
        ]);
    }

    public function action_copy($post)
    {
        $amount = preg_match('/^[1-9]$/', $post->amount) ? $post->amount : 1;

        Products::copy($post->id, $amount);

        response(200, "Товар вдало скопійовано $amount раз(ів)");
    }

    public function action_get_service_code($post)
    {
        if (!isset($post->id) || empty($post->id)) response(200, '0');

        $result = Products::get_service_code($post->id);

        if ($result === false) response(400, 'Неправильні вхідні параметри!');
        elseif (is_numeric($result)) response(200, (string)$result);
        else response(500, 'Невідома помилка!');
    }

    public function section_print()
    {
        $this->view->display('product.print', ['items' => Products::getAll(0)]);
    }

    public function section_history()
    {
        if (!get('id')) $this->display_404();

        $data = [
            'title' => 'Товари :: Історія товару',
            'items' => Products::getHistory(get('id')),
            'breadcrumbs' => [
                ['Товари', uri('product')],
                ['Історія товару']
            ]
        ];

        $this->view->display('product.history', $data);
    }

    public function action_get_product_to_combine($post)
    {
        $data = [
            'combine_products' => Products::findAll('products', '`id` = ?', [$post->id]),
            'type' => 'add'
        ];

        $this->view->display('product.part.combine_products', $data);
    }

    public function section_assets()
    {
        $data = [
            'title' => 'Товари :: Матеріальні активи',
            'breadcrumbs' => [
                ['Товари', uri('product')],
                ['Матеріальні активи']
            ],
            'components' => ['modal'],
            'assets' => Products::getAllAssets()
        ];

        $this->view->display('product.assets.main', $data);
    }

    public function action_create_assets_form()
    {
        $data = [
            'title' => 'Новий актив',
            'storage' => Storage::findAll('storage', 'accounted = 0')
        ];

        $this->view->display('product.assets.form_create', $data);
    }

    public function action_update_assets_form($post)
    {
        $data = [
            'title' => 'Редагування активу',
            'storage' => Storage::findAll('storage', 'accounted = 0'),
            'assets' => Products::getOne($post->id, 'products_assets')
        ];

        $this->view->display('product.assets.form_update', $data);
    }

    public function action_create_assets($post)
    {
        if (!is_numeric($post->price)) response(400, 'Введіть ціну!');
        if (!is_numeric($post->course)) response(400, 'Введіть курс!');

        $post->date = date('Y-m-d H:i:s');
        $post->archive = 0;

        Products::insert($post, 'products_assets');

        response(200, 'Актив додано в базу даних!');
    }

    public function action_update_assets($post)
    {
        if (!is_numeric($post->price)) response(400, 'Введіть ціну!');
        if (!is_numeric($post->course)) response(400, 'Введіть курс!');

        Products::update($post, $post->id, 'products_assets');

        response(200, 'Актив вдало відредаговно!');
    }

    public function action_assets_to_archive($post)
    {
        Products::update(['archive' => 1], $post->id, 'products_assets');

        response(200, 'Актив переміщено в архів!');
    }

    public function action_assets_un_archive($post)
    {
        Products::update(['archive' => 0], $post->id, 'products_assets');

        response(200, 'Актив переміщено з архіву!');
    }

    public function section_moving()
    {
        $data = [
            'title' => 'Товари :: Переміщення',
            'breadcrumbs' => [
                ['Товари', uri('product')],
                ['Переміщення']
            ],
            'components' => ['modal'],
            'moving' => Products::getAllMoving()
        ];

        $this->view->display('product.moving.main', $data);
    }

    public function section_print_moving()
    {
        if (!get('id')) $this->display_404();

        $data = [
            'moving' => Products::getMoving(get('id')),
            'products' => Products::getProductsByMoving(get('id'))
        ];

        $this->view->display('product.moving.print', $data);
    }

    public function action_create_moving_form()
    {
        $data = [
            'title' => 'Нове переміщення',
            'storage' => Storage::findAll('storage', 'accounted = 1'),
            'users' => User::findAll('users', 'archive = 0')
        ];

        $this->view->display('product.moving.create_form', $data);
    }

    public function action_search_products_to_moving($post)
    {
        $result = Products::searchProductsToMoving($post->storage, $post->name);

        $str = '';
        foreach ($result as $item) {
            $str .= "<li data-storage='$post->storage' data-id='$item->id' class=\"list-group-item product_item_s\"><span class=\"badge\">{$item->count}</span>{$item->name}</li>";
        }

        echo $str;
    }

    public function action_get_product($post)
    {
        $product = Products::getProductByMoving($post->id, $post->storage);

        echo '<div>' . $product->name . '<button type="button" class="btn btn-danger btn-xs" onclick="delete_item(this)"><i class="fa fa-remove"></i></button><input name="product_' . $product->id . '" data-max="' . $product->count . '" value="0" data-id="' . $product->id . '" class="form-control"></div>';
    }

    public function action_create_moving($post)
    {
        if ($post->storage_from == $post->storage_to)
            response(400, 'Виберіть інший склад!');

        $products = [];
        foreach ($post as $key => $count) {
            if (preg_match('/product_[0-9]+/', $key)) {
                unset($post->{$key});
                $key = preg_replace('/product_([0-9]+)/', '$1', $key);
                $products[$key] = $count;
            }
        }

        if (count($products) == 0) response(400, 'Виберіть хоча-б один товар!');

        Products::createMoving($post, $products);

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_close_moving($post)
    {
        Products::close_moving($post);

        response(200, 'Переміщення прийняте!');
    }

    public function action_pts_more($post)
    {
        $pts = Products::findAll('product_to_storage', 'product_id = ?', [$post->id]);

        $result = '';
        foreach ($pts as $item) {
            $storage = Storage::getOne($item->storage_id);

            $result .= '<span style="color: green">%1</span>: %2 <br>';
            $result = str_replace('%1', $storage->name, $result);
            $result = str_replace('%2', $item->count, $result);
        }

        echo $result;
    }

    public function section_print_tick()
    {
        if (!get('ids')) $this->display_404();

        $data = [
            'title' => 'Бірки товарів',
            'products' => Products::findAll('products', '`id` IN(' . get('ids') . ')')
        ];

        $this->view->display('product.print_tick', $data);
    }

    public function section_print_stickers()
    {
        if (!get('ids')) $this->display_404();

        $products = Products::findAll('products', '`id` IN(' . get('ids') . ')');

        $i = 0;
        $temp = [0 => []];
        foreach ($products as $product) {
            $images = ImageUpload::get_product_photos($product->id);
            $product->image = is_array($images) && count($images) ? $images[0] : '/public/images/nophoto.png';

            if (count($temp[$i]) == 2) $i++;

            $temp[$i][] = $product;
        }

        $data = [
            'title' => 'Наклейки товарів',
            'products' => $temp
        ];

        $this->view->display('product.print_stickers', $data);
    }

    public function action_search_characteristics($post)
    {
        $not = isset($post->not) ? "`id` NOT IN (" . implode(',', get_array($post->not)) . ") AND " : '';
        $characteristics = Products::findAll('characteristics', "$not `name_uk` LIKE ?", ["%{$post->name}%",]);
        $this->view->display('product.update.characteristics.search', ['characteristics' => $characteristics]);
    }

    public function action_get_searched_characteristic($post)
    {
        $characteristic = Products::getOne($post->id, 'characteristics');

        $this->view->display('product.update.characteristics.result', ['characteristic' => $characteristic]);
    }

    public function action_update_characteristics($post)
    {
        R::exec('DELETE FROM product_characteristics WHERE product_id = ?', [$post->id]);
        foreach ($post as $id => $item) {
            if (is_object($item))
                Products::insert([
                    'characteristic_id' => $id,
                    'product_id' => $post->id,
                    'value_uk' => $item->value_uk,
                    'value_ru' => $item->value_ru,
                ], 'product_characteristics');
        }

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function api_search($post)
    {
        echo \GuzzleHttp\json_encode(Products::findAll('products', '(name LIKE ? OR articul LIKE ?) AND archive = 0 LIMIT 20', [
            "%{$post->search_string}%",
            "%{$post->search_string}%"
        ]));
    }

    public function api_export($request)
    {
        $ids = implode(',', (array)$request->ids);
        $products = R::findAll('products', "`id` IN($ids) AND `archive` = 0");

        $temp = [];

        foreach ($products as $product) {

            /**
             * Характеристики
             */
            $characteristics = Products::getCharacteristics($product->id);

            $characteristics_temp = [];
            foreach ($characteristics as $characteristic) {
                $characteristics_temp[] = [
                    'characteristic_id' => $characteristic->characteristic_id,
                    'value_uk' => $characteristic->value_uk,
                    'value_ru' => $characteristic->value_ru
                ];
            }

            /**
             * Атрибути
             */
            $attributes = Products::findAll('product_attributes', 'product_id = ?', [$product->id]);
            foreach ($attributes as $i => $attribute) {
                $variants = Products::findAll('product_attribute_variants', 'product_attribute_id = ?', [$attribute->id]);

                $v = [];
                foreach ($variants as $i2 => $variant) {
                    $v[$i2]['value_uk'] = $variant->value;
                    $v[$i2]['value_ru'] = $variant->value_ru;
                }

                $attributes[$i]->variants = $v;
            }

            /**
             * Фото товару
             */
            $images = ImageUpload::get_product_photos($product->id);

            if ($images == false)
                $images = [];

            /**
             * Всі дані товару
             */
            $temp[$product['id']] = [
                'article' => $product->articul,
                'price' => $product->costs,
                'on_storage' => $product->count_on_storage > 0 ? 1 : 0,
                'name_uk' => $product->name,
                'description_uk' => $product->description,
                'name_ru' => $product->name_ru,
                'description_ru' => $product->description_ru,
                'product_key' => $product->product_key,
                'meta_title_uk' => $product->meta_title_uk,
                'meta_title_ru' => $product->meta_title_ru,
                'meta_keywords_uk' => $product->meta_keywords_uk,
                'meta_keywords_ru' => $product->meta_keywords_ru,
                'meta_description_ru' => $product->meta_description_ru,
                'meta_description_uk' => $product->meta_description_uk,
                'manufacturer_id' => $product->manufacturer,
                'characteristics' => (array)$characteristics_temp,
                'attributes' => $attributes,
                'images' => $images
            ];
        }

        echo json($temp);
    }

    public function api_on_storage()
    {
        $products = Products::api_on_storage();

        $result = [];
        foreach ($products as $product) $result[$product['product_key']] = $product['count'];

        response(200, $result);
    }


    public function section_keys()
    {
        $count = R::count('products');

        for ($i = 0; $i <= $count; $i += 100) {
            $products = R::findAll('products', "LIMIT $i, 100");

            foreach ($products as $product) {
                $product->product_key = md5($product->id . date('Y-m-d H:i:s'));

                R::store($product);
            }

            echo number_format($i / $count * 100, 2) . '% <br>';
        }

        echo '100% <br>';
        echo 'good';
    }
}