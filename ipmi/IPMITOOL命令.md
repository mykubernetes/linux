# IPMITOOL命令支持列表V2.0

## User

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` user summary | 查询用户概要信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` user list | 查询BMC上所有用户 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` user set name `<用户ID>` `<用户名>` | 设置用户名 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` user set password `<用户ID>` `<密码>` | 设置用户密码 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` user enable `<用户ID>` | 使用用户 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` user disable `<用户ID>` | 禁用用户 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` user priv `<用户ID>` `<级别>` | 设置用户权限 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` user test `<16 or 20>` `<密码>` | 用户密码测试 |

## Channel

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` channel info `<channel>` | 获取通道信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` channel authcap `<channel number>` `<max privilege>` | 获取通道认证鉴权能力 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` channel getaccess `<channel number>` `[user id]` | 获取用户权限信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` channel setaccess `<channel number>` `<user id>` `[privilege=level]` | 设置用户权限信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` channel getciphers `<ipmi or sol>` `<channel>` | 获取通道的加密法套件 |

## Lan

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan print 1 | 打印Lan 参数配置信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan set `<channel>` ipaddr `<IP地址>` | 设置通道IP地址 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan set `<channel>` netmask `<IP地址>` | 设置通道子掩码
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan set `<channel>` macaddr `<*:*:*:*:*:*>` | 设置通道mac地址 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan set `<channel>` defgw ipaddr `<IP地址>` | 设置通道默认网关IP |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan set `<channel>` snmp `<团体名>` | 设置snmp团体名 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan set `<channel>` access `<on>` | 通道对于IPMI 消息的访问模式 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan set `<channel>` vlan id `<off or <id>` | 使能、禁用虚拟局域网(Virtual Local Area Network)，设置ID |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan set `<channel>` auth `<level>` `<type,..>` | 设置通道认证类型 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan alert print `<channel number>` `<alert destination>` | 打印告警信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan alert set `<channel number>` `<alert destination>` ipaddr `<x.x.x.x>` | 设置告警ip地址 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan alert set `<channel number>` `<alert destination>` macaddr `<x:x:x:x:x:x>` | 设置告警mac地址 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` lan alert set `<channel number>` `<alert destination>` type `<pet or oem1>` | 设置目的地址类型，PET或者OEM |

## SOL

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol info | 显示SOL参数配置信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol activate | 建立SOL会话 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol deactivate | 去激活SOL会话 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol set enabled `<true or false>` `<channel>` | 设置SOL通道1使能状态 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol set set-in-progress `<set-complete or set-in-progress or commit-write>` | 设置SOL参数状态 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol set force-encryption `<true or false>` | 设置SOL负载是否强制加密 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol set force-authentication `<true or false>` | 设置SOL负载是否强制认证 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol set privilege-level `<user or operator or admin or oem>` | 设置建立SOL会话的最低权限级别 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol set character-accumulate-level `<level>` | 设置SOL字符发送间隔，一个单位为5 ms |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol set character-send-threshold `<bytes>` | 设置SOL字符门限(32字节) |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol set retry-count `<count>` | 设置SOL重发次数 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol set retry-interval `<interval>` | 设置SOL重发时间间隔（一个单位为10 ms） |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol payload `<enable or disable>` `<channel>` `<用户ID>` | 设置用户对负载的访问权限（和命令参数名不一致） |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` sol looptest `<loop-times>` `<loop-interval>` | SOL连接压力测试 |

## BMC

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` mc reset `<warm or cold>` | BMC执行热（冷）复位 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` mc guid | 查询BMC guid信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` mc info | 查询BMC的版本信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` mc watchdog `<get or reset or off>` | 设置和查询BMC看门狗状态 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` mc selftest | 查询BMC自测试结果 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` mc getenables | 显示目前BMC已经使能的选项的信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` mc setenables `<system_event_log or event_msg or event_msg_intr or oem0 or oem1 or oem2>` `<on or off>` | 设置BMC使能的选项的信息 |

## Chassis

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` chassis status | 获取设置底板电源状态信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` chassis power `<status or on or off or reset or cycle or soft>` | 设置底板电源状态 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` chassis identify | 控制前插板指示灯亮 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` chassis policy `<list or always-on or always-off or previous>` | 设置单板底板在上电失败后的处理方案 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` chassis restart_cause | 查询单板最后一次重起的原因 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` chassis bootdev `<none or pxe or disk or cdrom or floppy>` | 设置单板下一次启动的启动顺序 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` chassis bootparam set bootflag `<force_pxe or force_disk or force_cdrom or force_bios>` |  |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` chassis selftest |  |

