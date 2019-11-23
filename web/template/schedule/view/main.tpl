<table class="table  table-bordered">
    <tr>
        <td class="centered">
            Вихідних: <?= $holidays ?> дн.
        </td>

        <td class="centered">
            Робочих: <?= $working ?> дн.
        </td>

        <td class="centered">
            У відпустці: <?= $vacation ?> дн.
        </td>

        <td class="centered">
            Лікарняних: <?= $hospital ?> дн.
        </td>
    </tr>
    <tr>
        <td class="centered">
            Робочих: <?= $working_hours - $up_working_hours ?> год.
        </td>

        <td class="centered">
            Лікарняних: <?= $hospital_hours ?> год.
        </td>

        <td class="centered" colspan="2">
            Перепрацьовано: <?= $up_working_hours ?> год.
        </td>
    </tr>
</table>

<table class="table table-bordered">
    <tr>
        <td>Число</td>
        <td>День</td>
        <td>Тип</td>
        <td>Вихід на роботу</td>
        <td>Вихід додому</td>
        <td>Пропрацював</td>
        <td>Робочий день</td>
        <td>Обід</td>
        <td>Перевиконання</td>
        <?php if (can() || user()->id == $data->user) { ?>
            <td>Дія</td>
        <?php } ?>
    </tr>
    <?php for ($i = 1; $i < day_in_month($data->month, $data->year) + 1; $i++) {
        $date = $data->year . '-' . $data->month . '-' . $i;
        $color = (date_to_day($date) == 'Неділя' || date_to_day($date) == 'Субота') ? '#f00' : '#2FAC7C';
        if (isset($schedules[$i])) {
            $item = $schedules[$i];
            ?>

            <tr style="background-color: rgba(0,255,0,.2)">
                <td><?= $i; ?></td>
                <td style="color: <?= $color ?>"><?= date_to_day($date); ?></td>
                <td>
                    <?php if ($item->type == 0): ?>
                        <span style="color: #f00"><b>Вихідний</b></span>
                    <?php elseif ($item->type == 1): ?>
                        <span style="color: #244cff"><b>Робочий</b></span>
                    <?php elseif ($item->type == 2): ?>
                        <span style="color: #0a790f"><b>Відпустка</b></span>
                    <?php elseif ($item->type == 3): ?>
                        <span style="color: #ffa500"><b>Лікарняний</b></span>
                    <?php endif; ?>
                </td>
                <td><?= $item->turn_up; ?></td>
                <td><?= $item->went_away; ?></td>
                <td>
                    <?php $item->worked = $item->went_away - $item->turn_up - $item->dinner_break;
                    if ($item->worked == $item->work_day)
                        echo '<span style="color:#00f">' . $item->worked . ' год</span>';
                    elseif ($item->worked > $item->work_day)
                        echo '<span style="color:#0f0">' . $item->worked . ' год</span>';
                    elseif ($item->worked < $item->work_day)
                        echo '<span style="color:#f00">' . $item->worked . ' год</span>';
                    ?>
                </td>
                <td><?= $item->work_day; ?></td>
                <td><?= $item->dinner_break; ?></td>
                <td>
                    <?= $item->worked - $item->work_day > 0 ? $item->worked - $item->work_day . ' год' : '0'; ?>
                </td>
                <?php if (can('schedule') || user()->id == $data->user) { ?>
                    <td>
                        <button data-type="get_form"
                                data-post="<?= params(['id' => $item->id]) ?>"
                                data-uri="<?= uri('schedule') ?>"
                                data-action="update_day_form"
                                class="btn btn-primary btn-xs">
                            <span class="glyphicon glyphicon-pencil"></span>
                        </button>
                    </td>
                <?php } ?>
            </tr>
        <?php } else { ?>
            <tr style="background-color: rgba(255,0,0,.2)">
                <td><?= $i; ?></td>
                <td style="color: <?= $color ?>"><?= date_to_day($date); ?></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <?php if (can('schedule') || user()->id == $data->user) { ?>
                    <td>
                        <?php if ($data->month == date('m') && $i > date('d')) { ?>
                            <button class="btn btn-danger btn-xs">
                                <span class="glyphicon glyphicon-lock"></span>
                            </button>
                        <?php } else { ?>
                            <button data-type="get_form"
                                    data-uri="<?= uri('schedule') ?>"
                                    data-action="create_day_form"
                                    data-post="<?= params([
                                        'year' => $data->year,
                                        'month' => $data->month,
                                        'day' => $i,
                                        'user' => $data->user
                                    ]) ?>"
                                    class="btn btn-primary btn-xs get_form">
                                <span class="glyphicon glyphicon-pencil"></span>
                            </button>
                        <?php } ?>
                    </td>
                <?php } ?>
            </tr>
        <?php }
    } ?>
</table>