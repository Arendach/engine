<?php include parts('head'); ?>

<ul class="nav nav-pills nav-justified">
    <li class="active"><a href="#main" data-toggle="tab">Графік</a></li>
    <li><a href="#bonuses" data-toggle="tab">Бонуси і штрафи</a></li>
    <li><a href="#payouts" data-toggle="tab">Виплати</a></li>
    <li><a href="#all" data-toggle="tab">Підсумки</a></li>
</ul>

<div class="tab-content" style="margin-top: 15px;">
    <div class="tab-pane active" id="main">
        <?php include t_file('schedule.view.main') ?>
    </div>

    <div class="tab-pane" id="bonuses">
        <?php include t_file('schedule.view.bonuses') ?>
    </div>

    <div class="tab-pane" id="payouts">

        <?php include t_file('schedule.view.payouts') ?>
    </div>

    <div class="tab-pane" id="all">
        <?php include t_file('schedule.view.all') ?>
    </div>
</div>

<script>
    $(document).ready(function () {

        var $body = $('body');

        $body.on('keyup', '#work_day', function () {
            var worked = +$('#went_away').val() - (+$('#turn_up').val() + +$('#dinner_break').val());
            if (worked < +$('#work_day').val())
                $('#work_day').val(worked);
        });

        $body.on('keyup', '.time', function () {
            var $this = $(this);
            var array = [];
            for (var i = 0; i < 25; i++)
                array.push(i);

            if ($.inArray(+$this.val(), array) === -1)
                $($this.val(0))
        });

        $body.on('change', '[name=type]', function () {
            if ($(this).val() == '2' || $(this).val() == '3') {
                $('#turn_up').val('9').attr('disabled','disabled');
                $('#went_away').val('17').attr('disabled','disabled');
                $('#dinner_break').val('0').attr('disabled','disabled');
                $('#work_day').val('8').attr('disabled','disabled');
            } else {
                $('#turn_up').removeAttr('disabled');
                $('#went_away').removeAttr('disabled');
                $('#dinner_break').removeAttr('disabled');
                $('#work_day').removeAttr('disabled');
            }
        });

    });
</script>


<?php include parts('foot'); ?>
