<?php include parts('head') ?>

    <form data-type="ajax" action="<?= uri('reports') ?>">

        <input type="hidden" name="action" value="create_shipping_costs">

        <div class="form-group">
            <label for="gasoline">Бензин</label><br>
            <input class="benzine" placeholder="грн/км" data-inspect="integer">
            <input class="benzine" placeholder="км" data-inspect="integer">
            <input class="form-control field count" id="gasoline" name="gasoline" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="journey">Проїзд</label>
            <input class="form-control count" id="journey" name="journey" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="transport_company">Транспортні компанії</label>
            <input class="form-control count" id="transport_company" name="transport_company" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="packing_materials">Пакувальні матеріали</label>
            <input class="form-control count" id="packing_materials" name="packing_materials" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="for_auto">Амортизація авто</label>
            <input class="form-control count" id="for_auto" name="for_auto" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="salary_courier">Зарплата курєрам</label>
            <input class="form-control count" id="salary_courier" name="salary_courier" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="supplies">Витратні матеріали(інше)</label>
            <input class="form-control count" id="supplies" name="supplies" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="sum"><i class="text-danger">*</i> Сума</label>
            <input type="text" disabled class="form-control" id="sum">
            <input type="hidden" name="sum" value="0">
        </div>

        <div class="form-group">
            <label for="name_operation"><i class="text-danger">*</i> Назва операції</label>
            <input type="text" class="form-control" id="name_operation" name="name_operation"
                   value="Витрати на доставку">
        </div>

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea class="form-control" id="comment" name="comment"></textarea>
        </div>

        <div class="form-group">
            <button class="btn btn-primary">Прийняти</button>
        </div>

    </form>

    <script>
        $(document).ready(function () {
            var $body = $('body');

            function count_() {
                var sum = 0,
                    name_operation = '';
                $('.count').each(function () {
                    if ($(this).val() != '') {
                        var text = $(this).siblings('label').text();
                        name_operation += name_operation == '' ? text : ' + ' + text;
                    }

                    var t = $(this).val();
                    t = t.replace(/,/, '.');
                    t = t.replace(/\s/g, '');

                    sum += +t;
                });
                $('#sum').val(sum);
                $('[name="sum"]').val(sum);
                $('#name_operation').val(name_operation + ' = ' + sum + ' грн');

            }

            $body.on('keyup', '.count', count_);

            $body.on('keyup', '.benzine', function () {
                var sum = 1;
                $('.benzine').each(function () {
                    sum *= $(this).val();
                });
                $('#gasoline').val(sum);
                count_();
            })
        });
    </script>


<?php include parts('foot') ?>