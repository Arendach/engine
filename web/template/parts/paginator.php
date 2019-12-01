<?php if ($paginator->hasPages()) { ?>
    <nav class="centered">
        <ul class="pagination">
            <?php if ($paginator->onFirstPage()) { ?>
                <li class="disabled" aria-disabled="true">
                <span aria-hidden="true">
                    &lsaquo;
                </span>
                </li>
            <?php } else { ?>
                <li>
                    <a href="<?= $paginator->previousPageUrl() ?>" rel="prev">
                        &lsaquo;
                    </a>
                </li>
            <?php } ?>

            <?php foreach ($elements as $element) { ?>
                <?php if (is_string($element)) { ?>
                    <li class="disabled" aria-disabled="true">
                    <span>
                        <?= $element ?>
                    </span>
                    </li>
                <?php } ?>

                <?php if (is_array($element)) { ?>
                    <?php foreach ($element as $page => $url) { ?>
                        <?php if ($page == $paginator->currentPage()) { ?>
                            <li class="active" aria-current="page">
                                <span>
                                    <?= $page ?>
                                </span>
                            </li>
                        <?php } else { ?>
                            <li>
                                <a href="<?= $url ?>">
                                    <?= $page ?>
                                </a>
                            </li>
                        <?php } ?>
                    <?php } ?>
                <?php } ?>
            <?php } ?>

            <?php if ($paginator->hasMorePages()) { ?>
                <li>
                    <a href="<?= $paginator->nextPageUrl() ?>" rel="next">
                        &rsaquo;
                    </a>
                </li>
            <?php } else { ?>
                <li class="disabled" aria-disabled="true">
                    <span aria-hidden="true">
                        &rsaquo;
                    </span>
                </li>
            <?php } ?>
        </ul>
    </nav>
<?php } ?>