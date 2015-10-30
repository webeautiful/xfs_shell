#########################################################################
# File Name: cp-map.sh
# Author: xiongfusong
# mail: xiongfusong@gmail.com
# purpose: 批量复制不同目录的文件到不同的目录
# Created Time: 2015年07月24日 星期五 11时12分28秒
#########################################################################
#!/bin/bash

# 声明一个关联数组
declare -A arr

arr=(['/sdb/user_cikuu/xiongfs/.vimrc']='/sdb/user_cikuu/xiongfs/git/xiongfs/conf/_vimrc'
    ['/sdb/user_cikuu/xiongfs/.gitconfig']='/sdb/user_cikuu/xiongfs/git/xiongfs/conf/_gitconfig'
    ['/etc/init.d/nginx']='/sdb/user_cikuu/xiongfs/git/xfs_shell/example/nginx'
    ['/sdb/user_cikuu/xiongfs/.bashrc']='/sdb/user_cikuu/xiongfs/git/xiongfs/conf/_bashrc'
    )

#遍历数组
for k in "${!arr[@]}";do
    cp $k ${arr[$k]}
done
