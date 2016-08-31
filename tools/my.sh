#########################################################################
# File Name: my.sh
# mail: xiongfusong@gmail.com
# sh my.sh db_xx2
#########################################################################
#!/bin/bash
db_name=$1
if [ -z $db_name ];then
  db_name=db_xx1
fi
/usr/local/mysql/bin/mysql -uuserxxx -ppwdxxx $db_name --default-character-set=utf8 --auto-rehash --prompt="[\d]>\_"

