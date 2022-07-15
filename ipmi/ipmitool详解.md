# 介绍

**IPMItool**用于访问**IPMI**的功能-智能平台管理接口，该系统接口管理和监视带外计算机系统。它是一个命令提示符，用于控制和配置IPMI支持的设备。

在本教程中，学习如何在基于Linux的CentOS或Ubuntu系统上安装IPMItool并开始使用IPMI命令。

## 1：通过系统查看物理机带外管理IP
```
[root@localhost tmp]# ipmitool lan print 1
Set in Progress         : Set Complete
Auth Type Support       : MD5
Auth Type Enable        : Callback : MD5
                        : User     : MD5
                        : Operator : MD5
                        : Admin    : MD5
                        : OEM      : MD5
IP Address Source       : Static Address
IP Address              : 192.168.206.57
Subnet Mask             : 255.255.255.0
MAC Address             : 6c:92:bf:9b:4c:49
SNMP Community String   : AMI
IP Header               : TTL=0x40 Flags=0x40 Precedence=0x00 TOS=0x10
BMC ARP Control         : ARP Responses Enabled, Gratuitous ARP Disabled
Gratituous ARP Intrvl   : 0.0 seconds
Default Gateway IP      : 192.168.206.1
Default Gateway MAC     : 58:60:5f:87:2e:c3
Backup Gateway IP       : 0.0.0.0
Backup Gateway MAC      : 00:00:00:00:00:00
802.1q VLAN ID          : Disabled
802.1q VLAN Priority    : 0
RMCP+ Cipher Suites     : 0,1,2,3,6,7,8,11,12,15,16,17
Cipher Suite Priv Max   : caaaaaaaaaaaXXX
                        :     X=Cipher Suite Unused
                        :     c=CALLBACK
                        :     u=USER
                        :     o=OPERATOR
                        :     a=ADMIN
                        :     O=OEM
Bad Password Threshold  : 0
Invalid password disable: no
Attempt Count Reset Int.: 0
User Lockout Interval   : 0
```

