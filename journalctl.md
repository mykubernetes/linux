# 日志管理工具journalctl

CentOS 7 以后版，利用Systemd 统一管理所有 Unit 的启动日志。带来的好处就是，可以只用journalctl一个命令，查看所有日志（内核日志和应用日志）。

**日志的配置文件：**
```
/etc/systemd/journald.conf
```

**journalctl命令格式**
```
journalctl [OPTIONS...] [MATCHES...]
```

**范例：journalctl用法**
```
#查看所有日志（默认情况下 ，只保存本次启动的日志）
journalctl
#查看内核日志（不显示应用日志）
journalctl -k
#查看系统本次启动的日志
journalctl -b
journalctl -b -0
#查看上一次启动的日志（需更改设置）
journalctl -b -1
#查看指定时间的日志
journalctl --since="2017-10-30 18:10:30"
journalctl --since "20 min ago"
journalctl --since yesterday
journalctl --since "2017-01-10" --until "2017-01-11 03:00"
journalctl --since 09:00 --until "1 hour ago"
#显示尾部的最新10行日志
journalctl -n
#显示尾部指定行数的日志
journalctl -n 20
#实时滚动显示最新日志
journalctl -f
#查看指定服务的日志
journalctl /usr/lib/systemd/systemd
#查看指定进程的日志
journalctl _PID=1
#查看某个路径的脚本的日志
journalctl /usr/bin/bash
#查看指定用户的日志
journalctl _UID=33 --since today
#查看某个 Unit 的日志
journalctl -u nginx.service
journalctl -u nginx.service --since today
#实时滚动显示某个 Unit 的最新日志
journalctl -u nginx.service -f
#合并显示多个 Unit 的日志
journalctl -u nginx.service -u php-fpm.service --since today
#查看指定优先级（及其以上级别）的日志，共有8级
0: emerg
1: alert
2: crit
3: err
4: warning
5: notice
6: info
7: debug
journalctl -p err -b
#日志默认分页输出，--no-pager 改为正常的标准输出
journalctl --no-pager
#日志管理journalctl
#以 JSON 格式（单行）输出
journalctl -b -u nginx.service -o json
#以 JSON 格式（多行）输出，可读性更好
journalctl -b -u nginx.serviceqq -o json-pretty
#显示日志占据的硬盘空间
journalctl --disk-usage
#指定日志文件占据的最大空间
journalctl --vacuum-size=1G
#指定日志文件保存多久
journalctl --vacuum-time=1years
```
