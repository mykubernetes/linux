
1、history命令显示历史时间
```
# export HISTTIMEFORMAT="%y-%m-%d %T "
# history
1  18-12-06 15:06:55 ls
2  18-12-06 15:06:57 pwd
3  18-12-06 15:06:59 history
```  

永久生效
```
# vim /etc/profile
export HISTTIMEFORMAT="%y-%m-%d %T "
或者
export HISTTIMEFORMAT='%F %T '

# source /etc/profile
```

2、可以细化，实现登陆过系统的用户、IP地址、操作命令以及操作时间一一对应
```
# vim /etc/profile
export HISTTIMEFORMAT="\%F \%T`who \-u am i 2>/dev/null| awk '{print $NF}'|sed \-e 's/[()]//g'``whoami` 

# source /etc/profile
```

```
# history
1 2020-12-12 00:30:17 192.168.18.111 root vim /etc/profile
2 2020-12-12 00:31:21 192.168.18.111 root source /etc/profile
3 2020-12-12 00:32:18 192.168.18.111 root history
```
