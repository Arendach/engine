<?php

use RedBeanPHP\R;

$title = 'Планувальник відпусток';
$GLOBALS['vacations'] = $vacations;
$GLOBALS['users'] = $users;
$calendar = new  Web\App\Calendar();

include parts('head'); ?>

    <div class="right">
        <button class="btn btn-primary vacation_add_form">Забронювати відпустку</button>
    </div>

    <h2>Менеджери у відпустці (днів)</h2>
    <div style="padding: 15px; border: 1px solid #ccc; margin-top: 15px;">
        <?php foreach ($users as $user) {
            $count = R::count('vacations', 'user = ? AND YEAR(date) = ?', [$user->id, date('Y')]);
            if ($count > 0)
                echo $user->login . ': <b class="text-primary">' . $count . '</b><hr style="margin: 5px 0">';
        } ?>
    </div>

<?php

for ($month = 1; $month <= 12; $month++) { ?>
    <h2><?= int_to_month($month) ?></h2>

    <?= $calendar->draw_calendar($month, date('Y'), function ($year, $month, $day) {
        $users = $GLOBALS['users'];
        $vacations = $GLOBALS['vacations'];
        $date = $year . '-' . month_valid($month) . '-' . month_valid($day);

        if (isset($vacations[$date])) {
            $result = '';
            foreach ($vacations[$date] as $item) {
                $data_delete = 'data-type="delete" ';
                $data_delete .= 'data-uri="' . uri('vacation') . '" ';
                $data_delete .= 'data-action="delete_day" ';
                $data_delete .= 'data-id="' . $item['id'] . '" ';

                $result .= '<span style="color: #0a790f">' . $users[$item['user']]->login . '</span>';

                if (can() || user()->id == $item['user'])
                    $result .= ' <i ' . $data_delete . ' class="fa fa-remove pointer text-danger"></i>';

                $result .= '<hr style="margin: 5px 0">';
            }

            return preg_replace('@<hr style="margin: 5px 0">$@', '', $result);
        }

        return '';
    }); ?>
<? }

?>

<?php include parts('foot') ?>