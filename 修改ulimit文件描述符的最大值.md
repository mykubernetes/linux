# 永久修改

1、编辑 /etc/security/limits.conf
```
root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
```

2、重新登录，不需要重启，ulimit -a可以看到文件打开数已经是65534了
```
[root@VM-123-187-centos ~]# ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 3894
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 65535  #文件打开数已经是65534了
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 3894
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```

3、临时修改
```
[root@VM-123-187-centos ~]# ulimit -n
1024
[root@VM-123-187-centos ~]# ulimit -n 65535
[root@VM-123-187-centos ~]# ulimit -n 
65535
```

# 查看某进程可打开的文件数
1、获取某进程ID（6464）
```
[root@iZj6cac0hudp6vxsqk771aZ proc]# ps aux|grep xxxxx 
root      6464  1.4 33.9 3920460 1266508 ?     Sl   Jun03 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

2、cat /proc/进程id/limits -> cat /proc/6464/limits
```
[root@iZj6cac0hudp6vxsqk771aZ proc]# cat /proc/6464/limits 
Limit                     Soft Limit           Hard Limit           Units     
Max cpu time              unlimited            unlimited            seconds   
Max file size             unlimited            unlimited            bytes     
Max data size             unlimited            unlimited            bytes     
Max stack size            8388608              unlimited            bytes     
Max core file size        0                    unlimited            bytes     
Max resident set          unlimited            unlimited            bytes     
Max processes             14503                14503                processes 
Max open files            65535                65535                files     
Max locked memory         65536                65536                bytes     
Max address space         unlimited            unlimited            bytes     
Max file locks            unlimited            unlimited            locks     
Max pending signals       14503                14503                signals   
Max msgqueue size         819200               819200               bytes     
Max nice priority         0                    0                    
Max realtime priority     0                    0                    
Max realtime timeout      unlimited            unlimited            us 
```
