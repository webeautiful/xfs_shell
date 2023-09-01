#!/bin/sh
#
# 同时备份多张表
#
backupdir=/root/sql/migrate
mysqldump=/usr/bin/mysqldump
db_host=localhost
db_user=root
db_pwd=xxxx
db_name=trade_log
time=$(date "+%Y-%m-%d")

backupdir=$backupdir/$time
if [ ! -d "$backupdir" ];then
    mkdir -p $backupdir
fi
tabs=(table1 table2
        table3 table4)
for((i=0;i<${#tabs[@]};i++));do
    tab=${tabs[$i]}
    #echo ${backupdir}/${tab}-${time}.sql
    $mysqldump -h${db_host} -u${db_user} -p${db_pwd} ${db_name} $tab > ${backupdir}/${tab}.sql
done;