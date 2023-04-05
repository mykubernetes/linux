# 一、命令简介
  ethtool命令用于查询和控制网络设备驱动程序和硬件设置，尤其是有线以太网设备，devname网卡的名称。网卡就像是交换机的一个端口，正常使用我们只是配置网卡IP地址等信息，网卡的速率、双工模式等我们并不关心。通过ethtool命令我们可以像配置交换机网卡一样配置这些参数，这就是这个命令的魅力所在。

下面的信息将帮助你了解以太网卡的工作原理。
- **半双工**：半双工模式允许设备一次只能发送或接收数据包。
- **全双工**：全双工模式允许设备可以同时发送和接收数据包。
- **自动协商**：自动协商是一种机制，允许设备自动选择最佳网速和工作模式（全双工或半双工模式）。
- **速度**：默认情况下，它会使用最大速度，你可以根据自己的需要改变它。
- **链接检测**：链接检测可以显示网卡的状态。如果显示为 `no`，请尝试重启网卡。如果链路检测仍显示 `no`，则检查交换机与系统之间连接的线缆是否有问题。


# 二、ethtools 参数

- ethtool 是用于查询及设置网卡参数的命令。
```
 -a 查看网卡中 接收模块RX、发送模块TX和Autonegotiate模块的状态：启动on 或 停用off。
 -A 修改网卡中 接收模块RX、发送模块TX和Autonegotiate模块的状态：启动on 或 停用off。
 -c display the Coalesce information of the specified ethernet card。
 -C Change the Coalesce setting of the specified ethernet card。 
 -g Display the rx/tx ring parameter information of the specified ethernet card。
 -G change the rx/tx ring setting of the specified ethernet card。 -i 显示网卡驱动的信息，如驱动的名称、版本等。
 -d 显示register dump信息, 部分网卡驱动不支持该选项。 
 -e 显示EEPROM dump信息，部分网卡驱动不支持该选项。 
 -E 修改网卡EEPROM byte。
 -k 显示网卡Offload参数的状态：on 或 off，包括rx-checksumming、tx-checksumming等。 
 -K 修改网卡Offload参数的状态。 
 -p 用于区别不同ethX对应网卡的物理位置，常用的方法是使网卡port上的led不断的闪；N指示了网卡闪的持续时间，以秒为单位。
 -r 如果auto-negotiation模块的状态为on，则restarts auto-negotiation。 
 -S 显示NIC- and driver-specific 的统计参数，如网卡接收/发送的字节数、接收/发送的广播包个数等。 
 -t 让网卡执行自我检测，有两种模式：offline or online。
 -s 修改网卡的部分配置，包括网卡速度、单工/全双工模式、mac地址等。.
 
ethtool eth0             #查看网卡信息  # 操作完毕后，输出信息中Speed:这一项就指示了网卡的速度。
ethtool -i eth0          #查看网卡eth0采用了何种驱动
ethtool -p eth0 10       #操作完毕后，看哪块网卡的led灯在闪，eth0就对应着哪块网卡。
ethtool –S eth0          #查看网卡，在接收/发送数据时，有没有出错
ethtool -s eth0 speed    # 改变网卡速度   10/100/1000
```

# ethtool 设置可通过 /etc/sysconfig/network-scripts/ifcfg-ethX 文件保存，从而在设备下次启动时激活选项。

例如：
```
Syntax:
ethtool –s [device_name] speed [10/100/1000] duplex [half/full] autoneg [on/off]

ethtool -s eth0 speed 1000 duplex full autoneg off
```
此指令将eth0设备设置为全双工自适应，速度为100Mbs。若要eth0启动时设置这些参数, 修改文件`/etc/sysconfig/network-scripts/ifcfg-eth0`，添加如下一行:
```
# vi /etc/sysconfig/network-scripts/ifcfg-eth0
ETHTOOL_OPTS="speed 1000 duplex full autoneg off"
```
或者
将ethtool设置写入`/etc/rc.d/rc.local`之中。


# 三、使用示例

1、获取命令帮助
```
[root@s211 ~]# ethtool -h
```
2、查看命令版本
```
[root@s211 ~]# ethtool --version
ethtool version 5.8
```

3、安装命令
```
[root@s211 ~]# yum install -y ethtool
```

4、查看端口是否up

- 显示yes表示端口为up状态，使用命令ethtool devicename查看。
```
# ethtool ens5f0
Settings for ens5f0:
        Supported ports: [ FIBRE ]
        Supported link modes:   1000baseKX/Full           ##支持的链路模式
                                10000baseKR/Full 
                                25000baseCR/Full 
                                25000baseKR/Full 
                                25000baseSR/Full 
        Supported pause frame use: Symmetric             ##暂停帧的支持，以太网流量控制
        Supports auto-negotiation: Yes                   ##链路自动协商
        Supported FEC modes: None BaseR        
        Advertised link modes:  1000baseKX/Full 
                                10000baseKR/Full 
                                25000baseCR/Full 
                                25000baseKR/Full 
                                25000baseSR/Full 
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: Yes                  ##建议自动协商  
        Advertised FEC modes: None                        ##建议的FEC mode
        Speed: 10000Mb/s                                  ##速率
        Duplex: Full                                      ##双工模式
        Port: FIBRE                                       ##port类型，，还会有
        PHYAD: 0                                          ##网卡的物理标识，如果两个device的PHYAD相同，表示在一块物理网卡上
        Transceiver: internal                             ##internal — Use internal transceiver、external — Use external transceiver.
        Auto-negotiation: on                    
        Supports Wake-on: d
        Wake-on: d                                        ##Wake On LAN是否启用,d:禁用，g:启用
        Current message level: 0x00000004 (4)
                               link
        Link detected: yes                                ##对于link也有一个比较实用的redhat kb:https://access.redhat.com/solutions/46885
```

5、查询指定网卡的驱动程序信息
```
#台式机网卡
[root@s211 ~]# ethtool -i enp2s0
driver: r8169
version:
firmware-version: rtl8168g-2_0.0.1 02/06/13
expansion-rom-version:
bus-info: 0000:02:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no

#服务器网卡
[root@s101 ~]# ethtool -i em1
driver: igb
version: 5.4.0-k
firmware-version: 1.56, 0x80000acf, 14.5.8
expansion-rom-version:
bus-info: 0000:01:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
```

6、网卡自检
```
[root@s101 ~]# ethtool -t em1
The test result is PASS
The test extra info:
Register test (offline) 0
Eeprom test (offline) 0
Interrupt test (offline) 0
Loopback test (offline) 0
Link test (on/offline) 0
```

参考：
- https://blog.csdn.net/carefree2005/article/details/121541876
- https://linux.cn/article-12290-1.html
