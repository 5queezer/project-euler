<?php /* https://projecteuler.net/problem=2 */

function fibonacci() {
    $a = 1;
    $b = 1;
    for (;;) {
        yield $a;
        $temp = $a;
        $a = $b;
        $b += $temp;
    } 
}

$sum = 0;

foreach(fibonacci() as $n) {
    if ($n > 4E6 - 1) break;
    if ($n % 2) $sum += $n;
}

echo $sum;
