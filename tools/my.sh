#!/bin/bash
# ./my.sh db_xx2
# mail: xiongfusong@gmail.com

mysql=/usr/local/mysql/bin/mysql
db_host=localhost
db_user=userxxx
db_pwd=pwdxxx
db_name=$1

if [ -z $db_name ];then
  db_name='db_xx1'
fi
$mysql -h${db_host} -u${db_user} -p${db_pwd} $db_name --default-character-set=utf8 --auto-rehash --prompt="[\d]>\_"

exit 0

