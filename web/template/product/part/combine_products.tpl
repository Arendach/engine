<?php foreach (get_array($combine_products) as $key => $item) { ?>
    <div data-id="<?= $item['id'] ?>" class="combine_products_item"
         style="position: relative">
        <b><?= $item['name'] ?></b>
        <hr style="margin: 10px 0">
        <div class="row">
            <div class="col-md-6">
                <label>Кількість</label>
                <input name="amounts[]" class="amount" value="<?= isset($type) && $type == 'add' ? 1 : $item['combine_minus'] ?>" data-inspect="integer">
            </div>

            <input type="hidden" name="ids[]" value="<?= $item['id'] ?>">

            <div class="col-md-6">
                <label>Вартість</label>
                <input name="prices[]" class="price"
                       value="<?= isset($type) && $type == 'add' ? $item['costs'] : $item['combine_price'] ?>" data-inspect="decimal">
            </div>
        </div>
        <button style="position: absolute;top: -1px;right: -1px;"
                type="button"
                class="btn btn-danger btn-xs delete_combine_product">
            <i class="fa fa-remove"></i>
        </button>
    </div>
<?php } ?>