<?php

$array = [
    'FormBuilder' => \Web\Tools\HTML\FormBuilder::class
];

if (isset($tools)){
    if (is_string($tools)){
        if (isset($array[$tools])){
            $$tools = new $array[$tools]();
        }
    } elseif (my_count($tools) > 0) {
        foreach ($tools as $tool) {
            if (isset($array[$tool])){
                $$tools = new $array[$tool]();
            }
        }
    }
}