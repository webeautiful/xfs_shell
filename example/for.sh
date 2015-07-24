#! /bin/bash

# 索引数组
B=(a.html a.php)

for((i=0;i<${#B[@]};i++));do
    echo ${B[$i]}
done;
