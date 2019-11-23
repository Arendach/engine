<ol class="breadcrumb breadcrumb-arrow" style="margin-bottom: 15px">
    <li><a href="<?= uri('/'); ?>"><i class="fa fa-dashboard"></i></a></li>
    <?php $i = 1; foreach ($breadcrumbs as $item) { ?>
        <?php if ($i == count($breadcrumbs)) { ?>
            <li class="active"><span><?= $item[0] ?></span></li>
        <?php } else { ?>
            <li><a href="<?= $item[1]?>"><?= $item[0] ?></a></li>
        <?php } ?>
        <?php $i++; ?>
    <?php } ?>
</ol>