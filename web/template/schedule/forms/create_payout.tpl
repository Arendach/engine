<?php include parts('modal_head'); ?>

    <form action="<?= uri('schedule') ?>" data-type="ajax">

        <input type="hidden" name="action" value="create_payout">
        <input type="hidden" name="year" value="<?= $year ?>">
        <input type="hidden" name="month" value="<?= $month ?>">
        <input type="hidden" name="user" value="<?= $user ?>">

        <div class="form-group">
            <label for="sum"><i class="text-danger">*</i> Сума(грн)</label>
            <input required pattern="[0-9\.]+" class="form-control input-sm" id="sum" name="sum" data-inspect="decimal">
            <div style="color: grey; font-size: 12px">
                Максимальна сума виплати:
                <span class="max_payout" style="color: blue"><?= $max_payout['max'] ?></span> грн
            </div>
        </div>

        <script>
            $(document).ready(function () {
                $('#sum').on('keyup', function () {
                    if (+$(this).val() > +$('.max_payout').text())
                        $(this).val(+$('.max_payout').text());
                });
            });
        </script>

        <div class="form-group">
            <label for="comment">Коментар</label>
            <textarea class="form-control input-sm" name="comment" id="comment"></textarea>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>

    </form>

<?php include parts('modal_foot'); ?>