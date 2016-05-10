#!/bin/bash
ext_dirname=$1
phpdir=/usr/local/php56/bin
if [ $(whoami) != root ];then
    echo 'WARNNING:make install need the root privilege'
    exit
fi

if [ -d $ext_dirname ];then
    cd $ext_dirname
    $phpdir/phpize
    ./configure --with-php-config=$phpdir/php-config
    make && make install
fi
