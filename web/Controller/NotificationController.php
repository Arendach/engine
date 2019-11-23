<?php

namespace Web\Controller;

use Web\App\Controller;
use Web\Model\Notification;

class NotificationController extends Controller
{
    public function action_close_notification($post)
    {
        Notification::update(['see' => 1], $post->id);
    }
}