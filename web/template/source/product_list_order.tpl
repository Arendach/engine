<?php foreach ($products as $product){ ?>

<tr data-id="<?= $product->id;?>" class="product">
    <td><?= $product->name;?></td>
    <td><?= $product->identefire_storage;?></td>
    <td><?= $product->articul;?></td>

    <td>
        <div class="input-group">
            <span class="input-group-addon"><?= $product->count_on_storage ?></span>
            <input type="text" class="el_amount form-control" value="<?= $product->count_on_storage ? 1 : 0 ?>">
        </div>
    </td>

    <td>
        <div class="input-group">
            <input type="text" class="el_price form-control" value="<?= $product->price ?>">
        </div>
    </td>

    <td>
        <div class="input-group">
            <input type="text" class="el_sum form-control" value="<?= $product->price;?>">
        </div>
    </td>

    <td class="attributes">
        <?php foreach($product->attributes as $key => $attr){ ?>
        <div>
            <label><?= $key ?></label>
            <select data-key="<?= $key ?>">
                <?php foreach($attr as $k => $val){ ?>
                <option value="<?= $val ?>"><?= $val ?></option>
                <?php } ?>
            </select>
        </div>
        <?php } ?>
    </td>

    <td>
        <input class="place" value="1">
    </td>

    <td>
        <button class="btn btn-danger drop_product">Видалити</button>
        <button class="btn btn-success save_product">Зберегти</button>
    </td>
</tr>

<?php } ?>