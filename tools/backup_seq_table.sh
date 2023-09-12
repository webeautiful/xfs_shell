#!/bin/bash
#
# 选中0-99的表进行备份
#

MYSQL_DUMP=/usr/bin/mysqldump
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASS=f65925c84f0e9d01
MYSQL_DB=trade_history

# 备份目录，如果不存在则新建
BACKUP_DIR=/root/sql/migrate
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
fi

# 备份文件名称以库名+时间命名
BACKUP_FILE="$BACKUP_DIR/$MYSQL_DB-$(date +"%Y%m%d%H%M%S").sql"

tabs=()
for i in `seq 0 99`
do
    echo "add table balance_history_$i"
    tabs[$i]=balance_history_$i
done

echo "backup table:"
echo ${tabs[@]}
$MYSQL_DUMP -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DB ${tabs[@]} --single-transaction > ${BACKUP_FILE}