## 2：查询BMC中相关的SDR(传感器数据记录)信息
```
[root@k8s-node-gpu-dataswitch-p-222028 yum.repos.d]#  ipmitool sdr 或者 ipmitool sdr list
Inlet_Temp       | 24 degrees C      | ok
Outlet_Temp      | 37 degrees C      | ok
CPU0_Temp        | 63 degrees C      | ok
CPU1_Temp        | 52 degrees C      | ok
CPU0_DTS         | 4 degrees C       | ok
CPU1_DTS         | 7 degrees C       | ok
CPU0_DIMM_Temp   | 29 degrees C      | ok
CPU1_DIMM_Temp   | 29 degrees C      | ok
CPU0_VR_Temp     | 32 degrees C      | ok
CPU1_VR_Temp     | 33 degrees C      | ok
PCH_Temp         | 52 degrees C      | ok
OCP_Temp         | no reading        | ns
NVME_Temp        | 35 degrees C      | ok
PSU0_Temp        | 32 degrees C      | ok
PSU1_Temp        | 26 degrees C      | ok
RAID0_Temp       | no reading        | ns
RAID1_Temp       | no reading        | ns
RAID2_Temp       | no reading        | ns
RAID3_Temp       | no reading        | ns
GPU0_Temp        | no reading        | ns
GPU1_Temp        | 23 degrees C      | ok
GPU2_Temp        | no reading        | ns
GPU3_Temp        | no reading        | ns
GPU4_Temp        | 23 degrees C      | ok
GPU5_Temp        | no reading        | ns
GPU6_Temp        | no reading        | ns
GPU7_Temp        | no reading        | ns
PCIE_SSD0_Temp   | no reading        | ns
PCIE_SSD1_Temp   | no reading        | ns
PCIE_SSD2_Temp   | no reading        | ns
PCIE_SSD3_Temp   | no reading        | ns
PCIE_SSD4_Temp   | no reading        | ns
PCIE_SSD5_Temp   | no reading        | ns
PCIE_SSD6_Temp   | no reading        | ns
PCIE_SSD7_Temp   | no reading        | ns
M.2_Inlet_Temp   | 29 degrees C      | ok
Rear_HDDBP_Temp  | no reading        | ns
SWITCH0_Temp     | no reading        | ns
SWITCH1_Temp     | no reading        | ns
P3V3             | 3.28 Volts        | ok
P5V              | 5.08 Volts        | ok
P12V             | 12.06 Volts       | ok
CPU0_Vcore       | 1.76 Volts        | ok
CPU1_Vcore       | 1.76 Volts        | ok
CPU0_DDR_VDDQ1   | 1.22 Volts        | ok
CPU0_DDR_VDDQ2   | 1.22 Volts        | ok
CPU1_DDR_VDDQ1   | 1.22 Volts        | ok
CPU1_DDR_VDDQ2   | 1.22 Volts        | ok
CPU0_PVCCIO      | 1.01 Volts        | ok
CPU1_PVCCIO      | 1.00 Volts        | ok
PCH_P1V05        | 1.05 Volts        | ok
PCH_VNN          | 1 Volts           | ok
CPU0_Status      | 0x00              | ok
CPU1_Status      | 0x00              | ok
PSU0_Status      | 0x00              | ok
PSU1_Status      | 0x00              | ok
PSU_Redundant    | 0x00              | ok
PSU0_Fan_Status  | 0x00              | ok
PSU1_Fan_Status  | 0x00              | ok
FAN0_F_Speed     | 5760 RPM          | ok
FAN0_R_Speed     | 4896 RPM          | ok
FAN1_F_Speed     | 5760 RPM          | ok
FAN1_R_Speed     | 4896 RPM          | ok
FAN2_F_Speed     | 5760 RPM          | ok
FAN2_R_Speed     | 4896 RPM          | ok
FAN3_F_Speed     | 5760 RPM          | ok
FAN3_R_Speed     | 4896 RPM          | ok
FAN_M2_Speed     | 0 RPM             | ok
FAN0_Present     | 0x00              | ok
FAN1_Present     | 0x00              | ok
FAN2_Present     | 0x00              | ok
FAN3_Present     | 0x00              | ok
Total_Power      | 296 Watts         | ok
CPU_Power        | 158 Watts         | ok
MEM_Power        | 10 Watts          | ok
FAN_Power        | 25 Watts          | ok
HDD_Power        | 6 Watts           | ok
PSU0_POUT        | 136 Watts         | ok
PSU1_POUT        | 128 Watts         | ok
CPU0_C0D0        | 0x00              | ok
CPU0_C0D1        | 0x00              | ok
CPU0_C1D0        | 0x00              | ok
CPU0_C1D1        | 0x00              | ok
CPU0_C2D0        | 0x00              | ok
CPU0_C2D1        | 0x00              | ok
CPU0_C3D0        | 0x00              | ok
CPU0_C3D1        | 0x00              | ok
CPU0_C4D0        | 0x00              | ok
DISK0_Status     | 0x00              | ok
DISK1_Status     | 0x00              | ok
DISK2_Status     | 0x00              | ok
DISK3_Status     | 0x00              | ok
DISK4_Status     | 0x00              | ok
DISK5_Status     | 0x00              | ok
DISK6_Status     | 0x00              | ok
DISK7_Status     | 0x00              | ok
DISK8_Status     | 0x00              | ok
DISK9_Status     | 0x00              | ok
DISK10_Status    | 0x00              | ok
BMC_Boot_Up      | 0x00              | ok
ME_FW_Status     | 0x00              | ok
Event_Log        | 0x00              | ok
IPMI_Watchdog    | 0x00              | ok
CPU_ResourceRate | 0 unspecified     | ok
MEM_ResourceRate | 0 unspecified     | ok
HDD_ResourceRate | 0 unspecified     | ok
HDD_Max_Temp     | 35 degrees C      | ok
```

