<form class="upload" id="upload_photo" method="post" action="<?= uri('/dialog/send_photo') ?>" enctype="multipart/form-data">
    <div id="drop">
        Перетягніть Фото
        <a>Огляд</a>
        <input accept="image/*" type="file" name="photo">
    </div>

    <input type="hidden" name="dialog_id" value="<?= get('dialog_id') ?>">

</form>