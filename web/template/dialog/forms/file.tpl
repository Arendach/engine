<form class="upload" id="upload_file" method="post" action="<?= uri('/dialog/send_file') ?>" enctype="multipart/form-data">
    <div id="drop">
        Перетягніть файл
        <a>Огляд</a>
        <input type="file" name="upl">
    </div>

    <input type="hidden" name="dialog_id" value="<?= get('dialog_id') ?>">

    <ul>

    </ul>
</form>