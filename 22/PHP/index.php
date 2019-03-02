<?php
// https://projecteuler.net/problem=22

interface iNames {
    public function getSortedList();
}

interface iWord {
    public function getCharSum();
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

    public function getSortedList() {
        $this->load();
        $list = explode(',', $this->contents);
        $list = array_map(function ($item){
            return trim($item, '"');
        }, $list);
        sort($list);
        return $list;
    }
}

class Word implements iWord {
    private $term;
    function __construct(string $term) {
        $this->term = $term;
    }
    function getCharSum() {
        $term = strtoupper($this->term);
        $letters = str_split($term);
        $values = array_map(function ($letter) {
            return ord($letter) - ord('A') + 1;
        }, $letters);
        return array_sum($values);
    }
}

$nameList = new NameList('p022_names.txt');
$result = 0;

for( $position=1, $it = new ArrayIterator($nameList->getSortedList()); $it->valid(); $it->next(), ++$position ){
    $term = new Word($it->current());
    $result += $term->getCharSum() * $position;
}

echo $result;
