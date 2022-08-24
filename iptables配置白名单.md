
1、配置防火墙时添加crontab每十分钟执行一次停止防火墙，防止被防火墙关在外边
```
*/10 * * * * systemctl stop firewalld
```

2、查看主机启用的端口
```
netstat -lantup|grep LISTEN|awk '{print $4}'|awk -F":" '{print $NF}'
netstat -anup|grep -w "udp"|awk -F":" '{print $2}'|awk '{print $1}'
```

3、配置白名单列表
```
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

#这里开始增加白名单服务器ip(请删除当前服务器的ip地址)
-N whitelist
-A whitelist -s 192.168.1.101 -j ACCEPT
-A whitelist -s 192.168.1.102 -j ACCEPT
-A whitelist -s 192.168.1.103 -j ACCEPT
-A whitelist -s 192.168.3.0/24 -j ACCEPT
-A whitelist -s 192.168.1.104 -j ACCEPT

#这种是针对白名单里的端口开启，即只能白名单里的IP能够通过这个端口访问。
-A INPUT  -p tcp -j whitelist
-A INPUT  -p udp -j whitelist
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j whitelist
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8848 -j whitelist
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j whitelist
-A INPUT -m state --state NEW -m udp -p tcp --dport 111 -j whitelist
-A INPUT -m state --state RELATED,ESTABLISHED -j whitelist

#这种是全白的开启，即任何的机器都能通过这个端口访问。
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT

#默认规则
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -i bond0 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```
