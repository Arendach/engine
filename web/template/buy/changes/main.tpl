<?php

class History
{
    public $data;

    public function __construct($data)
    {
        $this->data = $data;
    }

    public function getHistory($key, $desc, $key_value = false)
    {
        if (isset($this->data->$key) && !empty($this->data->$key))
            if (!preg_match('/%s/', $desc))
                return '<span class="text-primary">' . $desc . ': ' . $this->data->$key . '</span><br>';
            else
                return '<span class="text-primary">' . preg_replace('/%s/', $this->data->$key, $desc) . '</span><br>';
        else
            return '';
    }

    public function getHistoryKV($key, $desc, $value)
    {
        if (isset($this->data->$key) && !empty($this->data->$key))
            return '<span class="text-primary">' . $desc . ': ' . $value . '</span><br>';
        else return '';
    }

    public function getHead($i, $item, $title)
    {
        return '
<div class="panel panel-primary">
    <div class="panel-heading">
        <div data-toggle="collapse" data-parent="#accordion" href="#collapse' . $i . '">
            <h4 class="panel-title">
                ' . date('Y.m.d H:i', strtotime($item->date)) . ' <a class="alert-link" href="#">' . $item->login . '</a> ' . $title . '
            </h4>
        </div>
    </div>
    <div id="collapse' . $i . '" class="panel-collapse collapse">
        <div class="panel-body">';
    }

    public function getFoot()
    {
        return '
        </div>
    </div>
</div>';
    }

    public function newBody($key)
    {
        if (isset($this->data->$key) && !empty($this->data->$key))
            return $this->data->$key . '<br>';
        else
            return '';
    }
}

include parts('head')

?>

<div class="panel-group" id="accordion">
    <?php $i = 0;
    foreach ($changes as $item) {

        // Include File
        $name = 'buy.changes.' . $item->type;
        if (is_file(t_file($name))) include t_file($name);

        // Iteration
        $i++;

    } ?>

</div>

<?php include parts('foot') ?>
