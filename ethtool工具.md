# ethtools

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
ethtool -s eth0 speed 100 duplex full autoneg off
```
此指令将eth0设备设置为全双工自适应，速度为100Mbs。若要eth0启动时设置这些参数, 修改文件`/etc/sysconfig/network-scripts/ifcfg-eth0`，添加如下一行:
```
ETHTOOL_OPTS="speed 100 duplex full autoneg off"
```
或者
将ethtool设置写入`/etc/rc.d/rc.local`之中。
