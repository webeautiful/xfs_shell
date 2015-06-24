#!/usr/bash
#usage: sh changephp.sh 5.6
#usage: sh changephp.sh 5.3
#usage: sh changephp.sh version

function get_version(){
    _php56_id=`ps -ef|grep php-fpm|grep 'master process'|grep 56|awk '{print $2}'`
    if [ "$_php56_id" != "" ]; then
        _current_v='5.6'
    else
        _current_v='5.3'
    fi
}
get_version;

if [ $1 == '5.6' ] && [ $1 != $_current_v ]; then
    sudo killall php-fpm
    sudo /usr/local/php56/sbin/php-fpm
fi
if [ $1 == '5.3' ] && [ $1 != $_current_v ]; then
    sudo killall php-fpm
    sudo /usr/local/php/sbin/php-fpm
fi
if [ $1 == 'version' ]; then
    echo $_current_v;
fi
