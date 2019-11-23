<?php $k = rand32(); ?>
<div class="panel-group" id="accordion<?= $k ?>">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#accordion" href="#collapse<?= $k ?>">
                    Мітки
                </a>
            </h4>
        </div>
        <div id="collapse<?= $k ?>" class="panel-collapse collapse">
            <div class="panel-body">
                <span class="text-primary">@id@</span> - Номер замовлення <br>
                *<span class="text-primary">@date@</span> - Дата виду "<?= date_for_humans(date('Y-m-d')) ?>" <br>
                *<span class="text-primary">@date2@</span> - Дата виду "<?= date('Y-m-d') ?>" <br>
                *<span class="text-primary">@datetime@</span> - Дата та час виду "<?= date('Y-m-d H:i:s') ?>" <br>
                <span class="text-primary">@ttn@</span> - Номер ТТН<br>
                <span class="text-primary">@delivery_cost@</span> - Ціна доставки<br>
                <span class="text-primary">@sum@</span> - Сума до оплати<br>
                <span class="text-primary">@discount@</span> - Знижка<br>
                <span class="text-primary">@time_with@</span> - Час доставки(ВІД 10:00)<br>
                <span class="text-primary">@time_to@</span> - Час доставки(ДО 20:00)<br>
                <span class="text-primary">@date_delivery@</span> - Дата доставки<br>
                <span class="text-primary">@full_sum@</span> - Повна сума(Сума + Доставка - Знижка)<br>
                <span class="text-primary">@site_name@</span> - Назва сайту (<i style="color: blue">Piston.kiev.ua)</i><br>
                <span class="text-primary">@site_url@</span> - Адреса сайту (<i style="color: blue">http://piston.kiev.ua/)</i><br>
                <br>
                <span style="font-size: 10px">
                        * Дата підставляється на момент відправки СМС
                    </span>
            </div>
        </div>
    </div>
</div>