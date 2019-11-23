<div class="input-group col-sm-12">
    <form class="form-create">
        <input type="hidden" name="form" value="<?= $form; ?>">
        <input name="<?= $input['name'] ?>" class="form-control" placeholder="<?= $input['placeholder'] ?>">
        <span class="input-group-btn">
            <button data-selector="u_btn" class="btn btn-secondary save" type="button"><?= $button['name'] ?></button>
        </span>
    </form>
</div>