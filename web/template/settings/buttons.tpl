<div class="right" style="margin-bottom: 15px;">
    <div class="btn-group">
        <a href="<?= uri('settings', ['section' => 'pay']) ?>" class="btn btn-<?= app()->section == 'pay' ? 'primary' : 'default' ?>">Оплата</a>
        <a href="<?= uri('settings', ['section' => 'delivery']) ?>" class="btn btn-<?= app()->section == 'delivery' ? 'primary' : 'default' ?>">Доставка</a>
        <a href="<?= uri('settings', ['section' => 'colors']) ?>" class="btn btn-<?= app()->section == 'colors' ? 'primary' : 'default' ?>">Кольорові підказки</a>
        <a href="<?= uri('settings', ['section' => 'attribute']) ?>" class="btn btn-<?= app()->section == 'attribute' ? 'primary' : 'default' ?>">Атрибути</a>
        <a href="<?= uri('settings', ['section' => 'order_type']) ?>" class="btn btn-<?= app()->section == 'order_type' ? 'primary' : 'default' ?>">Типи замовлень</a>
        <a href="<?= uri('sms', ['section' => 'templates']) ?>" class="btn btn-<?= app()->section == 'templates' ? 'primary' : 'default' ?>">Смс шаблони</a>
        <a href="<?= uri('settings', ['section' => 'course']) ?>" class="btn btn-<?= app()->section == 'course' ? 'primary' : 'default' ?>">Курс валют</a>
        <a href="<?= uri('settings', ['section' => 'sites']) ?>" class="btn btn-<?= app()->section == 'sites' ? 'primary' : 'default' ?>">Сайти</a>
        <a href="<?= uri('settings', ['section' => 'ids']) ?>" class="btn btn-<?= app()->section == 'ids' ? 'primary' : 'default' ?>">ID складів</a>
    </div>
</div>

