<div class="modal fade" data-backdrop="static">
    <div class="modal-dialog<?= isset($modal_size) ? ' modal-' . $modal_size : '' ?>">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title"><?= isset($title) ? $title : ''; ?></h4>
            </div>
            <div class="modal-body">
