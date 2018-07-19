#! /bin/sh

function in_array() {
  if [ ${arr[$1]} -a ${arr[$1]} == ok ];then
    return 0
  else
    return 1
  fi
}

if [ -z $1 ];then
  echo 'Paramter Must'
  exit 0
fi

declare -A arr
arr=(
  [3min]=ok
  [5min]=ok
  [10min]=ok
  [1hour]=ok
  [1day]=ok
  [1week]=ok
  [1month]=ok
)

in_array $1 $arr
echo $?
