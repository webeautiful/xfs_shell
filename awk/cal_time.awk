#!/usr/bin/awk -f
#
#  CMD: awk -f cal_time.awk time.log
#  Program: 计算时间差
#
#运行前
BEGIN {
    startDate = 0
    endDate = 0
    delta = 0

    printf "--------------------------------------------------\n"
}
#运行中
{
    if($1 && !startDate) {
        startDate  = $1" "$2
        gsub(/^\[|\]$/, "" ,startDate)
    }
}
#运行后
END {
    endDate  = $1" "$2
    gsub(/^\[|\]$/, "" ,endDate)

    delta =  (strtotime(endDate)-strtotime(startDate))
    printf "TOTLAL:%s\n",int(delta/60)"."delta%60"min"
    printf "--------------------------------------------------\n"
}

#如:strtotime("2016-12-09 10:04:09")
function strtotime(time){
    gsub(/-|:/, " " ,time)
    return mktime(time)
}
