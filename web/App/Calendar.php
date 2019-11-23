<?php

namespace Web\App;

class Calendar
{
    public $i = 0;

    public function draw_calendar($month, $year, callable $callback)
    {
        $calendar = '<table class="calendar">';

        $headings = array('Понеділок', 'Вівторок', 'Середа', 'Четвер', 'Пятниця', '<span style="color: red">Субота</span>', '<span style="color: red">Неділя</span>');
        $calendar .= '<tr class="calendar-row"><td class="calendar-day-head">' . implode('</td><td class="calendar-day-head">', $headings) . '</td></tr>' . PHP_EOL;

        $date = mktime(0, 0, 0, $month, 1, $year);
        $running_day = date('w',$date);


        $running_day = $running_day - 1;
        if (date('D', $date) == 'Sun') $running_day = 6;

        $days_in_month = date('t', mktime(0, 0, 0, $month, 1, $year));
        $days_in_this_week = 1;
        $day_counter = 0;

        $calendar .= '<tr class="calendar-row">';

        $running_day = $running_day < 0 ? 0 : $running_day;

        for ($x = 0; $x < $running_day; $x++):
            $calendar .= '<td class="calendar-day-np">&nbsp;</td>';
            $days_in_this_week++;
        endfor;

        for ($list_day = 1; $list_day <= $days_in_month; $list_day++):
            $this->i = $this->i + 1;

            $calendar .= '<td data-id="' . $this->i . '" class="calendar-day">'  . PHP_EOL;
            $calendar .= '<div class="day-number">' . $list_day . '</div>';

            $calendar .= $callback($year, $month, $list_day);

            $calendar .= '</td>' . PHP_EOL;
            if ($running_day == 6):
                $calendar .= '</tr>' . PHP_EOL;
                if (($day_counter + 1) != $days_in_month):
                    $calendar .= '<tr class="calendar-row">';
                endif;
                $running_day = -1;
                $days_in_this_week = 0;
            endif;
            $days_in_this_week++;
            $running_day++;
            $day_counter++;
        endfor;

        if ($days_in_this_week < 8):
            for ($x = 1; $x <= (8 - $days_in_this_week); $x++):
                $calendar .= '<td class="calendar-day-np">&nbsp;</td>' . PHP_EOL;
            endfor;
        endif;

        $calendar .= '</tr>' . PHP_EOL;

        $calendar .= '</table>' . PHP_EOL;

        return $calendar;
    }
}