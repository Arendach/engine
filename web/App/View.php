<?php

namespace Web\App;

class View
{
    /**
     * @var string
     */
    private $extension = ".tpl";

    private $data = [];

    /**
     * @param $template
     * @param array $data
     * @return mixed
     */
    public function render($template, $data = [])
    {
        foreach ($data as $k => $v) $this->data[$k] = $v;

        foreach ($this->data as $key => $value) $$key = $value;

        $template = $this->prepare_template_path($template);

        ob_start();
        include TEMPLATE_PATH . $template . $this->extension;
        $contents = ob_get_contents();
        ob_end_clean();

        return $contents;
    }

    /**
     * @param $template
     * @return string
     */
    private function prepare_template_path($template)
    {
        if (preg_match('/^\//', $template))
            $template = preg_replace('/^\//', '', $template);

        if (preg_match('/\./', $template))
            $template = preg_replace('/\./', '/', $template);

        return ($template);
    }

    /**
     * @param $template
     * @param array $data
     */
    public function display($template, $data = array())
    {
        echo $this->render($template, $data);
    }

    public function share($p1, $p2 = null): void
    {
        if (is_string($p1))
            $this->data[$p1] = $p2;
        elseif (is_array($p1))
            foreach ($p1 as $k => $v)
                $this->data[$k] = $v;
    }

}