## Event

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>` event `<1 or 2 or 3>` | 发送预先定义好的系统事件的编号给单板，可以支持以下3种事件 1 温度过高告警 2 电压过低告警 3 内存ECC错误 |

## FRU

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  fru | 查询 FRU 等制造信息 |

## SDR

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  sdr info | 查询SDR 的相关信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  sdr list `<all or full or compact or event or mcloc or fru or generic>` | 获取传感器信息 |

## SEL

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  sel info | 显示日志的相关信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  sel clear | 清除BMC上的BMCSEL |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  sel list | 按照指定格式显示日志信息 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  sel get `<id>` | 显示某一条日志 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  sel save `<filename>` | 将日志保存到文件 |

## Sensor

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  sensor list | 查询传感器信息 |

## Power

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  power status | 查询电源状态 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  power on | 上电 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  power off |下电 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  power cycle |循环上下电 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  power reset |复位 |
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  power soft |  |

## Raw

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  raw `<netfn>` `<cmd>` `[data]` | 发送原始命令 |

## PEF

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  pef `<info or status or policy or list>` |  |

## Session

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  session info `<active >` | get information regarding which users ,presently have active sessions |

## Exec
| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  exec `<filename>` |  |

## Set

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H `<IP地址>` -I lanplus -U `<用户名>` -P `<密码>`  shell |  |


  
```
IPMITOOL常用操作指令V1.0
一、开关机，重启

1. 查看开关机状态：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) power status

2. 开机：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) power on

3. 关机：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) power off

4. 重启：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) power reset

 

二、用户管理

说明：[ChannelNo] 字段是可选的，ChannoNo为1或者8；BMC默认有2个用户：user id为1的匿名用户，user id为2的ADMIN用户；<>字段为必选内容；<privilege level>：2为user权限，3为Operator权限，4为Administrator权限；

1. 查看用户信息：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) user list [ChannelNo]

2. 增加用户：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) user set name <user id> <username>

3. 设置密码：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) user set password <user id> <password>

4. 设置用户权限：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) user priv <user id> <privilege level> [ChannelNo]

5. 启用/禁用用户：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) user enable/disable <user id>

 

三、IP网络设置

说明：[ChannelNo] 字段是可选的，ChannoNo为1(Share Nic网络)或者8（BMC独立管理网络）；设置网络参数，必须首先设置IP为静态，然后再进行其他设置；

1. 查看网络信息：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) lan print [ChannelNo]

2. 修改IP为静态还是DHCP模式：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) lan set <ChannelNo> ipsrc <static/dhcp>

3. 修改IP地址：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) lan set <ChannelNo> ipaddr <IPAddress>

4. 修改子网掩码：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) lan set <ChannelNo> netmask <NetMask>

5. 修改默认网关：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) lan set <ChannelNo> defgw ipaddr <默认网关>

 

四、SOL功能

说明：<9.6/19.2/38.4/57.6/115.2>其中115.2代表115200，即*1000是表示的波特率。

1. 设置SOL串口波特率：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) sol set volatile-bit-rate <9.6/19.2/38.4/57.6/115.2>

2. 打开SOL功能：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) sol activate

3. 关闭SOL功能：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) sol deactivate

 

五、SEL日志查看

1. 查看SEL日志：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) sel list

 

六、FRU信息查看

1. 查看FRU信息：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) fru list

 

七、SDR，Sensor信息查看

1. 查看SDR Sensor信息：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) sdr

2. 查看Sensor信息：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) sensor list

 

八、mc(管理单元BMC)状态和控制

1. 重启动BMC：

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) mc reset <warm/cold>

 

九、设置BMC的iptables防火墙

1. 设置某一段IP可以访问BMC

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) raw 0x32 0x76 0x01 0x01 ip1(0xa 0xa 0xa 0xa) ip2(0xb 0xb 0xb 0xb)

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) raw 0x32 0x76 0x09

2. 设置某个IP可以访问BMC

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) raw 0x32 0x76 0x00 0x01 ip1(0xa 0xa 0xa 0xa)

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) raw 0x32 0x76 0x09

3. 取消设置

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) raw 0x32 0x76 0x08

4．获取防火墙设置

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) raw 0x32 0x77 0x01 0x00

5. 阻止/开启某个端口

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) raw 0x32 0x76 0x02 0x00/0x01 0x00 (portno)0x22 0x00

6. 取消某个端口的设置（6是5的对应取消操作）

ipmitool -H (BMC的管理IP地址) -I lanplus -U (BMC登录用户名) -P (BMC 登录用户名的密码) raw 0x32 0x76 0x06 0x00/0x01 0x00 (portno)0x22 0x00
```
