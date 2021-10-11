# MegaCli常用命令

1，查看磁盘缓存策略
```
# /opt/MegaRAID/MegaCli/MegaCli64 -LDGetProp -Cache -LAll -aAll
                                     
Adapter 0-VD 0(target id: 0): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
Adapter 0-VD 1(target id: 1): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
Adapter 0-VD 2(target id: 2): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
Adapter 0-VD 3(target id: 3): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
Adapter 0-VD 4(target id: 4): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
Adapter 0-VD 5(target id: 5): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
Adapter 0-VD 6(target id: 6): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
Adapter 0-VD 7(target id: 7): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
Adapter 0-VD 8(target id: 8): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
Adapter 0-VD 9(target id: 9): Cache Policy:WriteThrough, ReadAheadNone, Direct, No Write Cache if bad BBU
```

2，定位磁盘，可定位多个磁盘如physdrv[0:4,0:5,0:6]
```
# /opt/MegaRAID/MegaCli/MegaCli64 -PdLocate -start physdrv[0:4] -a0
Adapter: 0: Device at EnclId-0 SlotId-4  -- PD Locate Start Command was successfully sent to Firmware 

# /opt/MegaRAID/MegaCli/MegaCli64 -PdLocate -stop physdrv[0:4] -a0                    
Adapter: 0: Device at EnclId-0 SlotId-4  -- PD Locate Stop Command was successfully sent to Firmware 
```

3，删除RAID
```
# /opt/MegaRAID/MegaCli/MegaCli64 -cfglddel -L4 -a0
Adapter 0: Deleted Virtual Drive-4(target id-4)

# /opt/MegaRAID/MegaCli/MegaCli64 -cfglddel -L5,6,7,8,9,10,11 -a0
Adapter 0: Deleted Virtual Drive-5(target id-5)
Adapter 0: Deleted Virtual Drive-6(target id-6)
Adapter 0: Deleted Virtual Drive-7(target id-7)
Adapter 0: Deleted Virtual Drive-8(target id-8)
Adapter 0: Deleted Virtual Drive-9(target id-9)
Adapter 0: Deleted Virtual Drive-10(target id-10)
Adapter 0: Deleted Virtual Drive-11(target id-11)
```

4，创建RAID5
```
[root@backupServer ~]# /opt/MegaRAID/MegaCli/MegaCli64 -cfgldadd -r5 [0:4,0:5,0:6] -a0
Adapter 0: Created VD 4
Adapter 0: Configured the Adapter!!

#给刚才创建的RAID5加一块磁盘
root@backupServer ~]# /opt/MegaRAID/MegaCli/MegaCli64 -ldrecon -start -r5 -add -physdrv[0:7] -l4 -a0
Start Reconstruction of Virtual Drive Success.

# 创建RAID5，并指定0:11盘为热备盘
# /opt/MegaRAID/MegaCli/MegaCli64 cfgldadd -r5 [0:4,0:5,0:6,0:7,0:8,0:9,0:10] -hsp [0:11] -a0
Adapter 0: Created VD 4
Adapter: 0: Set Physical Drive at EnclId-0 SlotId-11 as Hot Spare Success.

Adapter 0: Configured the Adapter!!


# /opt/MegaRAID/MegaCli/MegaCli64 -cfgdsply -a0
DISK GROUP: 4
Number of Spans: 1
SPAN: 0
Span Reference: 0x04
Number of PDs: 7
Number of VDs: 1
Number of dedicated Hotspares: 1
Virtual Drive Information:
Virtual Drive: 4 (Target Id: 4)
Name                :
RAID Level          : Primary-5, Secondary-0, RAID Level Qualifier-3
Size                : 21.829 TB
Is VD emulated      : No
Parity Size         : 3.637 TB
State               : Optimal
Strip Size          : 256 KB
Number Of Drives    : 7
Span Depth          : 1
Default Cache Policy: WriteThrough, ReadAheadNone, Direct, No Write Cache if Bad BBU
Current Cache Policy: WriteThrough, ReadAheadNone, Direct, No Write Cache if Bad BBU
Default Access Policy: Read/Write
Current Access Policy: Read/Write
Disk Cache Policy   : Disk's Default
Encryption Type     : None
Bad Blocks Exist: No
PI type: No PI

Is VD Cached: No
Physical Disk Information:
Physical Disk: 0
Enclosure Device ID: 0
Slot Number: 4
Drive's postion: DiskGroup: 4, Span: 0, Arm: 0
Enclosure position: N/A
Device Id: 29
WWN: 5000c50086ee9fa0
Sequence Number: 6
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SATA
```

