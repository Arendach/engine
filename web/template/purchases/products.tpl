<?php foreach ($items as $item) { ?>
    <div class="product-item relative" data-id="<?= $item->id ?>">
        <?= $item->name ?>
        <span class="count_on_storage">На складі: <?= $item->count_on_storage ?></span>
    </div>
<?php } ?>