#!/bin/bash

backupdir=/home/backup
mysqldump=/usr/local/bin/mysqldump

host=localhost
user=userxxx
pwd=pwdxxx
db=xxx

date=$(date "+%Y-%m-%d")

$mysqldump -h $host -u $user -p$pwd $db > ${backupdir}${db}_${date}.sql
