#! /bin/bash

B=(a.html a.php)
for((i=0;i<${#B[@]};i++));do
    echo ${B[$i]}
done;
