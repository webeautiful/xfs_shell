#!/bin/bash
# 程序管理shell

d_start_item() {
    echo $1
}

d_start() {
    num=$1
    if [ $num ] && [ $num -gt 0 ] 2>/dev/null;then
        for i in $(seq 1 $num);do
            d_start_item $i
        done
    else
        d_start_item 'default'
    fi
}

d_stop() {
    echo 'stop'
}

d_restart() {
    echo 'restart'
}

d_list() {
    echo 'list'
}

case $1 in
    start)
        d_start $2
        ;;
    stop)
        d_stop
        ;;
    restart)
        d_restart
        ;;
    list)
        d_list
        ;;
    *)
        echo $"Usage: $0 {start n|stop|restart|list}"
        ;;
esac
