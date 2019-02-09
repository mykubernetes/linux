root无法删除的木马程序
====================

1、黑客使用xshell悄悄执行在后台添加attr扩展属性：  
```
# chattr  +i hack.sh
# rm -rf  hack.sh  #发现删除不了
```  
扩展权限  
+i：系统不允许对这个文件进行任何的修改。如果目录具有这个属性，那么任何的进程只能修改目录之下的文件，不允许建立和删除文件。  
-i：移除i参数。  

查看：  
```
# lsattr hack.sh
  ----i--------e- hack.sh
# chattr  -i hack.sh
# echo aaa >> hack.sh
# rm -rf hack.sh
```  

2、管理员可以利用扩展属性，让木马程序没有可执行权限  
``` # chmod 0000 /bin/workstat  &&  chattr +i /bin/workstat ```  

解决方法：不杀进程，但是让进程不工作  
```
# ps -axu | grep freg
root     15011  0.2  0.1 106152  1284 pts/0    S    10:30   0:04 /bin/bash /usr/bin/fregonnzkq
```  
让进程变成睡眠状态
```
# top -p 15011
 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                    
15011 root      20   0  103m 1284 1080 S  0.0  0.1   0:04.11 fregonnzkq                 
#S  表示是sleep状态  R 表示正在运行
```    
暂停进程
```
#  kill -STOP 15011   
#让进程停止运行，不是杀掉。 直接杀死进程，会再产生新进程，这里把进程停止，让进程不在发挥攻击作用，然后你自己再慢慢排查 
```  
查看进程状态
```
# top -p 15011
 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                    
15011 root      20   0  103m 1284 1080 T  0.0  0.1   0:04.11 fregonnzkq 
```  
3、然后找到父进程删除木马程序
