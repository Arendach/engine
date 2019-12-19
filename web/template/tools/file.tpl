<div class="input-file-container">
    <label class="alert alert-info">
        <input type="file"
               class="input-file-input"
               name="<?= $name ?><?= $multiple ? '[]' : '' ?>"
            <?= $multiple ? 'multiple' : '' ?>
               style="display: none">
        Натисніть щоб вибрати файл
    </label>

    <div class="input-file-names text-info"></div>
</div>
