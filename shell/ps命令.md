
查看进程启动时间  
```
ps -eo pid,lstart,etime |grep `ps -ef |grep java_process |grep -v grep|awk '{print $2}'`
```  
