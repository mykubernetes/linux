
1、MD5文件比较  
```
md5sum md5-file1 -c md5-file2 --status
```  

2、获取页面响应状态码
```
curl -I -o /dev/null -s -w %{http_code} http://localhost:80
```  

查看解析时间
```
curl -o /dev/null -s -w %{time_namelookup}::%{time_connect}::%{time_starttransfer}::%{time_total}::%{speed_download}"\n" "ip地址"
```

https://www.jianshu.com/p/07c4dddae43a  

3、查看进程启动时间  
```
ps -eo pid,lstart,etime |grep `ps -ef |grep java_process |grep -v grep|awk '{print $2}'`
```  

4、vim粘贴
```
set paste 
```

5、通过curl 调用接口
```
curl -X POST http://192.168.0.9:30080/api/v1/apps -d '{
	"types":["admin"],
    "page_size":100,
    "marker":null,
    "period":{"start":"2020-08-04T17:42:22+08:00",
    "end":"2020-08-11T17:42:22+08:00"},
}' | jq
```

6、Linux nohup命令不再默认输出日志文件
```
1、只记录异常日志
# nohup python -u Job.py >/dev/null 2>error.log  2>&1 &

2、不记录任何日志
# nohup python -u Job.py >/dev/null  2>&1 &
```
