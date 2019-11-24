<?php

namespace Web\Model;

use RedBeanPHP\R;
use stringEncode\Exception;
use Web\App\Model;

class Reports extends Model
{
    const table = 'reports';

    public static function getReports($data = [])
    {
        if (!isset($data['year'])) $data['year'] = date('Y');
        if (!isset($data['month'])) $data['month'] = date('m');
        if (!isset($data['user'])) $data['user'] = user()->id;

        return R::findAll('reports', '
            YEAR(`reports`.`date`) = ? AND 
            MONTH(`reports`.`date`) = ? AND 
            `reports`.`user` = ?
            ORDER BY `id` DESC
        ', [$data['year'], $data['month'], $data['user']]);
    }

    public static function reserve_funds_update($sum, $act)
    {
        $bean = R::load('users', user()->id);

        if ($act == 'put') {
            $bean->reserve_funds = $bean->reserve_funds + $sum;
            $name_operation = 'Переміщення коштів у резерв!';
            $type = 'to_reserve';
            $action = '-';
        } else {
            $bean->reserve_funds = $bean->reserve_funds - $sum;
            $name_operation = 'Переміщення коштів з резерву!';
            $type = 'un_reserve';
            $action = '+';
        }

        R::store($bean);

        self::createReport((object)[
            'sum' => $sum,
            'data' => '1',
            'type' => $type,
            'name_operation' => $name_operation,
            'action' => $action
        ]);
    }

    public static function getReport($year, $month, $user, $createIfNotExists = true)
    {
        $sql = '`year` = ? AND `month` = ? AND `user` = ?';
        $binds = [$year, $month, $user];

        if (!R::count('report_items', $sql, $binds)) {
            if (date('Ym') == $year . $month) {
                if ($createIfNotExists)
                    self::createReportIfNotExists($user);
                else
                    return false;
            } else {
                return false;
            }
        }

        return R::findOne('report_items', $sql, $binds);
    }

    public static function createReport($parameters)
    {
        $required = ['sum', 'data', 'type', 'name_operation', 'action'];
        foreach ($required as $item)
            if (!isset($parameters->$item) || empty($parameters->$item))
                exit('Помилка! Неможливо створити звіт!');

        $action = $parameters->action;
        unset($parameters->action);

        $not_required = [
            'user' => user()->id,
            'date' => date('Y-m-d'),
            'comment' => 'Створено автоматично!'
        ];

        foreach ($not_required as $k => $v)
            if (!isset($parameters->$k))
                $parameters->$k = $v;

        $bean = R::dispense('reports');
        foreach ($parameters as $k => $v)
            $bean->$k = $v;
        R::store($bean);

        $bean = self::getReport(date('Y'), date('m'), user()->id);
        if ($action == '+')
            $bean->just_now = $bean->just_now + $parameters->sum;
        else
            $bean->just_now = $bean->just_now - $parameters->sum;
        R::store($bean);

    }

    public static function createMoving($post)
    {
        $bean = R::dispense('reports');

        $bean->name_operation = $post->name_operation;
        $bean->date = date('Y-m-d H:i:s');
        $bean->data = $post->user . ':0';
        $bean->sum = $post->sum;
        $bean->comment = $post->comment;
        $bean->user = user()->id;
        $bean->type = 'moving';

        R::store($bean);
    }

    public static function successMoving($post)
    {
        $report = R::load('reports', $post->report_id);

        // віднімаємо кошти від того хто надсилає
        $with_report = self::getReport(date('Y'), date('m'), $report->user);
        $with_report->just_now -= $report->sum;
        R::store($with_report);

        // додаємо кошти тому хто получає
        $to_report = self::getReport(date('Y'), date('m'), user()->id);
        $to_report->just_now += $report->sum;
        R::store($to_report);

        // створюємо звіт про отримання коштів
        $bean = R::dispense('reports');

        $bean->name_operation = $post->name_operation;
        $bean->date = date('Y-m-d H:i:s');
        $bean->data = $report->user;
        $bean->sum = $report->sum;
        $bean->comment = $post->comment;
        $bean->user = user()->id;
        $bean->type = 'moving_to';

        R::store($bean);

        // створюємо сповіщення про отримання коштів
        $bean = R::dispense('notification');

        $bean->user = $report->user;
        $bean->date = date('Y-m-d H:i:s');
        $bean->content = 'Менеджер ' . user()->login . ' підтвердив отримання коштів!';
        $bean->see = 0;
        $bean->type = 'info';

        R::store($bean);

        // змінюємо статус на прийнято
        $report->data = user()->id . ':1';
        R::store($report);

        response(200, 'Кошти вдало отримані!');
    }

    public static function createShippingCosts($post, $data)
    {
        self::actionSum($post);

        $result = '';
        foreach ($data as $k => $v) $result .= $result == '' ? $k . ':' . $v : "\n" . $k . ':' . $v;

        self::prepare($post, 'shipping_costs', $result);
    }

    public static function createExpenditures($post, $data)
    {
        self::actionSum($post);

        $result = '';
        foreach ($data as $k => $v) $result .= $result == '' ? $k . ':' . $v : "\n" . $k . ':' . $v;

        self::prepare($post, 'expenditures', $result);
    }

    public static function createProfits($post)
    {
        self::actionSum($post, false);
        self::prepare($post, 'profits');
    }

    public static function createOrder($post)
    {
        self::actionSum($post, false);
        self::prepare($post, 'order', $post->id);
    }

    public static function createPurchasePayment($post)
    {
        $post->sum = $post->sum * $post->course;

        $purchase = R::load('purchases', $post->id);

        $manufacturer = R::load('manufacturers', $purchase->manufacturer)->name;

        $storage = R::load('storage', $purchase->storage_id)->name;

        $name_operation = "Проплата закупки <b>\"$manufacturer\"</b> на склад  <b>\"$storage\"</b> ";

        self::actionSum($post);
        self::prepare([
            'sum' => $post->sum,
            'comment' => 'Створено автоматично!!!',
            'name_operation' => $name_operation], 'purchase_payment', $post->id);
    }

    public static function createOrderPrepayment($sum, $id)
    {
        $sum = (int)$sum;

        self::actionSum((object)['sum' => $sum], false);

        self::prepare((object)[
            'sum' => $sum,
            'comment' => 'Створено автоматично!!!',
            'name_operation' => 'Предоплата замовлення №' . $id
        ], 'order_prepayment', $id);
    }

    public static function createPayout($sum, $payout_id, $user_id)
    {
        self::actionSum((object)['sum' => $sum], true);

        self::prepare((object)[
            'sum' => $sum,
            'comment' => 'Створено автоматично!!!',
            'name_operation' => 'Виплата менеджеру ' . user($user_id)->login
        ], 'payout', $payout_id);
    }

    public static function updatePayout($new_sum, $payout_id)
    {
        $report = R::findOne('reports', '`data` = ? AND `type` = ?', [$payout_id, 'payout']);
        $date = date_parse($report->date);
        $report_item = self::getReport($date['year'], $date['month'], $report->user, true);

        $report_item->just_now = ($report_item->just_now + $report->sum) - $new_sum;
        $report->sum = $new_sum;

        R::store($report_item);
        R::store($report);
    }

    public static function deletePayout($payout_id)
    {
        $report = R::findOne('reports', '`data` = ? AND `type` = ?', [$payout_id, 'payout']);

        if ($report == null) return;

        $date = date_parse($report->date);
        $report_item = self::getReport($date['year'], $date['month'], $report->user, true);

        $report_item->just_now = $report_item->just_now + $report->sum;

        R::store($report_item);
        R::trash($report);
    }

    public function updateOrderPrepayment($sum, $id)
    {
        $report = R::findOne('reports', '`data` = ? AND `type` = \'order_prepayment\'', [$id]);
        $date = date_parse($report->date);
        $report_item = $this->getReport($date['year'], $date['month'], $report->user, true);

        $report_item->just_now = ($report_item->just_now - $report->sum) + $sum;
        $report->sum = $sum;

        R::store($report_item);
        R::store($report);
    }

    public function deleteOrderPrepayment($id)
    {
        $report = R::findOne('reports', '`data` = ? AND `type` = ?', [$id, 'order_prepayment']);

        $date = date_parse($report->date);
        $report_item = $this->getReport($date['year'], $date['month'], $report->user, true);

        $report_item->just_now = $report_item->just_now - $report->sum;

        R::store($report_item);
        R::trash($report);

    }

    public function createPurchasesPrepayment($sum, $manufacturer_name, $purchases)
    {
        self::actionSum((object)['sum' => $sum]);

        self::prepare((object)[
            'name_operation' => "Предоплата по закупці товару виробника \"$manufacturer_name\"",
            'sum' => $sum,
            'comment' => 'Створено автоматично!!!'
        ], 'purchases_prepayment', $purchases);
    }

    public function updatePurchasesPrepayment($sum, $purchases)
    {
        $report = R::findOne('reports', '`data` = ? AND `type` = \'purchases_prepayment\'', [$purchases]);
        $date = date_parse($report->date);
        $report_item = $this->getReport($date['year'], $date['month'], $report->user, true);

        $report_item->just_now = ($report_item->just_now - $report->sum) + $sum;
        $report->sum = $sum;

        R::store($report_item);
        R::store($report);
    }

    public static function getOldReport($year, $month, $user)
    {
        $result = [];

        $sql = '`year` = ? AND `month` = ? AND `user` = ?';
        $binds = [self::getYear($year, $month), self::getPrevMonth($month), $user];

        if (R::count('report_items', $sql, $binds)) {
            $bean = R::findOne('report_items', $sql, $binds);
            $result['just_now'] = $bean->just_now;
            $result['start_month'] = $bean->start_month;
        } else {
            $result['just_now'] = 0;
            $result['start_month'] = 0;
        }

        return $result;
    }

    public static function createReportIfNotExists($user): void
    {
        if (!R::count('report_items', '`year` = ? AND `month` = ? AND `user` = ?', [date('Y'), date('m'), $user])) {
            self::createReportItem(date('Y'), date('m'), $user);
        }
    }

    public static function createReportItem($year, $month, $user)
    {
        $bean = R::xdispense('report_items');
        $old = self::getOldReport($year, $month, $user);
        $bean->just_now = 0;
        $bean->start_month = $old['just_now'] + $old['start_month'];
        $bean->year = $year;
        $bean->month = $month;
        $bean->user = $user;
        R::store($bean);
    }

    public function normalizeReport($year, $month, $user)
    {
        $bean = R::findOne('report_items', '`year` = ? AND `month` = ? AND `user` = ?', [$year, $month, $user]);
        $old = $this->getOldReport($year, $month, $user);

        $bean->start_month = $old['just_now'] + $old['start_month'];

        R::store($bean);
    }

    public function normalizeCheck($year, $month)
    {
        $users = R::findAll('users', 'archive = 0');
        $month = month_valid($month);

        foreach ($users as $user) {
            $sql = '`year` = ? AND `month` = ? AND `user` = ?';
            $binds = [$year, $month, $user->id];
            if (R::count('report_items', $sql, $binds)) {
                $this->normalizeReport($year, $month, $user->id);
            } else {
                $this->createReportItem($year, $month, $user->id);
            }
        }
    }


    private static function getPrevMonth($month)
    {
        return $month == 1 ? 12 : $month - 1;
    }

    private static function getYear($year, $month)
    {
        return $month == 1 ? $year - 1 : $year;
    }

    // [sum, comment, name_operation] | type | data
    private static function prepare($post, $type, $data = '')
    {
        $post = object($post);

        $data = [
            'sum' => $post->sum,
            'type' => $type,
            'data' => $data,
            'comment' => $post->comment,
            'name_operation' => $post->name_operation
        ];

        self::create_report($data);
    }

    private static function actionSum($post, $minus = true)
    {
        $post = object($post);

        $report = self::getReport(date('Y'), date('m'), user()->id, true);

        if ($minus) $report->just_now -= $post->sum;
        else $report->just_now += $post->sum;

        R::store($report);
    }

    // [name_operation, data, sum, comment, type]
    private static function create_report($data)
    {
        $data = object($data);
        // створюємо звіт про отримання коштів
        $bean = R::dispense('reports');

        $bean->name_operation = $data->name_operation;
        $bean->date = date('Y-m-d H:i:s');
        $bean->data = $data->data;
        $bean->sum = $data->sum;
        $bean->comment = $data->comment;
        $bean->user = user()->id;
        $bean->type = $data->type;

        R::store($bean);
    }
}