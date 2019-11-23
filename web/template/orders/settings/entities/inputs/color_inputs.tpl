<div class="input-group col-sm-12">
    <form class="form-create">
        <input type="hidden" name="form" value="<?= $form; ?>">
        <div class="form-group">
            <input id="<?= $input['id'] ?>" name="<?php print($input['name']) ?>" class="form-control"
                   placeholder="<?= $input['placeholder'] ?>">
        </div>

        <div class="form-group">
            <input class="form-control" maxlength="6" size="6" id="colorpickerField" value="00ff00"
                   name="<?= $color['name'] ?>"/>
        </div>
        <div class="form-group">
            <button data-selector="u_btn" class="btn btn-primary save"><?php print($button['name']) ?></button>
        </div>
    </form>
</div>