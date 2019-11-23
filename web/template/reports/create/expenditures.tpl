<?php include parts('head') ?>

    <form data-type="ajax" action="<?= uri('reports') ?>">

        <input type="hidden" name="action" value="create_expenditures">

        <div class="form-group">
            <label for="taxes">Податки</label>
            <input class="form-control count" id="taxes" name="taxes" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="investment">Інвестиції</label>
            <input class="form-control count" id="investment" name="investment" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="mobile">Мобільний звязок</label>
            <input class="form-control count" id="mobile" name="mobile" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="rent">Оренда</label>
            <input class="form-control count" id="rent" name="rent" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="social">Соціальні програми</label>
            <input class="form-control count" id="social" name="social" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="other">Витратні матеріали</label>
            <input class="form-control count" id="other" name="other" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="advert">Реклама</label>
            <input class="form-control count" id="advert" name="advert" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label for="sum"><i class="text-danger">*</i> Сума</label>
            <input disabled type="text" class="form-control" id="sum">
            <input type="hidden" name="sum" value="0">
        </div>

        <div class="form-group">
            <label for="name_operation"><i class="text-danger">*</i> Назва операції</label>
            <input required type="text" class="form-control" id="name_operation" name="name_operation"
                   value="Видатки <?= date_for_humans() ?>">
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

        });
    </script>

<?php include parts('foot') ?>