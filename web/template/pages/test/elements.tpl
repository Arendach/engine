<?php include parts('head'); ?>

    <div id="form">

        <span data-name="check1" class="checkbox"> Check me</span> <br>
        <span data-name="check2" class="checkbox"> Check me2</span>

        <div class="select" data-name="select1">
            <div class="option" data-value="lorem">lorem</div>
            <div class="option" data-value="ipsum">ipsum</div>
            <div class="option" data-value="dolor">dolor</div>
        </div>

        <div class="select" data-name="select2">
            <div class="option" data-value="sit">sit</div>
            <div class="option" data-value="amet">amet</div>
            <div class="option" data-value="consectetur">consectetur</div>
        </div>

        <button class="test">test</button>


    </div>
    <script>
        $(document).ready(function () {
            $('.test').on('click', function () {
                console.log(Elements.formSerialize('#form'));
            });
        });
    </script>


<?php include parts('foot'); ?>