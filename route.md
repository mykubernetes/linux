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
---
```
1、查看当前机器的路由表
# route -n
Kernel IP routing table
Destination   Gateway     Genmask     Flags Metric Ref  Use Iface
0.0.0.0     135.252.214.1  0.0.0.0     UG  100  0    0 eth0
135.252.214.0  0.0.0.0     255.255.255.0  U   100  0    0 eth0
172.86.40.0   0.0.0.0     255.255.255.0  U   100  0    0 eth1
192.168.122.0  0.0.0.0     255.255.255.0  U   0   0    0 virbr0

2、如果机器中存在多块网卡，可以为不同网卡指定不同的静态路由
比如还有eth0，eht2，每块网卡创建一个对应的路由配置文件。route-eth0;route-eth1;route-eth2

# ls
ifcfg-eth0     ifcfg-eth1:enodeb2 ifcfg-eth1:mme2 ifdown    ifdown-ib  ifdown-isdn ifdown-routes ifdown-TeamPort ifup-aliases ifup-ib  ifup-isdn  ifup-post  ifup-sit    ifup-tunnel    network-functions
ifcfg-eth1     ifcfg-eth1:gx    ifcfg-eth1:sgi  ifdown-bnep ifdown-ippp ifdown-post ifdown-sit   ifdown-tunnel  ifup-bnep   ifup-ippp ifup-plip  ifup-ppp   ifup-Team   ifup-wireless   network-functions-ipv6
ifcfg-eth1:enodeb1 ifcfg-eth1:mme1   ifcfg-lo     ifdown-eth  ifdown-ipv6 ifdown-ppp  ifdown-Team  ifup       ifup-eth   ifup-ipv6 ifup-plusb ifup-routes ifup-TeamPort init.ipv6-global route-eth1

3、添加一条静态路由，访问172.0.0.0/8时通过172.86.40.254
vi /etc/sysconfig/network-scripts/route-eth1
172.0.0.0/8 via 172.86.40.254

4、重启网络服务
systemctl restart network

5、验证
# route -n
Kernel IP routing table
Destination   Gateway     Genmask     Flags Metric Ref  Use Iface
0.0.0.0     135.252.214.1  0.0.0.0     UG  100  0    0 eth0
135.252.214.0  0.0.0.0     255.255.255.0  U   100  0    0 eth0
172.0.0.0    172.86.40.254  255.0.0.0    UG  100  0    0 eth1            #添加成功
172.86.40.0   0.0.0.0     255.255.255.0  U   100  0    0 eth1
192.168.122.0  0.0.0.0     255.255.255.0  U   0   0    0 virbr0
```
