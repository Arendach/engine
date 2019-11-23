<?php

$url = $paginate['url'];
$url_page = $paginate['url_page'];
$active = $paginate['active'];
$count_pages = $paginate['count_pages'];
$prev = $active == 2 ? $url : $url_page . ($active - 1);
$next = $url_page . ($active + 1);

$start = 1;
if ($paginate['count_pages'] > 1) {
    $left = $active - 1;
    $right = 5 - $active;
    $start = $active - 1 < floor(5 / 2) ? 1 : $active - floor(5 / 2);
    $end = $start + 4;
    if ($end > $count_pages) {
        $start -= $end - $count_pages;
        $end = $count_pages;
        $start = $start < 1 ? 1 : $start;
    }
}

if ($count_pages > 1) { ?>
    <ul class="pagination">
        <?php if ($paginate['active'] != 1) { ?>
            <li><a class="arrow" href="<?= $prev ?>" title="Попередня сторінка">&laquo;</a></li>
            <?php if (!in_array($active, [2, 3])) { ?>
                <li><a href="<?= $url ?>">1</a></li>
                <?php if ($active != 4) { ?>
                    <li class="disabled"><a href="#">...</a></li>
                <?php } ?>
            <?php } ?>
        <?php } ?>
        <?php for ($i = $start; $i <= $end; $i++) { ?>
            <?php if ($i == $active) { ?>
                <li class="active"><a href="#"><?= $i ?><span class="sr-only">(current)</span></a></li>
            <?php } else { ?>
                <li><a href="<?= $i == 1 ? $url : $url_page . $i ?>"><?= $i ?></a></li>
            <?php } ?>
        <?php } ?>
        <?php if ($active != $count_pages) {
            if (!in_array($count_pages, [2, 3, 4, 5]) and !in_array($active, [$count_pages - 1, $count_pages - 2])) {
                if (!in_array($count_pages - $active, [1, 2]) and !in_array($count_pages, [5, 6]) and ($count_pages - 3) != $active) { ?>
                    <li class="disabled"><a href="#">...</a></li>
                <?php } ?>
                <li><a href="<?= $url_page . $count_pages ?>"><?= $count_pages ?></a></li>
                <?php
            }
            ?>
            <li><a class="arrow" href="<?= $next ?>" title="Наступна сторінка">&raquo;</a></li>
        <?php } ?>
    </ul>
<?php } ?>