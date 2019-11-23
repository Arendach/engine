<?php if (my_count($combines) > 0) {
    foreach ($combines as $key => $item) { ?>
        <li class="list-group-item justify-content-between combine-items" id="<?= $item['id'] ?>">
            <div class="input-group">
            <span class="input-group-addon">
                <span class="show_hover">
                    <?= $item['name'] ?>
                </span>
            </span>
                <input data-type="cost" value="<?= $item['combine_price']; ?>"
                       class="form-control lsSumsInp combine-field"
                       placeholder="Ціна">
                <input data-type="minus" value="<?= $item['combine_minus']; ?>" class="form-control combine-field"
                       placeholder="Віднімати з складу">
                <input data-type="id" class="combine-field" type="hidden" value="<?= $item['linked_id']; ?>">
                <span class="input-group-addon deletable">x</span>
            </div>
        </li>
    <?php }
} ?>