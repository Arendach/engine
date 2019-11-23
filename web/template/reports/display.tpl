<?php

function parse_report_type($str)
{
    switch ($str) {
        case 'purchase_payment':
            return 'Проплата закупки';
            break;
        case 'purchases':
            return 'Закупка';
            break;
        case 'profits':
            return 'Прибуток';
            break;
        case 'shipping_costs':
            return 'Витрати на доставку';
            break;
        case 'expenditures':
            return 'Видатки';
            break;
        case 'moving':
            return 'Передача коштів';
            break;
        case 'purchases_prepayment':
            return 'Предоплата закупки';
            break;
        case 'moving_to':
            return 'Отримання коштів';
            break;
        case 'order':
            return 'Закриття замовлення';
            break;
        case 'order_prepayment':
            return 'Предоплата замовлення';
            break;
        case 'payout':
            return 'Виплата';
            break;
        case 'un_reserve':
            return 'З резерву';
            break;
            case 'to_reserve':
            return 'В резерв';
            break;
        default:
            return '';
    }
}

function get_color($type)
{
    if (in_array($type, ['purchase_payment', 'purchases', 'purchases_prepayment', 'shipping_costs', 'moving', 'expenditures', 'payout','to_reserve'])) {
        return 'rgba(255,0,0,.1)';
    } else {
        return 'rgba(0,255,0,.1)';
    }
}

function get_sum($sum, $type)
{
    if (in_array($type, ['purchase_payment', 'purchases', 'purchases_prepayment', 'shipping_costs', 'moving', 'expenditures', 'payout', 'to_reserve'])) {
        return '-' . number_format($sum, 2);
    } else {
        return '+' . number_format($sum, 2);
    }
}

?>

<?php include parts('head') ?>

    <div class="right">

        <a href="<?= uri('reports') . parameters(['section' => 'statistics', 'user' => $report_item->user]) ?>" class="btn btn-primary">
            Статистика
        </a>
        <a href="<?= uri('reports') . parameters(['section' => 'reserve_funds']) ?>" class="btn btn-success">
            Резервний фонд
        </a>
        <a href="<?= uri('reports', ['section' => 'moving']) ?>" class="btn btn-success">
            Переміщення коштів
        </a>
        <a href="<?= uri('reports', ['section' => 'expenditures']) ?>" class="btn btn-success">
            Видатки
        </a>
        <a href="<?= uri('reports', ['section' => 'shipping_costs']) ?>" class="btn btn-success">
            Витрати на доставку
        </a>
        <?php if (can()) { ?>
            <a href="<?= uri('reports', ['section' => 'profits']) ?>" class="btn btn-success">
                Коректування
            </a>
        <?php } ?>
    </div>

    <br>

    <table class="table">
        <tr>
            <td style="border-top: none" class="right">
                Цього місяця
                <span class="badge">
                    <?= $report_item->just_now ?> грн
                </span>
            </td>

            <td style="border-top: none; text-align: center;">
                На руках <span class="badge" style="background-color: #369">
                    <?= $report_item->start_month + $report_item->just_now ?> грн
                </span>
            </td>

            <td style="border-top: none">
                На початок місяця <span class="badge">
                    <?= $report_item->start_month ?> грн
                </span>
            </td>

            <td style="border-top: none" class="right">
                В резерві: <span class="badge" style="background-color: green"><?= user($user)->reserve_funds ?></span>
            </td>
        </tr>
    </table>

    <table class="table table-bordered">
        <tr>
            <td><b>Число</b></td>
            <td><b>Назва операції</b></td>
            <td><b>Тип</b></td>
            <td><b>Сума</b></td>
            <td><b>Коментар</b></td>
            <td class="action-2"><b>Дії</b></td>
        </tr>
        <?php foreach ($reports as $report) { ?>
            <tr style="background-color: <?= get_color($report->type) ?>" data-id="<?= $report->id ?>">
                <td><?= date_parse($report->date)['day'] ?></td>
                <td><?= $report->name_operation ?></td>
                <td><?= parse_report_type($report->type) ?></td>
                <td><?= get_sum($report->sum, $report->type) ?> грн</td>
                <td><?= $report->comment ?></td>
                <td class="action-2 relative">
                    <div id="preview_<?= $report->id ?>" class="preview_container"></div>
                    <button class="btn btn-primary btn-xs preview" title="Детальніше...">
                        <i class="fa fa-question "></i>
                    </button>
                    <button data-type="get_form"
                            data-uri="<?= uri('reports') ?>"
                            data-action="update_form"
                            data-post="<?= params(['id' => $report->id]) ?>"
                            class="btn btn-primary btn-xs"
                            title="Редагувати">
                        <i class="fa fa-pencil"></i>
                    </button>
                </td>
            </tr>
        <?php } ?>
    </table>

    <script>
        $(document).ready(function () {
            var $body = $('body');

            $body.on('click', '.preview', function () {
                var id = $(this).parents('tr').data('id');

                function ajax() {
                    $.ajax({
                        type: 'post',
                        url: url('reports'),
                        data: {id: id, action: 'preview'},
                        success: function (answer) {
                            $('#preview_' + id).html(answer);
                        },
                        error: function (answer) {
                            errorHandler(answer);
                        }
                    });
                }

                var is_set = false;

                $('.preview_container').each(function () {
                    if ($(this).html() != '')
                        is_set = true;
                });

                if (!is_set) {
                    ajax();
                } else {
                    if ($('#preview_' + id).html() != '') {
                        $('.preview_container').html('');
                    } else {
                        $('.preview_container').html('');
                        ajax();
                    }
                }
            });
        });
    </script>

<?php include parts('foot') ?>