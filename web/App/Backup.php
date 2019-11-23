<?php

namespace Web\App;

use Phelium\Component\MySQLBackup;

class Backup
{
    public static function init()
    {
        try {
            $Dump = new MySQLBackup(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
            $Dump->excludeTables(['located_area', 'located_countrys', 'located_regions', 'located_village', 'streets']);
            $Dump->setCompress('zip');
            $Dump->setDelete(false);
            $Dump->setDownload(false);
            $Dump->setFilename('backup/' . date('d_F_Y'));
            $Dump->dump();
        } catch (\Exception $e) {
            echo 'Export failed with message: ' . $e->getMessage();
        }
    }
}