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

2、加载内核模块,安装完ipmitool之后,对应的ipmi的驱动已经编译到内核模块目录.加载对应目录后, 便可以对IPMI进行各种设置.
```
modprobe ipmi_msghandler
modprobe ipmi_devintf
modprobe ipmi_si
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
ipmitool sel list                              #查看SEL日志
ipmitool sel elist                             #查看SEL日志详情
```

5、SDR，Sensor信息查看
```
ipmitool sdr                                   #查看硬件信息
ipmitool sensor list                           #可以获得传感器ID号
ipmitool sensor get "CPU PVCCIO"               #其中"CPUPVCCIO"是ID号，即传感器的名称
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
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis bootdev disk         # 设置硬盘启动
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis bootdev cdrom        # 设置光驱启动
```

3、设置服务器的电源
```
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power off            # 关闭服务器
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power reset          # 重启服务器
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power on             # 开启服务器
ipmitool -I lan -H 10.1.199.212 -U ADMIN -P ADMIN chassis power status         # 查看服务器电源
```
