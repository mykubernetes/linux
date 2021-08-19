MegaCli RAID管理工具
===

RAID管理工具MegaCli常用命令汇总

在服务器硬件运维领域ipmitool和megacli这两款硬件维护工具，俗称业内“倚天剑”和“屠龙刀”，这篇博客就简单介绍一下Megacli阵列卡管理工具。当然除了megacli，在Linux 系统下还有很多的Raid卡管理工具，如HP 官方为HP 服务器提供的hpacucli、hpssacli、ssacli，还有一些工具如：ARCCONF 、StorCLI 等，大家可以自行查阅。

一. MegaCli简介
---

MegaCli是由LSI原厂提供的LSI，MegaCli是一款管理维护硬件RAID的软件，可以通过它来了解当前raid卡的所有信息，包括 raid卡的型号，raid的阵列类型，raid 上物理磁盘和逻辑盘状态，等等。通常，我们在操作系统下对硬盘当前的状态不太好确定，一般通过登录硬件管理口或机房巡检发现故障。而MegaCli可以做到在操作系统下查看阵列卡相关信息，一般通过 MegaCli 的Media Error Count: 0 Other Error Count: 0 这两个数值来确定阵列中磁盘是否有问题;Medai Error Count 表示磁盘可能错误，可能是磁盘有坏道，这个值不为0值得注意，数值越大，危险系数越高。Firmware state 表示磁盘状态，需要重点关注。

二. 下载与安装
---
```
1、 MegCli 下载 官网地址：http://docs.avagotech.com/docs/12351587 2、 MegCli 安装

# unzip MegaCLI_8-07-06.zip
# rpm -ivh ./Linux/MegaCli-8.07.06-1.noarch.rpm
# rpm -ql MegaCli
 /opt/MegaRAID/MegaCli/MegaCli
 /opt/MegaRAID/MegaCli/MegaCli64
 /opt/MegaRAID/MegaCli/libstorelibir-2.so.13.05-0
# ln -s /opt/MegaRAID/MegaCli/MegaCli64 /bin/MegaCli64
```
说明：安装完毕之后MegaCli64所在路径为/opt/MegaRAID/MegaCli/MegaCli64，需要输入全路径才能运行MegaCli64工具，如果嫌麻烦可以做一个软连接到 /bin//MegaCli64，这样就可以直接运行了。

三、命令详解
---
常用命令总结
```
/opt/MegaRAID/MegaCli/MegaCli64 -FwTermLog -Dsply -aALL 　                  【查raid卡日志】
/opt/MegaRAID/MegaCli/MegaCli64 -adpCount                                   【显示适配器个数】
/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aAll                           【显示所有适配器信息】
/opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -LALL -aAll                         【显示所有逻辑磁盘组信息】
/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aAll                               【显示所有的物理信息】
/opt/MegaRAID/MegaCli/MegaCli64 -AdpGetTime –aALL                           【显示适配器时间】
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -aAll 　                         【查电池信息】
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL |grep ‘Charger Status’        【查看充电状态】
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL              【显示BBU状态信息】
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuCapacityInfo -aALL        【显示BBU容量信息】
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuDesignInfo -aALL          【显示BBU设计参数】
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuProperties -aALL          【显示当前BBU属性】
/opt/MegaRAID/MegaCli/MegaCli64 -cfgdsply -aALL                             【显示Raid卡型号，Raid设置，Disk相关信息】
```

1、查raid卡信息(生产商、电池信息及所支持的raid级别)
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aALL |grep -E "Product Name|BBU|Memory Size|RAID Level Supported"
```

2、查看raid卡日志
```
/opt/MegaRAID/MegaCli/MegaCli64 -FwTermLog -Dsply -aALL
```

3、显示适配器个数
```
/opt/MegaRAID/MegaCli/MegaCli64 -adpCount
```
4、显示适配器时间
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpGetTime –aALL
```

