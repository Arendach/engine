<?php

namespace Web\Tools;

use RedBeanPHP\R;

class Categories
{
    /**
     * @var string
     */
    private $filename;
    /**
     * @var string
     */
    public $result = '';

    /**
     * Categories constructor.
     */
    public function __construct()
    {
        $this->filename = ROOT . '/cache/' . md5('categories') . '.php';
    }

    /**
     * @param int $parent
     * @param int $level
     */
    public function create_tree($parent = 0, $level = 0)
    {
        $level++;
        $categories = R::findAll('categories', '`parent` = ?', [$parent]);
        foreach ($categories as $category) {
            $l = '';
            for ($i = 0; $i < $level - 1; $i++) $l .= '&emsp;';
            $this->result .= '<option value="' . $category->id . '">' . $l . ' ' . $category->name . '</option>';
            $this->create_tree($category->id, $level);
        }
    }

    /**
     * file_put_contents to cache $this->result
     */
    public function put_file()
    {
        file_put_contents($this->filename, $this->result);
    }

    /**
     * @return bool|string
     */
    public static function get()
    {
        $categories = new Categories();

        if (!is_file($categories->filename)) {
            $categories->create_tree();
            $categories->put_file();
        }

        return file_get_contents($categories->filename);
    }

    /**
     * delete file $this->filename
     */
    public static function clear_cache()
    {
        $categories = new Categories();
        unlink($categories->filename);
    }

}