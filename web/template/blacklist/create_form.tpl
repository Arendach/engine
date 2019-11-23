<?php include parts('modal_head') ?>

    <form action="<?= uri('blacklist') ?>" data-type="ajax">
        <input type="hidden" name="action" value="create">

        <div class="form-group">
            <label>Імя</label>
            <input name="name" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label>Телефон</label>
            <input required pattern="^[0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}$" id="phone" name="phone" class="form-control input-sm">
        </div>

        <div class="form-group">
            <label>Коментар</label>
            <textarea name="comment" class="form-control input-sm"></textarea>
        </div>

        <div class="form-group" style="margin-bottom: 0;">
            <button class="btn btn-primary btn-sm">Зберегти</button>
        </div>
        
    </form>

    <script>
        $('#phone').inputmask('999-999-99-99')
    </script>

<?php include parts('modal_foot') ?>