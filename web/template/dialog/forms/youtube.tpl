<form id="send_youtube_message">

    <input type="hidden" name="dialog_id" value="<?= get('dialog_id') ?>">

    <div class="form-group">
        <input name="link" placeholder="Введіть ссилку на відео або ID!" class="form-control">
    </div>

    <div class="form-group centered">
        <button class="btn btn-primary">Відправити</button>
    </div>

</form>