</div>

<script type="text/javascript">
    let pin = '<?= user()->pin ?>';
    let my_url = '<?= SITE; ?>';
</script>

<?php if (isset($toJs)) { ?>
    <script>
        /**
         * @var object
         */
        window.JData = <?= json_encode($toJs) ?>
    </script>
<?php } ?>

<script type="text/javascript" src="<?= asset("js/jquery.js") ?>"></script>
<script type="text/javascript" src="<?= asset("js/components/jquery/cookie.js") ?>"></script>
<script type="text/javascript" src="<?= asset('js/components/jquery/serialize_json.js') ?>"></script>
<script type="text/javascript" src="<?= asset('js/components/jquery/jquery-ui.js') ?>"></script>
<script type="text/javascript" src="<?= asset("js/URLs.js") ?>"></script>
<script type="text/javascript" src="<?= asset("js/common.js") ?>"></script>

<?= $JS_COMPONENTS ?>

<?php if (isset($scripts)) { ?>
    <?php foreach ($scripts as $script) { ?>
        <?php if (preg_match('@^https?@', $script)) { ?>
            <script type="text/javascript" src="<?= $script ?>"></script>
        <?php } else { ?>
            <script type="text/javascript" src="<?= asset("js/" . p2s($script) . ".js") ?>"></script>
        <?php } ?>
    <?php } ?>
<?php } ?>

</body>
</html>