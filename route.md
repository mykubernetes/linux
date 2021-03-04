基本用法  
```
查看路由： route -n
添加路由： route add
删除路由： route del
```  

实例  
```
添加主机路由： 192.168.1.3 网关： 172.16.0.1
# route add -host 192.168.1.3 gw 172.16.0.1 dev eth0

添加网络路由: 192.168.0.0 网关：172.16.0.1
#route add -net 192.168.0.0 netmask 255.255.255.0 172.16.0.1 dev eth0
或#route add -net 192.168.0.0/24 172.16.0.1 dev eth0

添加默认路由：网关：172.16.0.1
# route add -net 0.0.0.0 netmask 0.0.0.0 gw 172.16.0.1
或 # route add default gw 172.16.0.1
```

删除路由  
```
删除主机路由：192.168.1.3 网关： 172.16.0.1
# route del -host 192.168.1.3

删除网络路由：192.168.0.0 网关：172.16.0.1
# route del -net 192.168.0.0 netmask 255.255.255.0
```  
常见参数：
- add	增加路由
- del	删除路由
- via	网关出口IP地址
- dev	网关出口物理设备名



Linux 添加永久静态路由的方法
```
https://www.jb51.net/article/105749.htm
```
