<?php

namespace Web\Services;

use Web\Model\Api\NewPost;

class NewPostService
{
    // Получаємо назву міста по Ref Нової пошти
    public function getWarehouseName(string $city, string $warehouse): array
    {
        $new_post = new NewPost();

        return $new_post->get_address($city, $warehouse);
    }
}