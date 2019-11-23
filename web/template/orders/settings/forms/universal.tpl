<div class="modal_head"><span id="modal_close">X</span></div>
<div id="modal_body">
    <form>
        <input type="hidden" name="id" value="<?= $id; ?>">
        <input type="hidden" name="form" value="<?= $form; ?>">
        <h2 class="centered">Редагування даних</h2>
        <div class="form-group">
            <label for="name">Імя</label>
            <input name="name" id="name" class="form-control" value="<?= $name; ?>">
        </div>

        <div class="form-group">
            <button class="btn btn-primary send">Зберегти</button>
        </div>
    </form>
</div>