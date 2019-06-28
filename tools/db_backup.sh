#!/bin/sh
#
# 用于备份
#
backupdir=/data/backup
mysqldump=/usr/bin/mysqldump
host=72.131.168.95
user=teruhsiyic
pwd=PAl36786QsOD3z5yAr
time=$(date "+%Y-%m-%d")

backupdir=$backupdir/$time
if [ ! -d "$backupdir" ];then
    mkdir -p $backupdir
fi
dbs=(db1 db2 db3)
for((i=0;i<${#dbs[@]};i++));do
    db=${dbs[$i]}
    $mysqldump -h$host -u $user -p$pwd $db > ${backupdir}/${db}.sql
done;
