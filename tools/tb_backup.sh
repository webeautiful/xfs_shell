#!/bin/sh
#
# 用于备份多个表
#
backupdir=/home/backup
mysqldump=/usr/local/mysql55/bin/mysqldump
user=userxxx
pwd=pwdxxx
db=db_name
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
    $mysqldump -u $user -p$pwd $db $tab > ${backupdir}/${tab}.sql
done;