5、显示所有适配器信息
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aAll
```

6、显示所有逻辑磁盘组信息
```
/opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -LALL -aAll
```

7、查看所有硬盘的状态
```
/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aAll -NoLog
```

8、查看所有Virtual Disk的状态
```
/opt/MegaRAID/MegaCli/MegaCli64 -LdPdInfo -aAll -NoLog
```

9、查看虚拟化(vd)和物理盘(pd)的信息，比如查看物理硬盘数，是否有硬盘offline或者degraded
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aALL |grep -E "Device Present" -A9
```

10、查看硬盘是否online
```
/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL |grep "Firmware state"
```

11、查看硬盘是否存在物理错误(error不为0，可能会有硬盘故障即将发生)
```
/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL |grep -i error
```

12、查看电池信息(电池类型、电池状态、充电状态、温度等)
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -aAll
```

13、显示所有逻辑磁盘组信息(做了几组raid，raid cache的默认和当前策略，做好raid后的虚拟盘容量)
```
/opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -LALL -aAll
```

14、显示所有物理盘(物理磁盘个数、大小、是否存在error)
```
/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aAll
```

15、显示所有物理盘物理错误
```
/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aAll |grep -i error
```

16、查看充电状态
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL |grep 'Charger Status'
```

17、显示BBU状态信息，比如电池是否,如果issohgood为Yes为正常，No为异常
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL|grep -i issohgood
```

18、显示BBU状态信息
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL
```

19、显示BBU容量信息
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuCapacityInfo -aALL
```

20、显示BBU设计参数
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuDesignInfo -aALL
```