## 3：通过ipmitool修改带外管理IP
```
配置IP地址:
格式： ipmitool lan set 通道ID  ipaddr  IP地址
[root@localhost tmp]# ipmitool lan set 1 ipaddr 10.57.60.91
Setting LAN IP Address to 10.57.60.91

配置子网掩码：
格式： ipmitool lan set 通道ID  netmask  掩码地址
[root@localhost tmp]# ipmitool lan set 1 netmask 255.255.255.0
Setting LAN Subnet Mask to 255.255.255.0

配置网关地址：
格式： ipmitool  lan  set  通道ID  defgw  ipaddr  网关地址
[root@localhost tmp]# ipmitool lan set 1 defgw ipaddr 10.57.60.1
Setting LAN Default Gateway IP to 10.57.60.1

查看网络配置：
格式： ipmitool  lan  print 通道ID
[root@localhost tmp]# ipmitool lan print 1
Set in Progress         : Set Complete
Auth Type Support       : MD5 
Auth Type Enable        : Callback : MD5 
                        : User     : MD5 
                        : Operator : MD5 
                        : Admin    : MD5 
                        : OEM      : MD5 
IP Address Source       : Static Address
IP Address              : 10.57.60.91
Subnet Mask             : 255.255.255.0
MAC Address             : b4:05:5d:8b:8a:bd
SNMP Community String   : AMI
IP Header               : TTL=0x40 Flags=0x40 Precedence=0x00 TOS=0x10
BMC ARP Control         : ARP Responses Enabled, Gratuitous ARP Disabled
Gratituous ARP Intrvl   : 0.0 seconds
Default Gateway IP      : 10.57.60.1
Default Gateway MAC     : 00:00:00:00:00:00
Backup Gateway IP       : 0.0.0.0
Backup Gateway MAC      : 00:00:00:00:00:00
802.1q VLAN ID          : Disabled
802.1q VLAN Priority    : 0
RMCP+ Cipher Suites     : 0,1,2,3,6,7,8,11,12,15,16,17
Cipher Suite Priv Max   : caaaaaaaaaaaXXX
                        :     X=Cipher Suite Unused
                        :     c=CALLBACK
                        :     u=USER
                        :     o=OPERATOR
                        :     a=ADMIN
                        :     O=OEM
Bad Password Threshold  : 3
Invalid password disable: no
Attempt Count Reset Int.: 200
User Lockout Interval   : 300
[root@localhost tmp]#
```

## 4：启动相应驱动模块
```
[root@localhost tmp]# modprobe ipmi_msghandler
[root@localhost tmp]# modprobe ipmi_devintf
[root@localhost tmp]# modprobe ipmi_si
[root@localhost tmp]# modprobe ipmi_poweroff
[root@localhost tmp]# modprobe ipmi_watchdog
[root@localhost tmp]# 
[root@localhost tmp]# 
[root@localhost tmp]# lsmod |grep ^ipmi
ipmi_watchdog          32768  0
ipmi_poweroff          16384  0
ipmi_ssif              32768  0
ipmi_si                65536  2
ipmi_devintf           20480  0
ipmi_msghandler       110592  5 ipmi_devintf,ipmi_si,ipmi_watchdog,ipmi_ssif,ipmi_poweroff
```

## 5：ipmitool 电源管理
```
ipmitool -I lanplus -H 192.168.205.143 -U admin -P 密码 power off (硬关机，直接切断电源)
										  
ipmitool -I lanplus -H 192.168.205.143 -U admin -P 密码 power soft (软关机，即如同轻按一下开机按钮)
										  
ipmitool -I lanplus -H 192.168.205.143 -U admin -P 密码 power on (硬开机)
										  
ipmitool -I lanplus -H 192.168.205.143 -U admin -P 密码 power reset (硬重启)
										  
ipmitool -I lanplus -H 192.168.205.143 -U admin -P 密码 power status (获取当前电源状态)
										  
ipmitool -I lanplus -H 192.168.205.143 -U admin -P 密码 chassis power cycle
```
(注意power cycle 和power reset的区别在于前者从掉电到上电有１秒钟的间隔，而后者是很快上电)

## 6：重置服务器BMC IP地址

问题描述：我们在日常运维管理中,浪潮服务器经常出现带外管理无法登录，需要重置BMC
```
ipmitool -I lanplus -H 192.168.205.143 -U admin -P admin mc reset cold
```

