<ul class="nav nav-pills">
    <?php foreach ($links as $item): ?>
        <li class="<?= $item['class'] ?>">
            <a href="<?php print($item['action']) ?>">
                <?= $item['name'] ?>
            </a>
        </li>
    <?php endforeach ?>
</ul>