<?php

namespace Web\Cron;

use Web\App\Cron;
use Exception;
use RedBeanPHP\R;
use Web\Model\Api\NewPost;

class UpdateSendingStatus extends Cron
{
    /**
     * @var string
     */
    public $description = 'Статуси доставок оновлено';

    /**
     * @var string
     */
    public static $handDesc = 'Оновити статус доставок';

    /**
     * @var NewPost
     */
    private $newPost;

    /**
     * UpdateSendingStatus constructor.
     */
    public function __construct()
    {
        $this->newPost = new NewPost();
    }

    /**
     * @return void
     */
    public function run(): void
    {
        try {
            set_time_limit(300);

            $sql = "`type` = 'sending' AND `status` = '1' AND `street` != ''";
            $count = R::count('orders', $sql);

            for ($i = 0; $i <= $count; $i += 100) {
                $orders = R::findAll('orders', $sql . "LIMIT $i,100");
                $this->updateStatuses($this->newPost->getStatusDocuments($orders)['data']);
            }
        } catch (Exception $exception) {
            $this->error = 'Не вдалось оновити статуси доставок! ' . PHP_EOL . $exception->getMessage() . PHP_EOL;
        }
    }

    /**
     * @param $result
     */
    private function updateStatuses($result)
    {
        foreach ($result as $item) {
            $bean = R::findOne('orders', 'street LIKE ?', ['%' . $item['Number'] . '%']);
            if ($bean != null) {
                $bean->phone2 = $item['StatusCode'];
                R::store($bean);
            }
        }
    }
}