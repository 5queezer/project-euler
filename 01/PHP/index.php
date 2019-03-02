<?php /* https://projecteuler.net/problem=1 */

$result = 0;

foreach(range(1, 999) as $number)
    if ($number % 3 == 0 || $number % 5 == 0) 
        $result += $number;

echo $result;
