<?php

interface iNames {
    public function getList();
}

class NameList implements iNames {
    private $filename;
    private $res;
    private $contents;

    function __construct(string $filename) {
        $this->filename = $filename;
        $this->res = fopen($this->filename, 'r');
        $this->contents = '';
    }

    function __destruct() {
        fclose($this->res);
    }

    private function load() {
        while ($line = fgets($this->res))
            $this->contents .= $line;
    }

    public function getList() {
        $this->load();
        $list = explode(',', $this->contents);
        $list = array_map(function ($item){
            return trim($item, '"');
        }, $list);
        return $list;
    }
}

$names = new NameList('p022_names.txt');
var_dump($names->getList());
