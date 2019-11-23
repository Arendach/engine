<?php foreach ($characteristics as $item) { ?>
    <li class="list-group-item pointer get_searched_characteristic" data-id="<?= $item->id ?>">
        <?= $item->name_uk ?>
    </li>
<?php } ?>