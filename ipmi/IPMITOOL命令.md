# IPMITOOL命令支持列表V2.0

| 命令行格式 | 命令行说明 |
|-----------|------------|
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> user summary | 查询用户概要信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> user list | 查询BMC上所有用户 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> user set name <用户ID> <用户名> | 设置用户名 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> user set password <用户ID> <密码> | 设置用户密码 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> user enable <用户ID> | 使用用户 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> user disable <用户ID> | 禁用用户 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> user priv <用户ID> <级别> | 设置用户权限 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> user test <16|20> <密码> | 用户密码测试 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> channel info <channel> | 获取通道信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> channel authcap <channel number> <max privilege> | 获取通道认证鉴权能力 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> channel getaccess <channel number> [user id] | 获取用户权限信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> channel setaccess <channel number> <user id> [privilege=level] | 设置用户权限信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> channel getciphers <ipmi|sol> <channel> | 获取通道的加密法套件 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan print 1 | 打印Lan 参数配置信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan set <channel> ipaddr <IP地址> | 设置通道IP地址 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan set <channel> netmask <IP地址> | 设置通道子掩码
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan set <channel> macaddr <*:*:*:*:*:*> | 设置通道mac地址 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan set <channel> defgw ipaddr <IP地址> | 设置通道默认网关IP |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan set <channel> snmp <团体名> | 设置snmp团体名 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan set <channel> access <on> | 通道对于IPMI 消息的访问模式 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan set <channel> vlan id <off|<id> | 使能、禁用虚拟局域网(Virtual Local Area Network)，设置ID |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan set <channel> auth <level> <type,..> | 设置通道认证类型 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan alert print <channel number> <alert destination> | 打印告警信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan alert set <channel number> <alert destination> ipaddr <x.x.x.x> | 设置告警ip地址 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan alert set <channel number> <alert destination> macaddr <x:x:x:x:x:x> | 设置告警mac地址 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> lan alert set <channel number> <alert destination> type <pet|oem1> | 设置目的地址类型，PET或者OEM |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol info | 显示SOL参数配置信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol activate | 建立SOL会话 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol deactivate | 去激活SOL会话 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol set enabled <true|false> <channel> | 设置SOL通道1使能状态 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol set set-in-progress <set-complete|set-in-progress|commit-write> | 设置SOL参数状态 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol set force-encryption <true|false> | 设置SOL负载是否强制加密 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol set force-authentication <true|false> | 设置SOL负载是否强制认证 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol set privilege-level <user|operator|admin|oem> | 设置建立SOL会话的最低权限级别 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol set character-accumulate-level <level> | 设置SOL字符发送间隔，一个单位为5 ms |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol set character-send-threshold <bytes> | 设置SOL字符门限(32字节) |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol set retry-count <count> | 设置SOL重发次数 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol set retry-interval <interval> | 设置SOL重发时间间隔（一个单位为10 ms） |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol payload <enable|disable> <channel> <用户ID> | 设置用户对负载的访问权限（和命令参数名不一致） |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> sol looptest <loop-times> <loop-interval> | SOL连接压力测试 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> mc reset <warm|cold> | BMC执行热（冷）复位 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> mc guid | 查询BMC guid信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> mc info | 查询BMC的版本信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> mc watchdog <get|reset|off> | 设置和查询BMC看门狗状态 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> mc selftest | 查询BMC自测试结果 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> mc getenables | 显示目前BMC已经使能的选项的信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> mc setenables <system_event_log|event_msg|event_msg_intr|oem0|oem1|oem2> <on|off> | 设置BMC使能的选项的信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> chassis status | 获取设置底板电源状态信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> chassis power <status|on|off|reset|cycle|soft> | 设置底板电源状态 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> chassis identify | 控制前插板指示灯亮 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> chassis policy <list|always-on|always-off|previous> | 设置单板底板在上电失败后的处理方案 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> chassis restart_cause | 查询单板最后一次重起的原因 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> chassis bootdev <none|pxe|disk|cdrom|floppy> | 设置单板下一次启动的启动顺序 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> chassis bootparam set bootflag <force_pxe|force_disk|force_cdrom|force_bios> |  |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> chassis selftest |  |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码> event <1|2|3> | 发送预先定义好的系统事件的编号给单板，可以支持以下3种事件 1 温度过高告警 2 电压过低告警 3 内存ECC错误 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  fru | 查询 FRU 等制造信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  sdr info | 查询SDR 的相关信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  sdr list <all|full|compact|event|mcloc|fru|generic> | 获取传感器信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  sel info | 显示日志的相关信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  sel clear | 清除BMC上的BMCSEL |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  sel list | 按照指定格式显示日志信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  sel get <id> | 显示某一条日志 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  sel save <filename> | 将日志保存到文件 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  sensor list | 查询传感器信息 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  power status | 查询电源状态 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  power on | 上电 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  power off |下电 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  power cycle |循环上下电 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  power reset |复位 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  power soft |  |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  raw <netfn> <cmd> [data] | 发送原始命令 |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  pef `<info| status |policy |list>` |  |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  session info <active > | get information regarding which users ,presently have active sessions |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  exec <filename> |  |
| ipmitool -H <IP地址> -I lanplus -U <用户名> -P <密码>  shell |  |

　
