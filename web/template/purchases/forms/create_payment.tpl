<?php include parts('modal_head') ?>

    <form action="<?= uri('purchases') ?>" data-type="ajax">
        <input type="hidden" name="id" value="<?= $id ?>">
        <input type="hidden" name="action" value="payment_create">

        <input type="hidden" id="full_sum" value="<?= $sum ?>">
        <input type="hidden" id="payed" value="<?= $payed ?>">

        <div class="form-group">
            <label><i class="text-danger">*</i> Курс</label>
            <input required class="form-control input-sm" name="course" value="<?= app()->course ?>" data-inspect="decimal">
        </div>

        <div class="form-group">
            <label><i class="text-danger">*</i> В доларах</label>
            <input required name="sum" class="form-control input-sm" data-inspect="decimal">
            <span class="help-block">макс. <?= $sum - $payed ?>$</span>
        </div>

        <div class="form-group">
            <label>В гривнях</label>
            <input disabled id="grn" class="form-control input-sm">
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>

    </form>

    <script>
        $(document).on('keyup change', '[name=sum],[name=course]', function () {
            var course = $('[name=course]').val().replace(/,/, '.');
            course = course.replace(/\s/, '');

            var sum = $('[name=sum]').val().replace(/,/, '.');
            sum = sum.replace(/\s/, '');

            $('#grn').val(+sum * +course);
        });

        $(document).on('keyup change', '[name=sum]', function () {
            var $this = $(this);
            var full_sum = $('#full_sum').val();
            var payed = $('#payed').val();

            if ($this.val() > +full_sum - +payed) $this.val(+full_sum - +payed);
        });
    </script>

<?php include parts('modal_foot') ?>