查看重建进度
```
# /opt/MegaRAID/MegaCli/MegaCli64 pdrbld -showprog -physdrv [0:7] -a0
Device(Encl-0 Slot-7) is not in rebuild process
```

查看后台初始化进度
```
# /opt/MegaRAID/MegaCli/MegaCli64 -LDBI -ShowProg -LALL -aALL
Background Initialization on VD #0 is not in Progress.
Background Initialization on VD #1 is not in Progress.
Background Initialization on VD #2 is not in Progress.
Background Initialization on VD #3 is not in Progress.
Background Initialization on VD #4 (target id #4) Complete 0% in 0 Minutes.
```

查看初始化同步进度
```
# /opt/MegaRAID/MegaCli/MegaCli64 -LDInit -ShowProg -LALL -aALL
Initialization on VD #0 is not in progress.
Initialization on VD #1 is not in progress.
Initialization on VD #2 is not in progress.
Initialization on VD #3 is not in progress.
Initialization on VD #4 is not in progress.
```

查看配置
```
# /opt/MegaRAID/MegaCli/MegaCli64 -cfgdsply  -a0
DISK GROUP: 4
Number of Spans: 1
SPAN: 0
Span Reference: 0x04
Number of PDs: 3
Number of VDs: 1
Number of dedicated Hotspares: 0
Virtual Drive Information:
Virtual Drive: 4 (Target Id: 4)
Name                :
RAID Level          : Primary-5, Secondary-0, RAID Level Qualifier-3
Size                : 7.276 TB
Is VD emulated      : No
Parity Size         : 3.637 TB
State               : Optimal
Strip Size          : 256 KB
Number Of Drives    : 3
Span Depth          : 1
Default Cache Policy: WriteThrough, ReadAheadNone, Direct, No Write Cache if Bad BBU
Current Cache Policy: WriteThrough, ReadAheadNone, Cached, No Write Cache if Bad BBU
Default Access Policy: Read/Write
Current Access Policy: Read/Write
Disk Cache Policy   : Disk's Default
Ongoing Progresses:
  Reconstruction           : Completed 0%, Taken 26 min.
Encryption Type     : None
Bad Blocks Exist: No
PI type: No PI

Is VD Cached: No
Physical Disk Information:
Physical Disk: 0
Enclosure Device ID: 0
Slot Number: 4
Drive's postion: DiskGroup: 4, Span: 0, Arm: 0
Enclosure position: N/A
Device Id: 29
WWN: 5000c50086ee9fa0
Sequence Number: 4
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SATA
```

查看日志
```
# /opt/MegaRAID/MegaCli/MegaCli64 -fwtermlog -dsply -a0
```

查看重建进度
```
# /opt/MegaRAID/MegaCli/MegaCli64 pdrbld -showprog -physdrv [0:5] -a0
其它
/opt/MegaRAID/MegaCli/MegaCli64 -PDMakeGood -PhysDrv[252:1] -a0
/opt/MegaRAID/MegaCli/MegaCli64 -AdpGetProp -enablejbod -aALL // 查看 jobd 模式是否启用
/opt/MegaRAID/MegaCli/MegaCli64 -AdpSetProp -EnableJBOD -1  -a0 // 启用 jbod 模式
/opt/MegaRAID/MegaCli/MegaCli64 -PDMakeJBOD -PhysDrv[252:1] -a0  // 设置磁盘为 jbod 模式
```