21、显示当前BBU属性
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuProperties -aALL
```

22、显示Raid卡型号，cache大小、Raid设置，cache策略、Disk相关信息
```
/opt/MegaRAID/MegaCli/MegaCli64 -cfgdsply -aALL |egrep "PDs|VDs|Product Name|Memory|BBU:"
```

23、查看磁盘缓存策略(查看vd的)
```
/opt/MegaRAID/MegaCli/MegaCli64 -LDGetProp -Cache -LALL -aALL
```

24、关闭缓存
```
# megacli -LDSetProp -DisDskCache -L0 -a0
```
或者(查看pd的)
```
/opt/MegaRAID/MegaCli/MegaCli64 -LDGetProp -DskCache -LALL -aALL
```
缓存策略解释：
```
WT (Write through
WB (Write back)
NORA (No read ahead)
RA (Read ahead)
ADRA (Adaptive read ahead)
Cached
Direct
```

25、磁带状态的变化，从拔盘，到插盘的过程中：
```
Device |Normal|Damage|Rebuild|Normal
Virtual Drive |Optimal|Degraded|Degraded|Optimal
Physical Drive |Online|Failed –> Unconfigured|Rebuild|Online
```

26、RAID Level对应关系：
```
RAID Level : Primary-1, Secondary-0, RAID Level Qualifier-0 RAID1
RAID Level : Primary-0, Secondary-0, RAID Level Qualifier-0 RAID0
RAID Level : Primary-5, Secondary-0, RAID Level Qualifier-3 RAID5
RAID Level : Primary-1, Secondary-3, RAID Level Qualifier-0 RAID10
```

27、查看物理磁盘重建（Rebuid）进度
```
/opt/MegaRAID/MegaCli/MegaCli64 -PDRbld -ShowProg -PhysDrv [1:5] -a0
```

28、或者以动态可视化文字界面显示
```
/opt/MegaRAID/MegaCli/MegaCli64 -PDRbld -ProgDsply -PhysDrv [1:5] -a0
```

29、设置rebuild的速率
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpSetProp RebuildRate -30 -a0
```

30、手动开启rebuid
```
/opt/MegaRAID/MegaCli/MegaCli64 -pdrbld -start -physdrv[12:10] -a0
```

31、关闭Rebuild
```
/opt/MegaRAID/MegaCli/MegaCli64 -AdpAutoRbld -Dsbl -a0
```

32、查看E S
```
/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aAll -NoLog | grep -Ei "(enclosure|slot)"
```

33、在线做Raid
```
/opt/MegaRAID/MegaCli/MegaCli64 -CfgLdAdd -r0[0:11] WB NORA Direct CachedBadBBU -strpsz64 -a0 -NoLog
/opt/MegaRAID/MegaCli/MegaCli64 -CfgLdAdd -r5 [12:2,12:3,12:4,12:5,12:6,12:7] WB Direct -a0
```

34、点亮指定硬盘(定位)
```
/opt/MegaRAID/MegaCli/MegaCli64 -PdLocate -start -physdrv[252:2] -a0
```

35、清除Foreign状态
```
/opt/MegaRAID/MegaCli/MegaCli64 -CfgForeign -Clear -a0
```

36、查看RAID阵列中掉线的盘
```
/opt/MegaRAID/MegaCli/MegaCli64 -pdgetmissing -a0
```

37、替换坏掉的模块
```
/opt/MegaRAID/MegaCli/MegaCli64 -pdreplacemissing -physdrv[12:10] -Array5 -row0 -a0
```

38、查看Megacli的log
```
/opt/MegaRAID/MegaCli/MegaCli64 -FwTermLog dsply -a0 > adp2.log
```

49、设置HotSpare
```
/opt/MegaRAID/MegaCli/MegaCli64 -pdhsp -set [-Dedicated [-Array2]] [-EnclAffinity] [-nonRevertible] -PhysDrv[4:11] -a0
/opt/MegaRAID/MegaCli/MegaCli64 -pdhsp -set [-EnclAffinity] [-nonRevertible] -PhysDrv[32：1}] -a0
```

40、创建一个 raid5 阵列，由物理盘 2,3 4 构成，该阵列的热备盘是物理盘 5
```
/opt/MegaRAID/MegaCli/MegaCli64-CfgLdA d -r5 [1:2,1:3,1:4] WB Direct -Hsp[1:5] -a0
```

41、创建阵列，不指定热备
```
/opt/MegaRAID/MegaCli/MegaCli64-CfgLdA d -r5 [1:2,1:3,1:4] WB Direct -a0
```

42、删除阵列
```
/opt/MegaRAID/MegaCli/MegaCli64-CfgLdDel -L1 -a0
```

43、在线添加磁盘
```
/opt/MegaRAID/MegaCli/MegaCli64-LDRecon -Star - 5 Ad -PhysDrv[1:4] -L1 -a0
```

44、阵列创建完后，会有一个初始化同步块的过程，可以看 其进度。
```
/opt/MegaRAID/MegaCli/MegaCli64-LDInit -ShowProg -LA L -aAL或者以动态可视化文字界面显示
/opt/MegaRAID/MegaCli/MegaCli64-LDInit -ProgDsply -LA L -aAL
```

45、查看阵列后台初始化进度
```
/opt/MegaRAID/MegaCli/MegaCli64 -LDBI -ShowProg -LALL -aAL
```

46、或者以动态可视化文字界面显示
```
/opt/MegaRAID/MegaCli/MegaCli64 -LDBI -ProgDsply -LALL -aAL
```

47、指定第 5 块盘作为全局热备
```
/opt/MegaRAID/MegaCli/MegaCli64-PDHSP -Set [-EnclAf in ty] [-no Rev rtible] -PhysDrv[1:5] -a0
```

48、指定为某个阵列的专用热备
```
/opt/MegaRAID/MegaCli/MegaCli64-PDHSP -Set [-Dedicated [-Ar ay1] [-EnclAf in ty] [-no Rev rtible] -PhysDrv[1:5] -a0
```

49、删除全局热备
```
/opt/MegaRAID/MegaCli/MegaCli64-PDHSP -Rmv -PhysDrv[1:5] -a0
```

50、将某块物理盘下线/上线
```
/opt/MegaRAID/MegaCli/MegaCli64-PDOf line -PhysDrv [1:4] -a0
/opt/MegaRAID/MegaCli/MegaCli64-PDOnli e -PhysDrv [1:4] -a0
```

51、查看当前raid缓存状态，raid缓存状态设置为wb的话要注意电池放电事宜，设置电池放电模式为自动学习模式
```
/opt/MegaRAID/MegaCli/MegaCli64   -ldgetprop  -dskcache -lall  -aall
```

raid 电池设置相关#
---

1、查看电池状态信息(Display BBU Status Information)
```
MegaCli -AdpBbuCmd -GetBbuStatus -aN|-a0,1,2|-aALL
MegaCli -AdpBbuCmd -GetBbuStatus -aALL
```

2、查看电池容量（Display BBU Capacity Information）
```
MegaCli -AdpBbuCmd -GetBbuCapacityInfo -aN|-a0,1,2|-aALL
MegaCli -AdpBbuCmd -GetBbuCapacityInfo –aALL
```

3、查看电池设计参数(Display BBU Design Parameters)
```
MegaCli -AdpBbuCmd -GetBbuDesignInfo -aN|-a0,1,2|-aALL
MegaCli -AdpBbuCmd -GetBbuDesignInfo –aALL
```

4、查看电池属性（Display Current BBU Properties）
```
MegaCli -AdpBbuCmd -GetBbuProperties -aN|-a0,1,2|-aALL
MegaCli -AdpBbuCmd -GetBbuProperties –aALL
```

5、设置电池为学习模式为循环模式（Start BBU Learning Cycle）
```
Description Starts the learning cycle on the BBU.
No parameter is needed for this option.
MegaCli -AdpBbuCmd -BbuLearn -aN|-a0,1,2|-aALL
```

设置磁盘的缓存模式和访问方式 （Change Virtual Disk Cache and Access Parameters）
```
Description Allows you to change the following virtual disk parameters:
-WT (Write through), WB (Write back): Selects write policy.
-NORA (No read ahead), RA (Read ahead), ADRA (Adaptive read ahead): Selects read policy.
-Cached, -Direct: Selects cache policy.
-RW, -RO, Blocked: Selects access policy.
-EnDskCache: Enables disk cache.
-DisDskCache: Disables disk cache.
MegaCli -LDSetProp { WT | WB|NORA |RA | ADRA|-Cached|Direct} |
{-RW|RO|Blocked} |
{-Name[string]} |
{-EnDskCache|DisDskCache} –Lx |
-L0,1,2|-Lall -aN|-a0,1,2|-aALL
MegaCli -LDSetProp WT -L0 -a0
```

显示磁盘缓存和访问方式（Display Virtual Disk Cache and Access Parameters）
```
MegaCli -LDGetProp -Cache | -Access | -Name | -DskCache -Lx|-L0,1,2|
-Lall -aN|-a0,1,2|-aALL
Displays the cache and access policies of the virtual disk(s):
-WT (Write through), WB (Write back): Selects write policy.
-NORA (No read ahead), RA (Read ahead), ADRA (Adaptive read ahead): Selects read policy.
-Cache, -Cached, Direct: Displays cache policy.
-Access, -RW, -RO, Blocked: Displays access policy.
-DskCache: Displays physical disk cache policy.
```

Megaraid 必知必会 使用LSI的megaraid可以对raid进行有效监控。别的厂商比如HP,IBM也有自己的raid API
```
MegaCli -ldinfo -lall -aall
```

查询raid级别，磁盘数量，容量，条带大小。
```
MegaCli -cfgdsply -aALL |grep Policy
```

查询控制器cache策略
```
MegaCli -LDSetProp WB -L0 -a0
```

设置write back功能
```
MegaCli -LDSetProp CachedBadBBU -L0 -a0
```

设置即使电池坏了还是保持WB功能
```
MegaCli -AdpBbuCmd -BbuLearn a0
```

手动充电
```
MegaCli -FwTermLog -Dsply -aALL
```

参考：

https://idc.wanyunshuju.com/cym/646.html

http://blog.itpub.net/69926532/viewspace-2647730/

https://www.jianshu.com/p/dcfd4bfba207
