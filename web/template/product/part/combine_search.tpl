<?php foreach ($products as $item) { ?>
    <a href="#" data-id="<?= $item->id ?>" class="list-group-item get_product_to_combine"><?= $item->name ?></a>
<?php } ?>