ipmitool 工具使用教程
===

在linux上实现该协议的工具是ipmitool命令,可以控制物理机的:
- 开机
- 关机
- 重启
- 查看机器当前的通电状态
- 修改IPMI的网络和IP地址
- 修改bios设置

1、安装 ipmitool

```
yum -y install ipmitool
```

2、查看硬件信息
```
ipmitool  sdr
```

3、加载内核模块,安装完ipmitool之后,对应的ipmi的驱动已经编译到内核模块目录.加载对应目录后, 便可以对IPMI进行各种设置.
```
modprobe ipmi_msghandler
modprobe ipmi_devintf
modprobe ipmi_si
```

```
# ipmitool help
Commands:
	raw           Send a RAW IPMI request and print response
	i2c           Send an I2C Master Write-Read command and print response
	spd           Print SPD info from remote I2C device
	lan           Configure LAN Channels
	chassis       Get chassis status and set power state
	power         Shortcut to chassis power commands
	event         Send pre-defined events to MC
	mc            Management Controller status and global enables
	sdr           Print Sensor Data Repository entries and readings
	sensor        Print detailed sensor information
	fru           Print built-in FRU and scan SDR for FRU locators
	gendev        Read/Write Device associated with Generic Device locators sdr
	sel           Print System Event Log (SEL)
	pef           Configure Platform Event Filtering (PEF)
	sol           Configure and connect IPMIv2.0 Serial-over-LAN
	tsol          Configure and connect with Tyan IPMIv1.5 Serial-over-LAN
	isol          Configure IPMIv1.5 Serial-over-LAN
	user          Configure Management Controller users
	channel       Configure Management Controller channels
	session       Print session information
	dcmi          Data Center Management Interface
	nm            Node Manager Interface
	sunoem        OEM Commands for Sun servers
	kontronoem    OEM Commands for Kontron devices
	picmg         Run a PICMG/ATCA extended cmd
	fwum          Update IPMC using Kontron OEM Firmware Update Manager
	firewall      Configure Firmware Firewall
	delloem       OEM Commands for Dell systems
	shell         Launch interactive IPMI shell
	exec          Run list of commands from file
	set           Set runtime variable for shell and exec
	hpm           Update HPM components using PICMG HPM.1 file
	ekanalyzer    run FRU-Ekeying analyzer using FRU files
	ime           Update Intel Manageability Engine Firmware
	vita          Run a VITA 46.11 extended cmd
	lan6          Configure IPv6 LAN Channels

a) raw：发送一个原始的IPMI请求，并且打印回复信息。
b) Lan：配置网络（lan）信道(channel)
c) chassis ：查看底盘的状态和设置电源
d) event：向BMC发送一个已经定义的事件（event），可用于测试配置的SNMP是否成功
e) mc： 查看MC（Management Contollor）状态和各种允许的项
f) sdr：打印传感器仓库中的所有监控项和从传感器读取到的值。
g) Sensor：打印详细的传感器信息。
h) Fru：打印内建的Field Replaceable Unit (FRU)信息
i) Sel： 打印 System Event Log (SEL)
j) Pef： 设置 Platform Event Filtering (PEF)，事件过滤平台用于在监控系统发现有event时候，用PEF中的策略进行事件过滤，然后看是否需要报警。
k) Sol/isol：用于配置通过串口的Lan进行监控
l) User：设置BMC中用户的信息 。
m) Channel：设置Management Controller信道。
```

带内操作
---

1、用户管理
```
##查看 ipmi 的用户名和密码
# ipmitool user list 1
ID  Name             Callin  Link Auth  IPMI Msg   Channel Priv Limit
2   ADMIN            false   false      true

##重置 ipmi 管理员密码
# ipmitool user set password 2 {admin_password}       #2为用户ID

##添加用户
# ipmitool user set name 3 xh                         #ipmitool user set name <user id> <username>

##查看用户权限：
# ipmitool channel getaccess 1  3                     #3为用户ID

##设置用户权限
##示例：ipmitool channel setaccess [ChannelNo] <user id>[callin=on|off] [ipmi=on|off] [link=on|off] [privilege=level]
# ipmitool channel setaccess 1 3 callin=off ipmi=on link=onprivilege=4

##启用/禁用用户
##示例：ipmitool user enable/disable <user id>
ipmitool disable user 3
```