## 7:用户配置管理
```
1、查看用户清单
ipmitool user list 1
ID  Name	     Callin  Link Auth	IPMI Msg   Channel Priv Limit
1   ADMIN         false    false      true       ADMINISTRATOR

2、创建用户：
格式： ipmitool user set name 用户ID  用户名
root@master:~# ipmitool user set name 3 aaa
root@master:~# ipmitool user list 1
ID  Name	     Callin  Link Auth	IPMI Msg   Channel Priv Limit
3   aaa           true    false      false      Unknown (0x00)

3、设置密码：
格式： ipmitool user set password  用户ID号  密码
root@master:~# ipmitool user set password 3 123.com
Set User Password command successful (user 3)

4、给用户权限
格式：ipmitool channel setaccess 1 用户ID callin=on ipmi=on link=on privilege=值
 【on为开启、off为关闭，是该用户对于通道的权限】

privilege的值：
1 callback 
2 user 
3 operator 
4 administrator 
5 OEM

eg：
# ipmitool channel setaccess 1 3 callin=on ipmi=on link=on privilege=4
Set User Access (channel 1 id 3) successful.

查看 用户id 为3的用户的情况：
# ipmitool user list 1
ID  Name	     Callin  Link Auth	IPMI Msg   Channel Priv Limit
1                    true    false      false      Unknown (0x00)
2   ADMIN            false   false      true       ADMINISTRATOR
3   aaa              true    true       true       ADMINISTRATOR

5、查看授权：
格式：ipmitool channel getaccess 1  用户ID
# ipmitool channel getaccess  1 3
Maximum User IDs     : 10
Enabled User IDs     : 2

User ID              : 3
User Name            : aaa
Fixed Name           : No
Access Available     : callback
Link Authentication  : disabled
IPMI Messaging       : disabled
Privilege Level      : ADMINISTRATOR
```

## 8：IPMItool命令备忘单

| IPMItool命令 | 描述 |
|-------------|-------|
| ipmitool help | 显示IPMItool的帮助信息 |
| ipmitool mc info | 检查固件版本 |
| ipmitool mc reset [warm/cold] | 重置管理控制器 |
| ipmitool fru print | 显示字段可替换单元的详细信息 |

| 传感器输出命令 | 描述 |
|---------------|-------|
| ipmitool sdr list | 列出系统上的所有传感器名称。每个传感器将映射到其相应的传感器编号 |
| ipmitool sdr type list | 列出系统上的所有传感器类型。 |
| ipmitool sdr type Fan | 列出系统上的所有风扇类型传感器。 |
| ipmitool sdr type "Power Supply" | 列出系统上的所有电源类型传感器。 |
| ipmitool sdr type Temperature | 列出系统上的所有温度类型传感器。 |

| 机箱IPMItoll命令 | 描述 |
|------------------|------|
| ipmitool chassis status ipmitool chassis identify [] | 打开前面板识别灯 |
| ipmitool [chassis] power soft | 通过acpi进行软关机 |
| ipmitool [chassis] power cycle | 强制关闭电源，等待1秒然后再打开电源的组合 |
| ipmitool [chassis] power off | 硬断电 |
| ipmitool [chassis] power on | 硬启动 |
| ipmitool [chassis] power reset | 硬重置 |

| 修改启动设备 | 描述 |
|--------------|------|
| ipmitool chassis bootdev pxe | 修改启动顺序以首先启动pxe |
| ipmitool chassis bootdev cdrom | 修改启动顺序以首先启动cdrom |
| ipmitool chassis bootdev bios | 修改引导顺序以首先引导BIOS |

| 记录IPMItools命令 | 描述 |
|------------------|-------|
| ipmitool sel info | 返回有关系统事件日志的常规信息 |
| ipmitool sel list | 返回系统事件日志列表 |
| ipmitool sel elist | 返回与传感器数据日志交叉引用的系统事件日志的列表 |
| ipmitool sel get *ID* | 返回有关特定事件日志的详细信息（使用事件ID指定哪个日志） |
| ipmitool sel clear | 清除事件日志 |
