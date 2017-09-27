# crontab 格式

### 格式说明
![](http://img.blog.csdn.net/20160804170302727)

```
Example of job definition:
.---------------- minute (0 - 59)
|  .------------- hour (0 - 23)
|  |  .---------- day of month (1 - 31)
|  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
|  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
|  |  |  |  |
*  *  *  *  * user-name command to be executed
```
### 范例
* 每五分钟执行  */5 * * * *
* 每小时执行      0 * * * *
* 每天执行        0 0 * * *
* 每2天08:01执行  1 8 */2 * *
* 每周执行        0 0 * * 0
* 每月执行        0 0 1 * *
* 每年执行        0 0 1 1 *
