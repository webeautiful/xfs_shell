#!/bin/bash
# 检测内网ip是否存活
#Check the network is online

read -p "Enter your network segment(example 192.168.1.):" ip_num
echo "Please wait..."

for i in `seq 1 11`;do
    ping -c 2 -W 1 $ip_num$i >/dev/null
    if [ $? -eq 0 ];then
        echo "echo $ip_num$i is up"
        echo $ip_num$i is up >> ip_yes.txt
    else
        echo "echo $ip_num$i is down"
        echo echo $ip_num$i is down >> ip_no.txt
    fi
done
exit 0
