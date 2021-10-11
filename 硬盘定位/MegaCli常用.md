# MegaCli常用命令

1、查看所有物理磁盘信息
```
# MegaCli64 -PDList -aALL
                                     
Adapter #0

Enclosure Device ID: 32
Slot Number: 0
Drive's position: DiskGroup: 0, Span: 0, Arm: 0
Enclosure position: 1
Device Id: 0
WWN: 55cd2e414da1f028
Sequence Number: 2
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SATA

Raw Size: 186.310 GB [49f1b0 Sectors]
Non Coerced Size: 185.810 GB [39f1b0 Sectors]
Coerced Size: 185.75 GB [380000 Sectors]
Sector Size:  512
Logical Sector Size:  512
Physical Sector Size:  4096
Firmware state: Online, Spun Up
Device Firmware Level: DL2D
Shield Counter: 0
Successful diagnostics completion on :  N/A
SAS Address(0): 33221104000000
Connected Port Number: 1(path0) 
Inquiry Data:   BTHC70450621200TGNINTEL SSDSC2BX200G4R                    G201DL2D
........
```

2、查看磁盘缓存策略
```
# MegaCli64 -LDGetProp -Cache -L0 -a0
                          
Adapter 0-VD 0(target id: 0): Cache Policy:WriteBack, ReadAheadNone, Direct, Write Cache OK if bad BBU
```

3、设置磁盘缓存策略

缓存策略解释
```
WT    (Write through 
WB    (Write back) 
ForcedWB (Forced Write back)
NORA  (No read ahead) 
RA    (Read ahead) 
ADRA  (Adaptive read ahead) 
Cached 
Direct
```
例子
```
MegaCli64 -LDSetProp WT|WB|NORA|RA|ADRA -L0 -a0 
or 
MegaCli64 -LDSetProp -Cached|-Direct -L0 -a0 
or 
enable / disable disk cache 
MegaCli64 -LDSetProp -EnDskCache|-DisDskCache -L0 -a0
```

强制回写
```
MegaCli64  -LDSetProp ForcedWB -lall -a0
```

4、创建/删除 阵列

4.1 创建一个 raid5 阵列，由物理盘 2,3,4 构成，该阵列的热备盘是物理盘 5

#Enclosure Device ID: 32 #Slot Number: 0-3
```
MegaCli64 -CfgLdAdd -r5 [32:2,32:3,32:4] WB Direct -Hsp[32:5] -a0
```

4.2 创建阵列，不指定热备
```
MegaCli64 -CfgLdAdd -r5 [32:2,32:3,32:4] WB Direct -a0
```

4.3 删除阵列
```
MegaCli64 -CfgLdDel -L1 -a0
```

4.4 在线添加磁盘
```
MegaCli64 -LDRecon -Start -r5 -Add -PhysDrv[32:4] -L1 -a0
```
意思是，重建逻辑磁盘组1，raid级别是5，添加物理磁盘号：32:4。重建完后，新添加的物理磁盘会自动处于重建(同步)状态，
这个时候fdisk -l是看不到阵列的空间变大的，只有在系统重启后才能看见。

5、查看阵列初始化信息

5.1 阵列创建完后，会有一个初始化同步块的过程，可以看看其进度。
```
MegaCli64 -LDInit -ShowProg -LALL -aALL
```

或者以动态可视化文字界面显示
```
MegaCli64 -LDInit -ProgDsply -LALL -aALL
```

5.2 查看阵列后台初始化进度
```
MegaCli64 -LDBI -ShowProg -LALL -aALL
```

或者以动态可视化文字界面显示
```
MegaCli64 -LDBI -ProgDsply -LALL -aALL
```

6、创建全局热备

指定第 5 块盘作为全局热备
```
MegaCli64 -PDHSP -Set [-EnclAffinity] [-nonRevertible] -PhysDrv[32:5] -a0
```
也可以指定为某个阵列的专用热备
```
MegaCli64 -PDHSP -Set [-Dedicated [-Array1]] [-EnclAffinity] [-nonRevertible] -PhysDrv[32:5] -a0
```

7、删除全局热备
```
MegaCli64 -PDHSP -Rmv -PhysDrv[32:5] -a0
```

8、将某块物理盘下线/上线
```
MegaCli64 -PDOffline -PhysDrv [32:4] -a0 
MegaCli64 -PDOnline -PhysDrv [32:4] -a0
```

9、查看物理磁盘重建进度
```
MegaCli64 -PDRbld -ShowProg -PhysDrv [32:5] -a0
```

