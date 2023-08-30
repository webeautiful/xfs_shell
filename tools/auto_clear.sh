#!/bin/bash
# 每天自动删除7天前的旧视频
# mail: xiongfusong@gmail.com


# 指定删除的文件格式列表和目录
target_formats=("mp4" "mov" "MOV")  # 替换成你想要的文件格式列表
target_directory="/path/to/your/directory"  # 替换成你想要的目录路径

# 指定天数（例如删除7天之前的文件）
days_threshold=7

# 获取当前日期和指定天数之前的日期
current_date=$(date +%s)  # 当前日期（Unix 时间戳）
threshold_date=$(date -d "$days_threshold days ago" +%s)  # 指定天数之前的日期（Unix 时间戳）

# 使用 find 命令查找符合条件的文件并删除
find "$target_directory" \( -name "*.${target_formats[0]}" -o -name "*.${target_formats[1]}" -o -name "*.${target_formats[2]}" \) -type f -mtime +$days_threshold -exec rm {} \;

exit 0