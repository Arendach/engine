<?php include parts('head'); ?>

<h2 class="sub-header"><?= $section ?></h2>

<ol class="breadcrumb breadcrumb-arrow">
    <li><a href="<?= route('index'); ?>"><i class="fa fa-dashboard"></i></a></li>
    <li class="active"><span><?= $section ?></span></li>
</ol>

<div class="pull-right" style="margin-bottom: 10px">
    <?= $buttons ?>
</div>

<div class="content-section">
    <?= $content ?>
</div>

<?php include parts('foot'); ?>
