</div>
</div>

<div class="scripts-hidden">
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

    <script src="<?= asset('js/app.js') ?>"></script>

    <?php if (isset($editor) && $editor == 'full') { ?>
        <script src="<?= asset('ckeditor/ckeditor.js') ?>"></script>
    <?php } else { ?>
        <script src="<?= asset('ckeditor_basic/ckeditor.js') ?>"></script>
    <?php } ?>

    <?php if (isset($controller) && is_file(public_path("js/controllers/$controller.js"))) { ?>
        <script src="<?= asset("js/controllers/$controller.js") ?>"></script>
    <?php } ?>
</div>

</body>
</html>