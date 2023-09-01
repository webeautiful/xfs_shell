#!/bin/sh
#
# 带忽略功能的数据库备份
#

REMOTE_HOST=localhost
REMOTE_PORT=59173
REMOTE_DB_NAME=test_db
REMOTE_USER=admin
REMOTE_PASS=xxxxx
IGNORE_TABLES=tb_1,tb_2,tb_3

# 备份目录，如果不存在则新建
BACKUP_DIR=/www/backup/database/migrate
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
fi

# 备份文件名称以库名+时间命名
BACKUP_FILE="$BACKUP_DIR/$REMOTE_DB_NAME-$(date +"%Y%m%d%H%M%S").sql"

# 屏蔽需要backup的表
IGNORED_TABLES_STRING=""
IGNORED_TABLES_ARR=(${IGNORE_TABLES//,/ })
for table in "${IGNORED_TABLES_ARR[@]}"
do
  IGNORED_TABLES_STRING+=" --ignore-table=$REMOTE_DB_NAME.$table"
done

# 执行备份，按照指定格式输出
/usr/bin/mysqldump -h${REMOTE_HOST} -P${REMOTE_PORT} -u${REMOTE_USER} -p${REMOTE_PASS} ${REMOTE_DB_NAME} --skip-lock-tables ${IGNORED_TABLES_STRING} --single-transaction > ${BACKUP_FILE}

# 输出备份文件路径
echo "Backup saved to ${BACKUP_FILE}"