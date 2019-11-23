<?php

namespace Web\Controller;

use RedBeanPHP\R;
use Web\App\Controller;
use Cocur\Slugify\Slugify;
use Web\Model\Attributes;
use Web\Model\OrderSettings;
use Web\Model\Storage;

class SettingsController extends Controller
{
    public $access = 'settings';

    public function section_main()
    {
        $data = [
            'title' => 'Налаштування',
            'breadcrumbs' => [['Налаштування']]
        ];

        $this->view->display('settings.main', $data);
    }

    /***************************************************************************/
    /* Color hints                                                             */
    /***************************************************************************/

    public function section_colors()
    {
        $data = [
            'title' => 'Налаштування :: Кольорові підказки',
            'items' => OrderSettings::getAll('colors'),
            'scripts' => ['settings/colors.js'],
            'components' => ['color_picker', 'modal'],
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Кольорові підказки']]
        ];

        $this->view->display('settings.colors.main', $data);
    }

    public function action_color_create($post)
    {
        if (empty($post->description)) response(400, 'Заповніть опис');

        OrderSettings::insert($post, 'colors');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_color_form_update($post)
    {
        $data = [
            'title' => 'Редагування підказки',
            'item' => OrderSettings::getOne($post->id, 'colors')
        ];

        $this->view->display('settings.colors.form_update', $data);
    }

    public function action_color_update($post)
    {
        OrderSettings::update($post, $post->id, 'colors');

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_color_delete($post)
    {
        OrderSettings::delete(['id' => $post->id], 'colors');

        response(200, DATA_SUCCESS_DELETED);
    }

    /***************************************************************************/
    /* Delivery                                                                */
    /***************************************************************************/

    public function section_delivery()
    {
        $data = [
            'title' => 'Налаштування :: Доставка',
            'items' => OrderSettings::getAll('logistics'),
            'components' => ['modal'],
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Доставка']]
        ];

        $this->view->display('settings.delivery.main', $data);
    }

    public function action_delivery_create($post)
    {
        if (empty($post->name)) response(400, 'Заповніть імя!');

        OrderSettings::insert($post, 'logistics');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_delivery_form_update($post)
    {
        $data = [
            'title' => 'Редагування доставки',
            'item' => OrderSettings::getOne($post->id, 'logistics')
        ];

        $this->view->display('settings.delivery.form_update', $data);
    }

    public function action_delivery_update($post)
    {
        if (empty($post->name)) response(400, 'Заповніть назву!');

        OrderSettings::update($post, $post->id, 'logistics');
    }

    public function action_delivery_delete($post)
    {
        OrderSettings::delete(['id' => $post->id], 'logistics');

        response(200, DATA_SUCCESS_DELETED);
    }

    /***************************************************************************/
    /* Pay                                                                     */
    /***************************************************************************/

    public function section_pay()
    {
        $data = [
            'title' => 'Налаштування :: Оплата',
            'items' => OrderSettings::getAll('pays'),
            'merchants' => OrderSettings::getAll('merchant'),
            'components' => ['modal'],
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Оплата']]
        ];

        $this->view->display('settings.pay.main', $data);
    }

    public function action_pay_create($post)
    {
        if (empty($post->name)) response(400, 'Заповніть імя!');

        OrderSettings::insert($post, 'pays');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_pay_form_update($post)
    {
        $data = [
            'title' => 'Редагування оплати',
            'pay' => OrderSettings::getOne($post->id, 'pays'),
            'merchants' => OrderSettings::getAll('merchant')
        ];

        $this->view->display('settings.pay.form_update', $data);
    }

    public function action_pay_update($post)
    {
        if (empty($post->name)) response(400, 'Заповніть назву!');

        OrderSettings::update($post, $post->id, 'pays');

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_pay_delete($post)
    {
        OrderSettings::delete(['id' => $post->id], 'pays');

        response(200, DATA_SUCCESS_DELETED);
    }

    /***************************************************************************/
    /* Attributes                                                              */
    /***************************************************************************/

    public function section_attribute()
    {
        $data = [
            'title' => 'Налаштування :: Атрибути',
            'components' => ['modal'],
            'items' => OrderSettings::getWithPaginate('attributes'),
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Атрибути']]
        ];

        $this->view->display('settings.attributes.main', $data);
    }

    public function action_update_attribute_form($post)
    {
        $data = [
            'title' => 'Редагувати аттрибут',
            'attribute' => OrderSettings::getOne($post->id, 'attributes'),
        ];

        echo $this->view->render('settings.attributes.update_form', $data);
    }

    public function action_create_attribute_form()
    {
        $data = [
            'title' => 'Новий атрибут'
        ];

        $this->view->display('settings.attributes.create_form', $data);
    }

    public function action_create_attribute($post)
    {
        if (empty($post->name) || empty($post->name_ru))
            response(400, 'Заповніть назву двома мовами!');

        OrderSettings::insert($post, 'attributes');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_attribute($post)
    {
        if (empty($post->name))
            response(400, 'Заповніть назву двома мовами!');

        OrderSettings::update($post, $post->id, 'attributes');

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_attribute_delete($post)
    {
        OrderSettings::delete($post->id, 'attributes');

        response(200, DATA_SUCCESS_DELETED);
    }

    public function api_attribute_sync()
    {
        $attributes = Attributes::getAll();

        $result = [];

        foreach ($attributes as $attribute) {
            $result[] = [
                'id' => $attribute->id,
                'name_uk' => $attribute->name,
                'name_ru' => $attribute->name_ru
            ];
        }

        echo json($result);
    }

    /***************************************************************************/
    /* Order Types                                                             */
    /***************************************************************************/

    public function section_order_type()
    {
        $data = [
            'title' => 'Налаштування :: Типи замовлень',
            'components' => ['modal', 'color_picker'],
            'items' => OrderSettings::getAll('order_type'),
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Типи замовлень']]
        ];

        $this->view->display('settings.order_type.main', $data);
    }

    public function action_create_order_type_form()
    {
        $this->view->display('settings.order_type.create_order_type');
    }

    public function action_create_order_type($post)
    {
        if (empty($post->name)) response(400, 'Заповніть назву!');

        OrderSettings::insert($post, 'order_type');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_order_type_form($post)
    {
        $data = [
            'title' => 'Редагування типу замовлення',
            'order_type' => OrderSettings::getOne($post->id, 'order_type')
        ];

        $this->view->display('settings.order_type.update_order_type', $data);
    }

    public function action_update_order_type($post)
    {
        if (empty($post->name)) response(400, 'Заповніть назву типу!');

        OrderSettings::update($post, $post->id, 'order_type');

        response(200, DATA_SUCCESS_UPDATED);

    }

    public function action_delete_order_type($post)
    {
        OrderSettings::delete($post->id, 'order_type');

        response(200, DATA_SUCCESS_DELETED);
    }

    /***************************************************************************/
    /* Exchange course                                                         */
    /***************************************************************************/

    public function section_course()
    {
        $data = [
            'title' => 'Налаштування :: Курс валют',
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Курс валют']],
            'items' => OrderSettings::getAll('course'),
            'scripts' => ['exchange.js']
        ];

        $this->view->display('settings.exchange.main', $data);
    }

    public function action_update_currency($post)
    {
        OrderSettings::update_currency($post);

        response(200, DATA_SUCCESS_UPDATED);
    }

    /***************************************************************************/
    /* Sites                                                                   */
    /***************************************************************************/

    public function section_sites()
    {
        $data = [
            'title' => 'Налаштування :: Сайти',
            'components' => ['modal'],
            'items' => OrderSettings::getAll('sites'),
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Сайти']]
        ];

        $this->view->display('settings.sites.main', $data);
    }

    public function action_create_site_form()
    {
        $this->view->display('settings.sites.create_form', ['title' => 'Новий сайт']);
    }

    public function action_create_site($post)
    {
        if (empty($post->name)) response(400, 'Заповніть назву!');
        if (empty($post->url)) response(400, 'Заповніть URL!');

        OrderSettings::insert($post, 'sites');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_site_form($post)
    {
        $data = [
            'title' => 'Редагування сайту',
            'site' => OrderSettings::getOne($post->id, 'sites')
        ];

        $this->view->display('settings.sites.update_form', $data);
    }

    public function action_update_site($post)
    {
        if (empty($post->name)) response(400, 'Заповніть назву!');
        if (empty($post->url)) response(400, 'Заповніть URL!');

        OrderSettings::update($post, $post->id, 'sites');

        response(200, DATA_SUCCESS_UPDATED);

    }

    public function action_delete_site($post)
    {
        OrderSettings::delete($post->id, 'sites');

        response(200, DATA_SUCCESS_DELETED);
    }

    /***************************************************************************/
    /* IDS storage                                                             */
    /***************************************************************************/

    public function section_ids()
    {
        $data = [
            'title' => 'Налаштування :: Ідентифікатори складів',
            'components' => ['modal'],
            'items' => Storage::getIdsToEdit(),
            'scripts' => ['elements.js'],
            'css' => ['elements.css'],
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Ідентифікатори складів']]
        ];

        $this->view->display('settings.ids.main', $data);
    }

    public function action_create_ids_form()
    {
        $this->view->display('settings.ids.create_form', ['title' => 'Новий ідентифікатор складу']);
    }

    public function action_create_ids($post)
    {
        if (empty($post->value))
            response(400, 'Заповніть значення!');


        if (preg_match('@,@', $post->value)) {
            $values = explode(',', $post->value);
            foreach ($values as $value) {
                [$l1, $l2] = explode('-', $value);
                OrderSettings::insert(['level1' => $l1, 'level2' => $l2], 'ids_storage');
            }
        } else {
            [$l1, $l2] = explode('-', $post->value);
            OrderSettings::insert(['level1' => $l1, 'level2' => $l2], 'ids_storage');
        }

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_ids_form($post)
    {
        $data = [
            'title' => 'Редагування ідентифікатора складу',
            'ids' => OrderSettings::getOne($post->id, 'ids_storage')
        ];

        $this->view->display('settings.ids.update_form', $data);
    }

    public function action_update_ids($post)
    {
        if (empty($post->value))
            response(400, 'Заповніть значення!');

        [$l1, $l2] = explode('-', $post->value);

        OrderSettings::update(['level1' => $l1, 'level2' => $l2], $post->id, 'ids_storage');

        response(200, DATA_SUCCESS_UPDATED);

    }

    public function action_delete_ids($post)
    {
        if (is_string($post->id)) {
            OrderSettings::delete($post->id, 'ids_storage');
        } else {
            foreach ($post->id as $item) {
                OrderSettings::delete($item, 'ids_storage');
            }
        }

        response(200, DATA_SUCCESS_DELETED);
    }

    /***************************************************************************/
    /* Shops                                                                   */
    /***************************************************************************/

    public function section_shops()
    {
        $data = [
            'title' => 'Налаштування :: Магазини',
            'components' => ['modal'],
            'items' => OrderSettings::getAll('shops'),
            'scripts' => ['elements.js'],
            'css' => ['elements.css'],
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Магазини']]
        ];

        $this->view->display('settings.shops.main', $data);
    }

    public function action_create_shop_form()
    {
        $this->view->display('settings.shops.create_form', ['title' => 'Новий магазин']);
    }

    public function action_create_shop($post)
    {
        if (empty($post->name)) response(400, 'Заповніть назву!');
        if (empty($post->address)) response(400, 'Заповніть адресу!');

        OrderSettings::insert($post, 'shops');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_shop_form($post)
    {
        $data = [
            'title' => 'Редагування магазину',
            'shop' => OrderSettings::getOne($post->id, 'shops')
        ];

        $this->view->display('settings.shops.update_form', $data);
    }

    public function action_update_shop($post)
    {
        if (empty($post->name)) response(400, 'Заповніть назву!');
        if (empty($post->address)) response(400, 'Заповніть адресу!');;

        OrderSettings::update($post, $post->id, 'shops');

        response(200, DATA_SUCCESS_UPDATED);

    }

    public function action_delete_shop($post)
    {
        OrderSettings::delete($post->id, 'shops');

        response(200, DATA_SUCCESS_DELETED);
    }

    /***************************************************************************/
    /* Characteristics                                                         */
    /***************************************************************************/

    public function section_characteristics()
    {
        $data = [
            'title' => 'Налаштування :: Характеристики',
            'components' => ['modal'],
            'items' => OrderSettings::getWithPaginate('characteristics'),
            'scripts' => ['elements.js'],
            'css' => ['elements.css'],
            'breadcrumbs' => [['Налаштування', uri('settings')], ['Характеристики']]
        ];

        $this->view->display('settings.characteristics.main', $data);
    }

    public function action_create_characteristic_form()
    {
        $this->view->display('settings.characteristics.create_form', ['title' => 'Нова характеристика']);
    }

    public function action_create_characteristic($post)
    {
        if (empty($post->name_uk) || empty($post->name_ru))
            response(400, 'Заповніть назву двома мовами!');

        OrderSettings::insert($post, 'characteristics');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_characteristic_form($post)
    {
        $data = [
            'title' => 'Редагування характеристики',
            'characteristic' => OrderSettings::getOne($post->id, 'characteristics')
        ];

        $this->view->display('settings.characteristics.update_form', $data);
    }

    public function action_update_characteristic($post)
    {
        if (empty($post->name_uk) || empty($post->name_ru))
            response(400, 'Заповніть назву двома мовами!');

        OrderSettings::update($post, $post->id, 'characteristics');

        response(200, DATA_SUCCESS_UPDATED);

    }

    public function action_delete_characteristic($post)
    {
        OrderSettings::delete($post->id, 'characteristics');

        response(200, DATA_SUCCESS_DELETED);
    }

    public function api_characteristics_sync()
    {
        $characteristics = OrderSettings::getAll('characteristics');

        echo json($characteristics);
    }

    /***************************************************************************/
    /* Merchant                                                                */
    /***************************************************************************/

    public function section_merchant()
    {
        $data = [
            'title' => 'Налаштування :: Мерчанти',
            'breadcrumbs' => [
                ['Налаштування', uri('settings')],
                ['Мерчанти']
            ],
            'components' => ['modal'],
            'items' => OrderSettings::getAll('merchant')
        ];

        $this->view->display('settings.merchant.main', $data);
    }

    public function section_merchant_card()
    {
        $data = [
            'title' => 'Налаштування :: Карточки мерчанта',
            'breadcrumbs' => [
                ['Налаштування', uri('settings')],
                ['Мерчанти', uri('settings', ['section' => 'merchant'])],
                ['Карточки мерчанта']
            ],
            'components' => ['modal'],
            'items' => OrderSettings::findAll('merchant_card', 'merchant_id = ?', [get('id')])
        ];

        $this->view->display('settings.merchant.merchant_card', $data);
    }

    public function action_create_merchant_form()
    {
        $this->view->display('settings.merchant.forms.create_merchant', ['title' => 'Новий мерчант']);
    }

    public function action_create_merchant($post)
    {
        OrderSettings::insert($post, 'merchant');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_merchant($post)
    {
        OrderSettings::update($post, $post->id, 'merchant');

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_delete_merchant($post)
    {
        R::exec('DELETE FROM merchant WHERE id = ?', [$post->id]);
        R::exec('DELETE FROM merchant_card WHERE merchant_id = ?', [$post->id]);

        response(200, DATA_SUCCESS_DELETED);
    }

    public function action_update_merchant_form($post)
    {
        $data = [
            'title' => 'Оновлення мерчанта',
            'merchant' => OrderSettings::getOne($post->id, 'merchant')
        ];

        $this->view->display('settings.merchant.forms.update_merchant', $data);
    }

    public function action_create_merchant_card_form($post)
    {
        $data = [
            'merchant_id' => $post->merchant_id,
            'title' => 'Нова карточка'
        ];

        $this->view->display('settings.merchant.forms.create_merchant_card', $data);
    }

    public function action_update_merchant_card_form($post)
    {
        $data = [
            'card' => OrderSettings::getOne($post->id, 'merchant_card'),
            'title' => 'Редагування карточки'
        ];

        $this->view->display('settings.merchant.forms.update_merchant_card', $data);
    }

    public function action_create_merchant_card($post)
    {
        OrderSettings::insert($post, 'merchant_card');

        response(200, DATA_SUCCESS_CREATED);
    }

    public function action_update_merchant_card($post)
    {
        OrderSettings::update($post, $post->id, 'merchant_card');

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_delete_merchant_card($post)
    {
        R::exec('DELETE FROM merchant_card WHERE id = ?', [$post->id]);

        response(200, DATA_SUCCESS_DELETED);
    }

    public function section_black_dates()
    {
        $file = ROOT . '/server/black_dates.txt';

        $dates = '';
        if (is_file($file))  $dates = file_get_contents($file);

        $data = [
            'title' => 'Налаштування :: Чорна дата',
            'dates' => $dates,
            'breadcrumbs' => [
                ['Налаштування', uri('settings')],
                ['Чорна дата']
            ],
        ];

        $this->view->display('settings.black_dates', $data);
    }

    public function action_black_dates_update($post)
    {
        $file = ROOT . '/server/black_dates.txt';

        file_put_contents($file, $post->dates);

        response(200, DATA_SUCCESS_UPDATED);
    }
}