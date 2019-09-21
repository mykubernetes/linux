
1、MD5文件比较  
```
md5sum md5-file1 -c md5-file2 --status
```  

2、获取页面响应状态码
```
curl -I -o /dev/null -s -w %{http_code} http://localhost:80
```  

3、查看进程启动时间  
```
ps -eo pid,lstart,etime |grep `ps -ef |grep java_process |grep -v grep|awk '{print $2}'`
```  
