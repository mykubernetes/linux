| 命令| 描述 |
|-----|-----|
| -i | 指定设备 |
| -d | 指定设备类型，例如：ata，scsi，marvell，sat，3ware，N |
| -a或A | 显示所有信息 |
| -l | 指定日志类型，例如：TYPE：error，selftest，selecttive，directory，background，scttemp[sts,hist] |
| -H | 查看硬盘健康状态 |
| -t short | 后台检测硬盘，消耗时间短 |
| -t long | 后台检测硬盘，消耗时间长 |
| -C -t short | 前台检测硬盘，消耗时间短 |
| -C -t long | 前台检测硬盘，消耗时间长 |
| -X | 中断后台检测硬盘 |
| -l selftest | 显示硬盘检测日志 |

1、首先应确认硬盘是否打开了SMART支持 smartctl -i /dev/sda
```
# smartctl -i /dev/sda
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-2.6.32-504.16.2.el6.x86_64] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

Vendor:               DELL
Product:              PERC H710P
Revision:             3.13
User Capacity:        1,197,759,004,672 bytes [1.19 TB]
Logical block size:   512 bytes
Logical Unit id:      0x6b083fe0c1c7230020b080c10502c367
Serial number:        0067c30205c180b0200023c7c1e03f08
Device type:          disk
Local Time is:        Tue Dec 22 15:10:01 2020 CST
Device does not support SMART
```
 
2、如果看到不支持这需要我们手动开启支持
```
smartctl --smart=on --offlineauto=on --saveauto=on
```

3、再次执行
```
# smartctl -a /dev/sda
smartctl 5.39 2008-10-24 22:33 [x86_64-suse-linux-gnu] (openSUSE RPM)
Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net

Device: SEAGATE  ST9146803SS      Version: 0006          #硬件厂商
Serial number: 6SD2A3ZZ0000B127LJJM                      #硬盘序列号
Device type: disk
Transport protocol: SAS                                  #接口类型
Local Time is: Fri Mar  4 16:58:30 2016 CST
Device supports SMART and is Enabled                     #是否支持smart管理，有的不支持
Temperature Warning Enabled
SMART Health Status: OK                                  #健康状态ok
Current Drive Temperature:     21 C                      #当前温度
Drive Trip Temperature:        68 C                      #此温度是啥？有待考证
Elements in grown defect list: 0
Vendor (Seagate) cache information
  Blocks sent to initiator = 1044970503
  Blocks received from initiator = 2476401867
  Blocks read from cache and sent to initiator = 106869375
  Number of read and write commands whose size <= segment size = 364621421
  Number of read and write commands whose size > segment size = 0
Vendor (Seagate/Hitachi) factory information
  number of hours powered up = 37638.07
  number of minutes until next internal SMART test = 54

Error counter log:
           Errors Corrected by           Total   Correction     Gigabytes    Total
               ECC          rereads/    errors   algorithm      processed    uncorrected
           fast | delayed   rewrites  corrected  invocations   [10^9 bytes]  errors
read:   15099690        0         0  15099690   15099690       2734.048           0
write:         0        0         0         0          0      71719.613           0
verify:    10434        0         0     10434      10434          0.000           0

Non-medium error count:        0

[GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S on']
No self-tests have been logged
Long (extended) Self Test duration: 3600 seconds [60.0 minutes]
```
