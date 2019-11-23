<form id="send_text_message">

    <input type="hidden" name="dialog_id" value="<?= get('dialog_id') ?>">

    <div class="form-group">
        <textarea name="message" placeholder="Введіть повідомлення!" class="form-control"></textarea>
    </div>

    <div class="form-group centered">
        <button class="btn btn-primary">Відправити</button>
    </div>

</form>