3、设置 ipmi 的 ip
```
ipmitool lan set 1 ipsrc dhcp                  # 设置 ipmi 通过dhcp获取IP
ipmitool lan print 1
ipmitool lan set 1 ipsrc static                # 设置 ipmi 配置静态 ip
ipmitool lan set 1 ipaddress 10.1.0.10         # 设置 ipmi 的 ip 为 10.1.0.10
ipmitool lan set 1 netmask 255.255.255.0       # 设置 ipmi 的掩码
ipmitool lan set 1 defgw ipaddr 10.1.0.1       # 设置 ipmi 的默认网关
```

4、SEL日志查看
```
ipmitool sel list                              #查看日志
Ipmitool sel elist　　　                       #显示所有系统事件日志
Ipmitool sel clear　　　                       #删除所有系统时间日志
Ipmitool sel delete ID                        #删除第ID条SEL
Ipmitool sel time get 　                      #显示当前BMC的时间
Ipmitool sel time set XXX                     #设置当前BMC的时间
```

5、SDR，Sensor信息查看
```
ipmitool sdr                                   #查看硬件信息
ipmitool sensor list                           #可以获得传感器ID号
ipmitool sensor get "CPU PVCCIO"               #其中"CPUPVCCIO"是ID号，即传感器的名称

ipmitool sensor                                #所有传感器状态详细信息
ipmitool sdr info                              #传感器SDR summary信息
ipmitool sdr list                              #传感器SDR 列表信息
ipmitool sdr list fru                          #FRU传感器SDR 列表信息
ipmitool sdr dump sdr.raw                      #下载RAW SDR信息到文件
ipmitool fru                                   #查看服务器的FRU信息
ipmitool fru print                             #查看服务器的FRU信息
Ipmitool pef list 　　                         #显示系统平台时间过滤的列表
```

6、mc(管理单元BMC)状态和控制
```
ipmitool mc info                               #查看BMC硬件信息
ipmitool mc reset <warm|cold>                  #使BMC重新启动,warm表示软重启；cold表示硬重启
```

带外远程操作
---
1、打印ipmi基本信息
```
ipmitool -I lan -H 10.1.0.10 -U ADMIN -P ADMIN lan print 1                     # 打印
```

2、设置bios的引导模式
```
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis bootdev pxe          # pxe启动, 一般用于远程自动装机
Ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis bootdev bios         # 重启后停在BIOS 菜单
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis bootdev disk         # 设置硬盘启动
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis bootdev cdrom        # 设置光驱启动
```

3、设置服务器的电源
```
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power off            # 硬关机，直接切断电源
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power soft           # 软关机，轻按一下开机扭
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power reset          # 硬重启，重启服务器
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power on             # 硬开机，启动服务器
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power status         # 查看服务器电源状态
```

BMC 防火墙策略配置全部拒绝导致无法访问
---
```
登录该服务器系统后执行：
# ipmitool raw 0x32 0x66                        #恢复默认值
# ipmitool lan set 1 ipsrc static               #设置ipmi ip非DHCP
# ipmitool lan set 1 ipaddr 192.168.0.1         #设置IPMI  地址）
# ipmitool lan set 1 netmask 255.255.255.0      #设置ipmi 子网掩码
# ipmitool lan set 1 defgw ipaddr 192.168.0.1   #设置ipmi 网关
# ipmitool user set password 1 abcdefg          #改ipmi 用户名1的密码,#root 修改后默认密码abcdefg
# ipmitool user set password 2 abcdefg          #修改ipmi 用户名2的密码,#admin 修改后默认密码abcdefg
```
