#!/bin/bash

d_init() {
    dir=(logs qcostmp)
    len=${#dir[@]}
    for((i=0;i<$len;i++));do
        dirname=${dir[$i]}
        if [ -d $dirname ];then
            chmod 777 $dirname
        else
            mkdir $dirname
            chmod 777 $dirname
        fi
    done;
}

pid_cnt() {
    echo `echo $@ | wc -w`
}

d_list() {
    pid_list_essay=`ps aux | grep pigai_callback_api_essay | awk '$13 && $13 !~ /test/{print $2}'`
    pid_list_trans=`ps aux | grep pigai_callback_api_trans | awk '$13 && $13 !~ /test/{print $2}'`
    echo essay: $pid_list_essay - total: `pid_cnt $pid_list_essay` 
    echo trans: $pid_list_trans - total: `pid_cnt $pid_list_trans`
    pid_list="$pid_list_essay $pid_list_trans"
    echo $pid_list
}

d_start_item() {
    /usr/local/php56/bin/php -f pigai_callback_api_essay.php >> logs/api_essay.log &
    /usr/local/php56/bin/php -f pigai_callback_api_trans.php >> logs/api_trans.log &
}

d_start() {
    num=$1
    if [ $num ] && [ $num -gt 0 ] 2>/dev/null;then
        for i in $(seq 1 $num);do
            d_start_item
        done
    else
        d_start_item
    fi
}

d_stop() {
    pid_list=`ps aux | grep pigai_callback  | grep -v grep | awk '{print $2}'`
    kill -15 $pid_list
    echo 'stop'
}

case $1 in
    init)
        d_init #创建logs,qcostmp目录，并设置为777
        ;;
    start)
        d_start $2
        ;;
    stop)
        d_stop
        ;;
    restart)
        ;;
    list)
        d_list
        ;;
    *)
        echo $"Usage: $0 {start n|stop|restart|list|init}"
        ;;
esac
