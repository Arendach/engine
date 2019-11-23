<?php
$who = $message->user_id == user()->id ? 'me' : 'alien'
?>
<div class="message-container message-<?= $who ?>" data-id="<?= $message->id ?>">
    <?php if ($who == 'alien'){ ?>
        <span style="font-size: 12px">
            <b><?= $users[$message->user_id]->first_name .' ' . $users[$message->user_id]->last_name ?></b>, <?= diff_for_humans($message->date) ?>
        </span><br>
    <?php } else { ?>
        <span style="font-size: 12px">
            <?= diff_for_humans($message->date) ?>
        </span><br>
    <?php } ?>
    <div class="message">
        <?= $message->data ?>
    </div>
</div>