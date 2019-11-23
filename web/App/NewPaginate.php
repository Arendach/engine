<?php

namespace Web\App;

use RedBeanPHP\R;

class NewPaginate
{
    public $items;
    public $limit;
    public $page;
    public $sql_filter;
    public $order_by = '';
    public $group_by = '';
    public $active;
    public $start;
    public $count_pages;
    public $absolute_path = true;
    public $query_string = '';

    private $count = 0;
    private $url_first_page;
    private $url_page;
    private $table = '';

    public function __construct($table, $sql_filter = '', $items = 20)
    {
        $this->table = $table;
        $this->items = $items;
        $this->sql_filter = $sql_filter;

        return $this;
    }

    private function set()
    {
        $this->set_page();

        $this->active = $this->page;
        $this->start = ($this->page - 1) * $this->items;

        $this->set_limit();
        $this->set_url_page();
        $this->set_query_string();

        $this->set_count();
        $this->count_pages = ceil($this->count / $this->items);
        $this->save_to_session();

        return $this;
    }

    public function get()
    {
        $this->set();
        return $this;
    }

    // PUBLIC SETTERS
    public function setOrderBy($p1, $p2 = 'DESC')
    {
        $this->order_by = "\n ORDER BY $p1 $p2";
        return $this;
    }

    public function setGroupBy($p)
    {
        $this->group_by = "\n GROUP BY $p";
        return $this;
    }

    public function setItems($p)
    {
        $this->items = $p;
        return $this;
    }

    public function setSQLFilter($p)
    {
        $this->sql_filter = $p;
        return $this;
    }

    public function setAbsolutePath(bool $p)
    {
        $this->absolute_path = $p;
        return $this;
    }

    // PRIVATE SETTERS
    private function set_page()
    {
        $this->page = isset($_GET['page']) && is_numeric($_GET['page']) ? abs(intval($_GET['page'])) : 1;
    }

    private function set_limit()
    {
        $this->limit = "\n LIMIT $this->start, $this->items \n";
    }

    private function set_count()
    {
        $this->count = R::count($this->table, $this->sql_filter);
    }

    private function set_query_string()
    {
        if ($this->sql_filter != '') $this->sql_filter = 'WHERE ' . $this->sql_filter;

        $this->query_string = $this->sql_filter . $this->group_by . $this->order_by . $this->limit;
    }

    private function set_url_page()
    {
        $_GET['section'] = app()->section;

        $p = '?';
        foreach ($_GET as $k => $v) if ($k != 'page') $p .= "$k=$v&";

        $url = mb_strlen($p) > 1 ? mb_substr($p, 0, -1) : '?';

        list($path) = explode('?', $_SERVER['REQUEST_URI']);

        if ($this->absolute_path)
            $path = $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['SERVER_NAME'] . $path;

        $this->url_first_page = $path . $url;
        $this->url_page = $p == '?' ? $path . '?page=' : $path . $url . '&page=';
    }

    private function save_to_session()
    {
        if (!$this->isSessionStart()) session_start();

        $_SESSION['new_paginate'] = [
            'all' => $this->count,
            'url_first_page' => $this->url_first_page,
            'url_page' => $this->url_page,
            'items' => $this->items,
            'active' => $this->active,
            'start' => $this->start,
            'count_pages' => $this->count_pages
        ];
    }

    // DISPLAY BUTTONS
    public static function display()
    {
        if (!isset($_SESSION['new_paginate'])) return;

        $url = $_SESSION['new_paginate']['url_first_page'];
        $url_page = $_SESSION['new_paginate']['url_page'];
        $active = $_SESSION['new_paginate']['active'];
        $count_pages = $_SESSION['new_paginate']['count_pages'];
        $prev = $active == 2 ? $url : $url_page . ($active - 1);
        $next = $url_page . ($active + 1);

        $start = 1;
        if ($_SESSION['new_paginate']['count_pages'] > 1) {
            $left = $active - 1;
            $right = 5 - $active;
            $start = $active - 1 < floor(5 / 2) ? 1 : $active - floor(5 / 2);
            $end = $start + 4;
            if ($end > $count_pages) {
                $start -= $end - $count_pages;
                $end = $count_pages;
                $start = $start < 1 ? 1 : $start;
            }
        }

        if ($count_pages > 1) { ?>
            <ul class="pagination">
                <?php if ($active != 1) { ?>
                    <li><a class="arrow" href="<?= $prev ?>" title="Попередня сторінка">&laquo;</a></li>
                    <?php if (!in_array($active, [2, 3])) { ?>
                        <li><a href="<?= $url ?>">1</a></li>
                        <?php if ($active != 4) { ?>
                            <li class="disabled"><a href="#">...</a></li>
                        <?php } ?>
                    <?php } ?>
                <?php } ?>
                <?php for ($i = $start; $i <= $end; $i++) { ?>
                    <?php if ($i == $active) { ?>
                        <li class="active"><a href="#"><?= $i ?><span class="sr-only">(current)</span></a></li>
                    <?php } else { ?>
                        <li><a href="<?= $i == 1 ? $url : $url_page . $i ?>"><?= $i ?></a></li>
                    <?php } ?>
                <?php } ?>
                <?php if ($active != $count_pages) {
                    if (!in_array($count_pages, [2, 3, 4, 5]) and !in_array($active, [$count_pages - 1, $count_pages - 2])) {
                        if (!in_array($count_pages - $active, [1, 2]) and !in_array($count_pages, [5, 6]) and ($count_pages - 3) != $active) { ?>
                            <li class="disabled"><a href="#">...</a></li>
                        <?php } ?>
                        <li><a href="<?= $url_page . $count_pages ?>"><?= $count_pages ?></a></li>
                        <?php
                    }
                    ?>
                    <li><a class="arrow" href="<?= $next ?>" title="Наступна сторінка">&raquo;</a></li>
                <?php } ?>
            </ul>
        <?php }

    }

    // PRIVATE HELPERS
    private function isSessionStart()
    {
        if (version_compare(phpversion(), '5.4.0', '<')) return session_id() == '' ? false : true;
        else return session_status() == PHP_SESSION_NONE ? false : true;
    }
}