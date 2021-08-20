bonding的七种工作模式: 
```
balance-rr (mode=0)     轮询策略          传输数据包顺序是依次传输，直到最后一个传输完毕， 此模式提供负载平衡和容错能力。
active-backup (mode=1)  主备策略          只有一个设备处于活动状态。 一个宕掉另一个马上由备份转换为主设备。
balance-xor (mode=2)    异或策略          传输根据[(源MAC地址xor目标MAC地址) mod 设备数量]的布尔值选择传输设备
broadcast (mode=3)      广播策略          将所有数据包传输给所有设备。 此模式提供了容错能力。
802.3ad (mode=4)        动态链接聚合       创建共享相同的速度和双工设置的聚合组。此模式提供了容错能力。每个设备需要基于驱动的重新获取速度和全双工支持；如果使用交换机，交换机也需启用 802.3ad 模式。
balance-tlb (mode=5)    适配器传输负载均衡  通道绑定不需要专用的交换机支持。发出的流量根据当前负载分给每一个设备。由当前设备处理接收，如果接受的设备传不通就用另一个设备接管当前设备正在处理的mac地址。
balance-alb (mode=6)    适配器负载均衡      包括mode5，但不需要交换机支持，由 ARP 协商完成接收的负载。bonding驱动程序截获 ARP 在本地系统发送出的请求，用其中之一的硬件地址覆盖从属设备的原地址。就像是在服务器上不同的人使用不同的硬件地址一样。
```  
常用模式  
- mode=0 表示负载均衡方式，两块网卡都工作，需要交换机作支持。   
- mode=1 表示冗余方式，网卡只有一个工作，一个出问题启用另外的。   
- mode=6 表示负载均衡方式，两块网卡都工作，不需要交换机作支持。  

rhel6 bonding 
===

1、关闭和停止NetworkManager服务  
```
# service  NetworkManager stop    # 停止NetworkManager服务
# chkconfig NetworkManager off    # 禁止开机启动NetworkManager服务
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
NM_CONTROLLED=no
USERCTL=no
ONBOOT=yes
MASTER=bond0                  # 需要和上面的ifcfg-bond0配置文件中的DEVICE的值对应
SLAVE=yes
BOOTPROTO=none

# vim /etc/sysconfig/network-scripts/ifcfg-ens37
DEVICE=ens37
NM_CONTROLLED=no
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

RedHat7配置bonding
===

1、关闭和停止NetworkManager服务
RedHat7默认安装了NetworkManager，在配置前先关掉NetworkManager服务，否则可能会对bonding或造成问题。
```
systemctl stop NetworkManager.service     # 停止NetworkManager服务
systemctl disable NetworkManager.service  # 禁止开机启动NetworkManager服务
```
2、加载bonding模块
```
modprobe --first-time bonding
```
没有提示说明加载成功, 如果出现modprobe: ERROR: could not insert 'bonding': Module already in kernel说明你已经加载了这个模块, 就不用管了

3、使用lsmod | grep bonding查看模块是否被加载
```
lsmod | grep bonding
bonding               152656  0 
```

4、创建基于bond0接口的配置文件
```
[root@ReHat7.6 network-scripts]# cat ifcfg-bond0
DEVICE=bond0
IPADDR=10.211.100.10
NETMASK=255.255.255.0
ONBOOT=yes
BOOTPROTO=none
USERCTL=no
NM_CONTROLLED=no
BONDING_OPTS="mode=1 miimon=200"
```
上面的BONDING_OPTS="mode=1 miimon=200" 表示这里配置的工作模式是mode1, miimon表示监视网络链接的频度 (毫秒), 我们设置的是100毫秒, 根据你的需求也可以指定mode成其它的负载模式。

5、修改eno3、eno4子接口的配置文件
```
[root@ReHat7.6 ]# cat ifcfg-eno3
NAME=eno3
DEVICE=eno3
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
ONBOOT=yes
MASTER=bond0
SLAVE=yes
UESCTL=no
NM_CONTROLLED=no

[root@ReHat7.6 ]# cat ifcfg-eno4
NAME=eno4
DEVICE=eno4
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
ONBOOT=yes
MASTER=bond0
SLAVE=yes
UESCTL=no
NM_CONTROLLED=no
```

6、查看bonding信息

重启网络服务
```
systemctl restart network
```

查看bond0的接口状态信息 ( 如果报错说明没做成功，很有可能是bond0接口没起来)
```
[root@ReHat7.6 network-scripts]# cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: fault-tolerance (active-backup)           # 绑定模式: 主备模式(mode 1)
Primary Slave: None
Currently Active Slave: eno4                            # 当前活动接口
MII Status: up                                          # 接口状态: up(MII是Media Independent Interface简称, 接口的意思)
MII Polling Interval (ms): 200                          # 接口轮询的时间隔(这里是200ms)
Up Delay (ms): 0
Down Delay (ms): 0

Slave Interface: eno3                                   # Slave 接口，也就是受bond管控的接口
MII Status: up                                          # 接口状态: up(MII是Media Independent Interface简称, 接口的意思)
Speed: 1000 Mbps                                        # 端口的速率是1000 Mpbs
Duplex: full                                            # 全双工
Link Failure Count: 0                                   # 链接失败次数: 0
Permanent HW addr: 74:46:a0:f4:9f:c2                    # 永久的MAC地址
Slave queue ID: 0

Slave Interface: eno4
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 74:46:a0:f4:9f:c3
Slave queue ID: 0

[root@ReHat7.6 ~]# ip a
1: eno3: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
    link/ether 74:46:a0:f4:9f:c2 brd ff:ff:ff:ff:ff:ff
2: eno4: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
    link/ether 74:46:a0:f4:9f:c2 brd ff:ff:ff:ff:ff:ff
3: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 74:46:a0:f4:9f:c2 brd ff:ff:ff:ff:ff:ff
    inet 10.211.100.10/24 brd 10.211.139.255 scope global bond0
       valid_lft forever preferred_lft forever
```

Bonding命令行管理工具 ifenslave
---

ifslave 可以绑定、分离和切换活动网卡，同样ifslave的使用需要内核支持bonding。
```
modprobe bonding      // 加载内核模块  
ifenslave bond0 eth0 eth1      // 绑定网卡
ifconfig bond0 192.168.0.1 netmask 255.255.0.0    // 配置IP
ifenslave -c bond0 eth1      // 切换活动网卡到eth1
ifenslave -d bond0 eth1     // 从bond0中移除eth1
```
 高可用测试中（插拔网线）发现：在mode=6模式下丢包1个, 恢复网络时( 网络插回去 ) 丢包在5-6个左右，说明高可用功能正常但恢复的时候丢包会比较多测试mode=1模式下丢包1个，恢复网络时( 网线插回去 ) 基本上没有丢包，说明高可用功能和恢复的时候都正常mode6这种负载模式除了故障恢复的时候有丢包之外其它都挺好的，如果能够忽略这点的话可以这种模式；而mode1故障的切换和恢复都很快，基本没丢包和延时。但端口利用率比较低，因为这种主备的模式只有一张网卡在工作。

参考：
- http://blog.chinaunix.net/uid-31410005-id-5818605.html
- https://www.cnblogs.com/dkblog/p/3613407.html
- https://www.cnblogs.com/huangweimin/articles/6527058.html
- https://www.cnblogs.com/dkblog/p/3613407.html
