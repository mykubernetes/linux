bonding的七种工作模式: 
```
balance-rr (mode=0)     轮询策略          默认, 有高可用(容错)和负载均衡的功能,需要交换机的配置，每块网卡轮询发包 (流量分发比较均衡).
active-backup (mode=1)  主备策略          只有高可用(容错)功能, 不需要交换机配置,这种模式只有一块网卡工作,对外只有一个mac地址。缺点是端口利用率比较低
balance-xor (mode=2)    异或策略          不常用
broadcast (mode=3)      广播策略          不常用
802.3ad (mode=4)        动态链接聚合       IEEE 802.3ad 动态链路聚合，需要交换机配置
balance-tlb (mode=5)    适配器传输负载均衡  不常用
balance-alb (mode=6)    适配器负载均衡      有高可用(容错)和负载均衡的功能，不需要交换机配置(流量分发到每个接口不是特别均衡)
```  
常用模式  
- mode=0 表示负载均衡方式，两块网卡都工作，需要交换机作支持。   
- mode=1 表示冗余方式，网卡只有一个工作，一个出问题启用另外的。   
- mode=6 表示负载均衡方式，两块网卡都工作，不需要交换机作支持。  

1、关闭和停止NetworkManager服务  
```
# systemctl stop NetworkManager.service     # 停止NetworkManager服务
# systemctl disable NetworkManager.service  # 禁止开机启动NetworkManager服务
```  

2、加载bonding模块  
```
1、查看是否加载bonding模块
# lsmod | grep bonding
2、如果没有加载
# modprobe --first-time bonding
```  

3、创建基于bond0接口的配置文件  
```
# vim /etc/sysconfig/network-scripts/ifcfg-bond0
DEVICE=bond0
TYPE=Bond
IPADDR=192.168.101.80
NETMASK=255.255.255.0
GATEWAY=192.168.101.1
DNS1=114.114.114.114
USERCTL=no
BOOTPROTO=none
ONBOOT=yes
BONDING_MASTER=yes
BONDING_OPTS="mode=6 miimon=100"
```  
- BONDING_OPTS="mode=6 miimon=100" 表示这里配置的工作模式是mode6(adaptive load balancing)  
- miimon是链路监测的时间间隔单位是毫秒，miimon=100的意思就是，每100毫秒检测网卡和交换机之间是否连通，如不通则使用另外的链路。  

4、配置两块网卡为slave并指向bond0网卡  
```
# vim /etc/sysconfig/network-scripts/ifcfg-ens33
DEVICE=ens33
USERCTL=no
ONBOOT=yes
MASTER=bond0                  # 需要和上面的ifcfg-bond0配置文件中的DEVICE的值对应
SLAVE=yes
BOOTPROTO=none

# vim /etc/sysconfig/network-scripts/ifcfg-ens37
DEVICE=ens37
USERCTL=no
ONBOOT=yes
MASTER=bond0                 # 需要和上的ifcfg-bond0配置文件中的DEVICE的值对应
SLAVE=yes
BOOTPROTO=none
```  

5、测试  
重启网络服务  
```
systemctl restart network
```  

6、查看bond0的接口状态信息  ( 如果报错说明没做成功，很有可能是bond0接口没起来)  
```
# cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: adaptive load balancing      # 绑定模式: 当前是ald模式(mode 6), 也就是高可用和负载均衡模式
Primary Slave: None
Currently Active Slave: ens33
MII Status: up                             # 接口状态: up(MII是Media Independent Interface简称, 接口的意思)
MII Polling Interval (ms): 100             # 接口轮询的时间隔(这里是100ms)
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: ens33                     # 备接口: ens33
MII Status: up                             # 接口状态: up
Speed: 1000 Mbps                           # 端口的速率是1000 Mpbs
Duplex: full                               # 全双工
Link Failure Count: 0                      # 链接失败次数: 0
Permanent HW addr: 00:0c:29:17:50:6d       # 永久的MAC地址
Slave queue ID: 0

Slave Interface: ens37                     # 备接口: ens37
MII Status: up                             # 接口状态: up
Speed: 1000 Mbps                           # 端口的速率是1000 Mpbs
Duplex: full                               # 全双工
Link Failure Count: 0                      # 链接失败次数: 0
Permanent HW addr: 00:0c:29:17:50:77       # 永久的MAC地址
Slave queue ID: 0
```  

7、通过ifconfig命令查看下网络的接口信息  
```
# ifconfig 
bond0: flags=5187<UP,BROADCAST,RUNNING,MASTER,MULTICAST>  mtu 1500
        inet 192.168.101.80  netmask 255.255.255.0  broadcast 192.168.101.255
        inet6 fe80::20c:29ff:fe17:506d  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:17:50:6d  txqueuelen 1000  (Ethernet)
        RX packets 239  bytes 21219 (20.7 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 166  bytes 20397 (19.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens33: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500
        ether 00:0c:29:17:50:6d  txqueuelen 1000  (Ethernet)
        RX packets 1162  bytes 111482 (108.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 888  bytes 135374 (132.2 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens37: flags=6211<UP,BROADCAST,RUNNING,SLAVE,MULTICAST>  mtu 1500
        ether 00:0c:29:17:50:77  txqueuelen 1000  (Ethernet)
        RX packets 29  bytes 2800 (2.7 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 19  bytes 1848 (1.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1  (Local Loopback)
        RX packets 192  bytes 15552 (15.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 192  bytes 15552 (15.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```  

