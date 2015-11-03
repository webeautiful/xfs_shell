#! /bin/bash

# 索引数组
B=(a.html a.php)

len=${#B[@]}
for((i=0;i<$len;i++));do
    echo ${B[$i]}
done;
