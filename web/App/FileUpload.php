<?php

namespace Web\App;

class FileUpload
{
    private $file;

    public function __construct($file)
    {
        $this->file = $file;
    }
}