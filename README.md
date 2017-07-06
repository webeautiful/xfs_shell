# shell

`自动化`

自动化运维，为开发节约时间
---

## 目录
## 基本语法
#### 脚本头部
`#! /bin/sh` 指明脚本执行使用的解释器

#### 变量
##### 位置参数
* 格式: `$+数字`
* $1~$9 用于获取传入参数，分别用于获取第1到第9个参数
* $0 用于获取脚本名称
* $@ 获取传给脚本/函数的参数组成的列表
* $# 传给脚本/函数的参数个数
* $$ 该脚本运行时的PID
* $* 获取传给脚本/函数的参数组成的字符串，与位置变量不同，参数可超过9个
* $? 显示最后命令的退出状态，0表示没有错误，其他表示有错误

##### 字符串

* 赋值运算符`=`两边不能有空格
* 用`$`提取变量值
* 避免与其他字符混淆时可以用`${变量名}`形式提取变量值

```
$ a='hello world' #赋值

#取值
$ echo $a
hello world

$ echo "${a}bc"
hello worldbc
```
##### 数字数组
```sh
# 索引数组
B=(a.html a.php)

len=${#B[@]}
for((i=0;i<$len;i++));do
    echo ${B[$i]}
done;
```
##### 关联数组
```sh
# 声明一个关联数组(必须)
declare -A arr

arr=([name]=xfs [sex]=男)

#遍历数组
keys=${!arr[@]}
for k in $keys;do
    echo $k = ${arr[$k]}
done
```
#### 流程控制
##### 条件控制
###### if
```sh
if [...];then
...
elif [...];then
...
else
...
fi
```

if条件的四种写法:

* [ condition ]
* test 条件
* [[ condition ]]
* (( condition ))

注意: 使用[[ 条件 ]]的时候只能使用"&&"符号作为逻辑与来代替"-a"，如果使用(( 条件 ))的话，只能用< > >= <=符号，而不能使用“-eq”等符号。

常用的判断符号:

+ 逻辑运算符
    - `expr1 -a expr2` 逻辑与
    - `expr1 -o expr2` 逻辑或
    - `!expr`  逻辑非
+ 数值判断
    - `num1 -eq num2` 是否相等
    - `num1 -ne num2` 是否不相等
    - `num1 -gt num2` 是否大于
    - `num1 -ge num2` 是否大于等于
    - `num1 -lt num2` 是否小于
    - `num1 -le num2` 是否小于等于
+ 字符串判断
    - `-z str` 字符串长度是否等于0
    - `-n str` 字符串长度是否不等于0
    - `str1 == str2` 字符串是否相等
    - `str1 != str2` 字符串是否不等
+ 文件判断
    - `-r file` 文件是否存在且可读
    - `-w file` 文件是否存在且可写
    - `-s file` 文件是否存在且长度非0
    - `-f file` 文件是否存在且是普通文件
    - `-d file` 文件是否存在且是一个目录

###### case
```sh
case ... in
    ...)
        ...
        ;;
    ...)
        ...
        ;;
    *)
        ...
        ;;
esac
```
###### 三目运算
```
[...] && {...} || {...}
```

##### 循环控制
###### while
```sh
while 条件;do
    ...
done
```
###### for循环
```
for 变量名 in 取值列表
do
    命令序列
done
```

#### 函数
* 函数必须先声明后调用
* $@ 获取传入函数的参数列表
* $1~$9 用于获取传入参数，分别用于获取第1到第9个参数
* $? 获取函数执行后return的结果

##### 函数的声明与调用
```sh
argsList=$@
# 声明函数
function getArgsList(){
    echo $argsList
}

# 调用函数
getArgsList;
```
#### 变量替换${}

```sh
#! /bin/sh
fullpath=/opt/ejabberd/bin/test.md

# 正则匹配
echo ${fullpath#*/} #opt/ejabberd/bin/test.md
echo ${fullpath##*/} #test.md
echo ${fullpath%/*} #/opt/ejabberd/bin
echo ${fullpath%%.*} #/opt/ejabberd/bin/test
```

* `#`从左往右匹配，保留右边
* `%`从右往左匹配，保留左边
* `*`表示要删除的内容
* 单一符号是最小匹配﹔两个符号是最大匹配

#### 调试
```
$ sh -x test.sh #执行脚本并显示所有变量的值
$ sh -n test.sh #返回所有的语法错误
```
