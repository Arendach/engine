<?php

namespace Web\Controller;

use RedBeanPHP\R;
use Web\App\Controller;

class TestController extends Controller
{
    public function section_main()
    {
        if (get('file') && is_file(ROOT . '/server/stat/' . get('file'))) {

            $file = file_get_contents(ROOT . '/server/stat/' . get('file'));

            $temp = [];
            $tl = 0;
            $strs = explode(PHP_EOL, $file);

            foreach ($strs as $item) {
                if ($item != '') {
                    $t = explode('@', $item);
                    $temp[$t[1]][] = [
                        'method' => $t[0],
                        'controller' => $t[1],
                        'uri' => $t[2],
                        'time_load' => $t[3]
                    ];
                    $tl += $t[3];
                }
            }


            $data = [
                'title' => get('file'),
                'items' => $temp,
                'tl' => round($tl / count($strs), 3),
                'breadcrumbs' => [['Файли статистики', uri('test')], [get('file')]]
            ];

        } else {
            $files = scandir(ROOT . '/server/stat/');
            unset($files[0], $files[1]);

            $data = [
                'title' => 'stat',
                'files' => $files,
                'breadcrumbs' => [['Файли статистики']]
            ];
        }


        $this->view->display('pages.test', $data);
    }

    public function section_test()
    {
        $this->view->display('pages.test1');
    }

    public function action_main()
    {
        response(200, ['action' => 'function', 'function' => 'alert(1234); swal.close(); location.reload();']);
    }

    public function section_elements()
    {
        $data = [
            'title' => 'Elements Tests',
            'css' => ['elements.css'],
            'scripts' => ['elements.js'],
            'breadcrumbs' => [['']]
        ];

        $this->view->display('pages.test.elements', $data);
    }

    public function section_test2()
    {
        $this->view->display('pages.test.test');
    }

    public function section_ids()
    {
        $items = R::findAll('ids_storage');

        foreach ($items as $item) {
            [$level1, $level2] = explode('-', $item->level1);

            $item->level1 = $level1;
            $item->level2 = $level2;

            R::store($item);
        }
    }

    public function section_coupons()
    {
        $start = '1';
        $finish = '11500';

        R::setup('mysql:host=localhost;dbname=user2327_skf;', 'user2327_skf', 'K9Dgxgw0D1', true);

        function code($int)
        {
            $nulls = '';
            if (strlen($int) < 6) for ($i = strlen($int); $i < 6; $i++) $nulls .= '0';
            return $nulls . $int;
        }

        for ($i = $start; $i <= $finish; $i++) {
            $bean = R::xdispense('h9cha_jshopping_coupons');

            $bean->coupon_type = 0;
            $bean->coupon_code = code($i);
            $bean->coupon_value = 10;
            $bean->tax_id = 0;
            $bean->used = 0;
            $bean->for_user_id = 0;
            $bean->coupon_start_date = '2018-12-24';
            $bean->coupon_expire_date = '2028-12-24';
            $bean->finished_after_used = 0;
            $bean->coupon_publish = 1;

            R::store($bean);
        }
    }
}