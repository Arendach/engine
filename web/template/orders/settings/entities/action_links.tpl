<div class="center">
    <?php foreach ($actions_links as $item): ?>
        <a data-action="<?php print($item->action) ?>" data-id="<?php print($item->id) ?>">Видалити</a>
    <?php endforeach ?>
</div>