10、命令汇总
```
查看Cache 策略设置    # MegaCli64 -cfgdsply -aALL |grep Policy
查询Raid阵列数    # MegaCli64 -cfgdsply -aALL |grep "Number of DISK GROUPS:"
显示Raid卡型号，Raid设置，Disk相关信息      # MegaCli64 -cfgdsply -aALL
显示所有适配器信息    # MegaCli64 -AdpAllInfo -aAll
显示所有物理信息    # MegaCli64 -PDList -aALL
显示所有逻辑磁盘组信息    # MegaCli64 -LDInfo -LALL -aAll
查看物理磁盘重建进度(重要)    # MegaCli64 -PDRbld -ShowProg -PhysDrv [32:5] -a0
查看适配器个数    # MegaCli64 -adpCount
查看适配器时间    # MegaCli64 -AdpGetTime -aALL
查看raid卡日志    # MegaCli64 -FwTermLog -Dsply -aALL

显示BBU状态信息    # MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL
显示BBU容量信息    # MegaCli64 -AdpBbuCmd -GetBbuCapacityInfo -aALL
显示BBU设计参数    # MegaCli64 -AdpBbuCmd -GetBbuDesignInfo -aALL
显示当前BBU属性    # MegaCli64 -AdpBbuCmd -GetBbuProperties -aALL
查看充电进度百分比    # MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL |grep "Relative State of Charge"
```

JBOD

查看JBOD状态
```
MegaCli64 -AdpGetProp -enablejbod -aALL

Adapter 0: JBOD: Disabled
Exit Code: 0x00
```

开启JBOD模式
```
MegaCli64 -AdpSetProp -EnableJBOD -1 -aALL
```

关闭JBOD模式
```
MegaCli64 -AdpSetProp -EnableJBOD -0 -aALL
```

删除RAID0
```
# for i in {0..11}
> do
> MegaCli64  -CfgLdDel -L$i -a0 -Nolog
> done
```

删完 raid0 后，磁盘状态会变成 Unconfigured(good), Spun Up ：
```
MegaCli64  -PDList -aALL -Nolog|grep '^Firm'
Firmware state: Unconfigured(good), Spun Up
.....
```

将磁盘设置JBOD模式
```
# for i in {1..11}
> do
> MegaCli64  -PDMakeJBOD -PhysDrv[32:${i}] -a0
> done
Adapter: 0: EnclId-32 SlotId-1 state changed to JBOD.
Exit Code: 0x00
```

添加RAID0

dell r620 不支持JBOD

1.添加新的磁盘
```
MegaCli64 -CfgLdAdd -r0[32:2] WB Direct -a0

说明：
r0: raid0
[32:5]:32为Enclosure Device ID，5为Slot Number
WB Direct：磁盘Write back
```

2.添加一块带有残余信息的磁盘
```
MegaCli64 -cfgforeign -scan -a0
There are 1 foreign configuration(s) on controller 0.

Exit Code: 0x00

说明：由于是新插入的盘，而且是块有数据的盘，所有提示有外部配置。

MegaCli64 -cfgforeign -clear -a0
Foreign configuration 0 is cleared on controller 0.

Exit Code: 0x00
/MegaCli64 -cfgforeign -scan -a0
There is no foreign configuration on controller 0.

Exit Code: 0x00
说明：清除外部配置信息，清除后再次进行查看
MegaCli64 -CfgLdAdd -r0[32:5] WB Direct -a0
Adapter 0: Created VD 1

Adapter 0: Configured the Adapter!!

Exit Code: 0x00
```

3.查看Firmware state
```
MegaCli64 -PDList -aALL -Nolog|grep '^Firm'
Firmware state: Online, Spun Up
Firmware state: Online, Spun Up
Firmware state: Online, Spun Up
Firmware state: Online, Spun Up
Firmware state: Online, Spun Up
这里的Firmware state有可能会有类似于“Firmware state: JBOD”状态的
```

4.检查阵列的配置
```
# /opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -LALL -aAll | grep RAID
RAID Level          : Primary-1, Secondary-0, RAID Level Qualifier-0
RAID Level          : Primary-0, Secondary-0, RAID Level Qualifier-0
RAID Level          : Primary-0, Secondary-0, RAID Level Qualifier-0
RAID Level          : Primary-0, Secondary-0, RAID Level Qualifier-0
```





































使用megacli命令查看磁盘
```
# megacli -PDList -aALL 
此命令可以查看所有物理磁盘的信息。
若Media Error Count和Other Error Count的值大于0，则表示磁盘可能坏掉了。
megalci命令的参数后接其值，中间没有空格。-a参数表示使用的adapter编号。

# megacli -LDInfo -LALL -aAll 
此命令查看所有逻辑磁盘的信息。

# megacli -LdPdInfo -a1
此命令列出第2个阵列卡上各逻辑磁盘及其所属的物理磁盘信息。

# megaclin -AdpAllInfo -aALL
查看阵列卡信息

# megacli -AdpBbuCmd -aAll
查看阵列卡电池信息
```

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
# /opt/MegaRAID/MegaCli/MegaCli64 -cfgldadd -r5 [0:4,0:5,0:6] -a0
Adapter 0: Created VD 4
Adapter 0: Configured the Adapter!!

# 给刚才创建的RAID5加一块磁盘
# /opt/MegaRAID/MegaCli/MegaCli64 -ldrecon -start -r5 -add -physdrv[0:7] -l4 -a0
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
