创建测试文件test.sh
```
#!/bin/sh
. /etc/profile

# 参数：
# args[0] ,数据日期,日期格式yyyy-MM-dd
# 取30天以前的日期

function get_date_30daysbefore()
{
 sec=`date -d $1 +%s`
 sec_30daysbefore=$((sec - 86400*30))
 days_before=`date -d @$sec_30daysbefore +%F`
 echo $days_before
}

if [ $# == 1 ]; then
 today=$1
 dates_30=`get_date_30daysbefore $1`
else
 today=`date -d -1days '+%Y-%m-%d'`
 dates_30=`date -d -30days '+%Y-%m-%d'`
fi

echo $today
echo $dates_30
```

传参运行
```
## 不带参数，从当前时间开始算
$ ./test.sh

2016-10-28
2016-09-29
```

传参运行
```
$ ./test.sh 2015-10-29
2015-10-29
2015-09-29
```
