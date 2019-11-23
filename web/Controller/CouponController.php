<?php

namespace Web\Controller;

use Web\Model\Coupon;
use Web\App\Controller;

class CouponController extends Controller
{
    public $access = 'coupons';

    public function section_main()
    {
        $items = Coupon::getItems();

        $data = [
            'coupons' => $items['data'],
            'paginate' => $items['paginate'],
            'title' => 'Продажі :: Купони',
            'components' => ['modal'],
            'scripts' => ['coupon.js'],
            'breadcrumbs' => [['Купони']]
        ];
        $this->view->display('coupon.main', $data);
    }

    public function action_update_form($post)
    {
        $coupon = Coupon::getOne($post->id);
        $data = [
            'title' => 'Редагування купона',
            'coupon' => $coupon
        ];
        if ($coupon->type == 1)
            $data['cumulative'] = Coupon::get_accumulation($post->id);

        echo $this->view->render('coupon.forms.update', $data);
    }

    public function action_cumulative_form()
    {
        echo $this->view->render('coupon.forms.cumulative');
    }

    public function action_stationary_form()
    {
        echo $this->view->render('coupon.forms.stationary');
    }

    public function action_create_form()
    {
        $data = [
            'title' => 'Новий купон'
        ];

        echo $this->view->render('coupon.forms.create', $data);
    }

    public function action_update($post)
    {
        if ($post->type == 'cumulative')
            Coupon::update_cumulative($post, $post->id);
        else
            Coupon::update($post, $post->id);

        response(200, DATA_SUCCESS_UPDATED);
    }

    public function action_delete($post)
    {
        Coupon::delete($post->id);

        response(200, DATA_SUCCESS_DELETED);
    }


    public function action_create($post)
    {
        if ($post->type_coupon == 0) {
            Coupon::insert($post);
        } else {
            Coupon::insert_cumulative($post);
        }

        response(200, 'Купон(и) вдало створено!');
    }
}