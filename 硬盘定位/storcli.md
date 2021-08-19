storcli Raid卡管理工具
===
简介#

StorCLI是MegaCLI的继承者，允许命令行工具管理和控制LSI MegaRAID控制器。MegaCli 是LSI公司官方提供的SCSI卡管理工具，由于LSI被收购变成了现在的Broadcom，所以现在想下载MegaCli，需要去Broadcom官网查找Legacy产品支持，搜索MegaRAID即可。现在官方有storcli，已经基本代替了megacli，整合了LSI和3ware所有产品。

安装方面比较简单，megacli还要Lib_Utils的支持，而storcli只用一个rpm包就可以下载，去Broadcom官网去找就行了：https://www.broadcom.com/site-search?q=storcli

storcli支持json格式输出，信息解析更加方便

安装完后，默认位置在 /opt/Mega/storcli下面，下面介绍storcli工具的简单使用
Raid卡信息查询#

通过以下命令可以大致确定使用的的Raid的厂商和型号，如下示例主机使用的是 LSI 公司的 MegaRAID SAS-3 3108。
```
[root@rhel6.4 ~]# dmesg |grep raid 
[root@rhel6.4 ~]# cat /proc/scsi/scsi 
[root@rhel6.4 ~]# lspci |grep -i raid
[root@rhel6.4 ~]# cat /etc/*release
EBUPT STANDARD LINUX RELEASE 6.4.1
LSB_VERSION=base-4.0-amd64:base-4.0-noarch:core-4.0-amd64:core-4.0-noarch:graphics-4.0-amd64:graphics-4.0-noarch:printing-4.0-amd64:printing-4.0-noarch
Red Hat Enterprise Linux Server release 6.4 (Santiago)
Red Hat Enterprise Linux Server release 6.4 (Santiago)

[root@rhel6.4 ~]# dmesg |grep raid
megaraid_sas 0000:01:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
megaraid_sas 0000:01:00.0: setting latency timer to 64
megaraid_sas 0000:01:00.0: irq 87 for MSI/MSI-X
megaraid_sas 0000:01:00.0: irq 88 for MSI/MSI-X
megaraid_sas 0000:01:00.0: irq 89 for MSI/MSI-X
megaraid_sas 0000:01:00.0: irq 90 for MSI/MSI-X
megaraid_sas 0000:01:00.0: irq 91 for MSI/MSI-X
megaraid_sas 0000:01:00.0: irq 92 for MSI/MSI-X
megaraid_sas 0000:01:00.0: irq 93 for MSI/MSI-X
megaraid_sas 0000:01:00.0: irq 94 for MSI/MSI-X

[root@rhel6.4 ~]# cat /proc/scsi/scsi 
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: LSI 12G  Model: SAS Expander     Rev: 0800
  Type:   Enclosure                        ANSI  SCSI revision: 05
Host: scsi0 Channel: 02 Id: 00 Lun: 00
  Vendor: LSI      Model: LSI              Rev: 4.27
  Type:   Direct-Access                    ANSI  SCSI revision: 05

[root@rhel6.4 ~]# lspci |grep -i raid
01:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS-3 3108 [Invader] (rev 02)

[root@rhel6.4 ~]# lspci -s 01:00.0 -vvv
01:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS-3 3108 [Invader] (rev 02)
        Subsystem: Device 19e5:d207
        Physical Slot: 0
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 26
        Region 0: I/O ports at 4000 [size=256]
        Region 1: Memory at 93700000 (64-bit, non-prefetchable) [size=64K]
        Region 3: Memory at 93600000 (64-bit, non-prefetchable) [size=1M]
        Expansion ROM at 94400000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
                LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM L0s, Latency L0 <2us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not Supported
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+, EqualizationPhase1+
                         EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest+
        Capabilities: [d0] Vital Product Data
                Unknown small resource type 00, will not decode more.
        Capabilities: [a8] MSI: Enable- Count=1/1 Maskable+ 64bit+
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [c0] MSI-X: Enable+ Count=97 Masked-
                Vector table: BAR=1 offset=0000e000
                PBA: BAR=1 offset=0000f000
        Capabilities: [100 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [1e0 v1] #19
        Capabilities: [1c0 v1] Power Budgeting <?>
        Capabilities: [148 v1] Alternative Routing-ID Interpretation (ARI)
                ARICap: MFVC- ACS-, Next Function: 0
                ARICtl: MFVC- ACS-, Function Group: 0
        Kernel driver in use: megaraid_sas
        Kernel modules: megaraid_sas
```

常用命令#
```
参数释义：
/cx = Controller ID
/vx = Virtual Drive Number.
/ex = Enclosure ID
/sx = Slot ID
 1 storcli64 -h                                                  # 查看帮助信息
 2 storcli64 show                                                # 查看RAID卡、系统内核、主机名等信息
 3 storcli64 /c0 show all                                        # 查看第一块RAID卡版本、功能、状态、以及raid卡下的物理磁、逻辑盘信息。c0代表第一块raid卡，如果有多块则命令以此类推。
 4 storcli64 /c0 show freespace                                  # 查看第一块RAID卡剩下的磁盘空间
 5 storcli64 /c0 show rebuildrate                                # 查看第一块RAID卡rebuildrate速度
 6 storcli64 /c0 download file=mr3108fw.rom                      # 升级第一块RAID卡固件
 7 storcli64 /c0 restart                                         # 升级固件后重启RAID卡以便新固件及时生效
 8 storcli64 /c0 flushcache                                      # 清除第一块RAID卡缓存
 9 storcli64 /c0 /eall /sall show all                            # 查看第一块RAID卡上物理磁盘详细信息
10 storcli64 /c0 /e252 /s0 start locate                          # 定位第一块RAID上某块物理磁盘，物理磁盘的绿色的定位灯会闪烁。 e代表Enclosure，s代表Slot或PD
11 storcli64 /c0  /ex /sx stop locate                            # 停止定位，定位灯停止闪烁。
12 storcli64 /c0 /e252 /sall show rebuild                        # 查看磁盘重建进度
13 storcli64 /c0 /ex /sx start rebuild                           # 开始重建
14 storcli64 /c0 /ex /sx stop rebuild                            # 停止重建
15 storcli64 /c0 /ex /sx add hostsparedrive dgs=0                # 设置某块物理磁盘为磁盘组0的热备盘，如果不指定dgs，则为该RAID卡上全局热备盘。
16 storcli64 /c0 /ex /sx delete hostsparedrive                   # 删除热备磁盘
17 storcli64 /c0 add vd each type=raid0 drives=252:0,1,2,3                                          # 单独为每一块物理磁盘创建raid0
18 storcli64 /c0 add vd type=raid5 size=all names=tmp1 drives=32:2-4                                # 由第3、4、5块物理磁盘来构建RAID5，分配所有空间的逻辑磁盘命名tmp1。
19 storcli64 /c0 add vd type=raid10 size=all names=tmp1 drives=32:0-3 pdperarray=2                  # 由前四块物理磁盘构建raid10，分配所有空间的逻辑磁盘命名为tmp1。（注意：LSI SAS3108最多支持64个RAID，创建10/50/60时，必须指定pdperarray参数。如果没有这个参数，是创建不成功的。这个参数的含义是：Specifies the number of physical drives per array. The default value is automatically chosen。）
20 storcli64 /c0 add vd type=raid10 size=100GB,200GB names=tmp1,tmp2 drives=32:0-3 pdperarray=2     # 由前四块物理磁盘构建raid10，分别分配多个逻辑磁盘。
21 storcli64 /c0 add vd type=raid10 size=all names=tmp3 drives=32:0-3 pdperarray=2                  # 剩下的所有空间分配给逻辑磁盘tmp3。
22 storcli64 /c0 /vall show all                                   # 显示第一块RAID卡上所有逻辑磁盘相关信息，也可指定某个逻辑磁盘v0，v1等等。
23 storcli64 /c0 /v0 show                                         # 显示第一块RAID卡上第一个逻辑磁盘信息
24 storcli64 /c0 /v0 del force                                    # 强制删除某个逻辑磁盘
25 storcli64 /c0 /bbu show all                                    # 显示bbu信息
26 storcli64 /c0 /vall set wrcache=wt/wb/awb                      # 设置写策略
27 storcli64 /c0 show alarm                                       # 查看报警器信息
28 storcli64 /c0 set alarm=silence                                # 暂时关闭报警器鸣叫
29 storcli64 /c0 set alarm=off                                    # 始终关闭报警器鸣叫
30 storcli64 /c0 /e252 /s3 set good                               # 改变插入的物理磁盘的状态
31 storcli64 /c0 /e252 /s3 start initialization                   # 初始化某个物理磁盘
32 storcli64 /c0 /e252 /s3 show initialization                    # 查看某个初始化的物理磁盘进度
33 storcli64 /c0 /v0 set wrcache=wt                               # 修改vd的写策略
34 storcli64 /c0 /v0 set rdcache=nora                             # 修改vd的读策略
35 storcli64 /c0 /fall show                                       # 查看foreign信息
36 storcli64 /c0 /fall import                                     # 导入foreign
37 storcli64 /c0 show termlog type=contents                       # 在线查看日志
38 storcli64 /c0 show termlog type=contents | grep "rebuild"      # 在线查看日志抽取关键字
39 storcli64 /c0 show events file=/home/eventreports              # 将日志存储为文件
```

示例
---

查看Raid信息
```
[root@rhel6.4 ~]# storcli show
Status Code = 0
Status = Success
Description = None
Number of Controllers = 1
Host Name = rhel6.4
Operating System  = Linux2.6.32-358.el6.x86_64
System Overview :
===============
---------------------------------------------------------------------
Ctl Model   Ports PDs DGs DNOpt VDs VNOpt BBU sPR DS  EHS ASOs Hlth  
---------------------------------------------------------------------
  0 SAS3108     8  12   1     1   1     1 Opt On  1&2 Y      3 NdAtn 
---------------------------------------------------------------------
Ctl=Controller Index|DGs=Drive groups|VDs=Virtual drives|Fld=Failed
PDs=Physical drives|DNOpt=DG NotOptimal|VNOpt=VD NotOptimal|Opt=Optimal
Msng=Missing|Dgd=Degraded|NdAtn=Need Attention|Unkwn=Unknown
sPR=Scheduled Patrol Read|DS=DimmerSwitch|EHS=Emergency Hot Spare
Y=Yes|N=No|ASOs=Advanced Software Options|BBU=Battery backup unit
Hlth=Health|Safe=Safe-mode boot
```

查看Raid 卡0的信息

命令 storcli /c0 show 可以Raid适配器0的产品信息、虚拟磁盘和物理磁盘信息。下面输出可以看到有一个VD0，容量40T做RAID5，物理磁盘有12块，其中Slot 9 槽位磁盘状态为 Failed，需要更换。
```
[root@rhel6.4 ~]# storcli /c0 show
Generating detailed summary of the adapter, it may take a while to complete.
Controller = 0
Status = Success
Description = None
Product Name = SAS3108　　　　　　　　<<=========产品名称
Serial Number = FW-AB2M2K4EXVAWC
SAS Address =  5101b5442bcc7000
PCI Address = 00:01:00:00
System Time = 04/25/2021 16:49:18
Mfg. Date = 00/00/00
Controller Time = 04/25/2021 16:37:50
FW Package Build = 24.7.0-0057
BIOS Version = 6.22.03.1_4.16.08.00_0x060B0201
FW Version = 4.270.00-4382
Driver Name = megaraid_sas
Driver Version = 06.504.01.00-rh1
Vendor Id = 0x1000
Device Id = 0x5D
SubVendor Id = 0x19E5
SubDevice Id = 0xD207
Host Interface = PCI-E
Device Interface = SAS-12G
Bus Number = 1
Device Number = 0
Function Number = 0
Drive Groups = 1
TOPOLOGY :
========
-----------------------------------------------------------------------------
DG Arr Row EID:Slot DID Type  State  BT      Size PDC  PI SED DS3  FSpace TR 
-----------------------------------------------------------------------------
 0 -   -   -        -   RAID5 Dgrd   N  40.017 TB dflt N  N   dflt N      N  
 0 0   -   -        -   RAID5 Dgrd   N  40.017 TB dflt N  N   dflt N      N  
 0 0   0   0:0      2   DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   1   0:1      8   DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   2   0:2      7   DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   3   0:3      11  DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   4   0:4      5   DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   5   0:5      9   DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   6   0:6      4   DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   7   0:7      3   DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   8   0:8      1   DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   9   0:9      12  DRIVE Failed N   3.637 TB dflt N  N   dflt -      N  
 0 0   10  0:10     10  DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N  
 0 0   11  0:11     6   DRIVE Onln   N   3.637 TB dflt N  N   dflt -      N   
-----------------------------------------------------------------------------
上面拓扑结果显示有一个磁盘组，RAID5，拥有12块成员盘
DG=Disk Group Index|Arr=Array Index|Row=Row Index|EID=Enclosure Device ID
DID=Device ID|Type=Drive Type|Onln=Online|Rbld=Rebuild|Dgrd=Degraded
Pdgd=Partially degraded|Offln=Offline|BT=Background Task Active
PDC=PD Cache|PI=Protection Info|SED=Self Encrypting Drive|Frgn=Foreign
DS3=Dimmer Switch 3|dflt=Default|Msng=Missing|FSpace=Free Space Present
TR=Transport Ready
Virtual Drives = 1　　　　　　　　<<===========虚拟化设备1
VD LIST :
=======
---------------------------------------------------------------
DG/VD TYPE  State Access Consist Cache Cac sCC      Size Name  
---------------------------------------------------------------
0/0   RAID5 Dgrd  RW     Yes     RWBD  -   ON  40.017 TB data1 
---------------------------------------------------------------
Cac=CacheCade|Rec=Recovery|OfLn=OffLine|Pdgd=Partially Degraded|Dgrd=Degraded
Optl=Optimal|RO=Read Only|RW=Read Write|HD=Hidden|TRANS=TransportReady|B=Blocked|
Consist=Consistent|R=Read Ahead Always|NR=No Read Ahead|WB=WriteBack|
AWB=Always WriteBack|WT=WriteThrough|C=Cached IO|D=Direct IO|sCC=Scheduled
Check Consistency
Physical Drives = 12
PD LIST :　　　　　　　　　　<<==============物理磁盘列表
=======
--------------------------------------------------------------------------------
EID:Slt DID State  DG     Size Intf Med SED PI SeSz Model               Sp Type 
--------------------------------------------------------------------------------
0:0       2 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:1       8 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:2       7 Onln    0 3.637 TB SATA HDD N   N  512B ST4000NM0035-1V4107 U  -    
0:3      11 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:4       5 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:5       9 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:6       4 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:7       3 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:8       1 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:9      12 Failed  0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:10     10 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:11      6 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
--------------------------------------------------------------------------------
EID-Enclosure Device ID|Slt-Slot No.|DID-Device ID|DG-DriveGroup
DHS-Dedicated Hot Spare|UGood-Unconfigured Good|GHS-Global Hotspare
UBad-Unconfigured Bad|Onln-Online|Offln-Offline|Intf-Interface
Med-Media Type|SED-Self Encryptive Drive|PI-Protection Info
SeSz-Sector Size|Sp-Spun|U-Up|D-Down|T-Transition|F-Foreign
UGUnsp-Unsupported|UGShld-UnConfigured shielded|HSPShld-Hotspare shielded
CFShld-Configured shielded|Cpybck-CopyBack|CBShld-Copyback Shielded
Cachevault_Info :
===============
---------------------------------------------------------
Model  State   Temp Mode MfgDate    Next Learn           
---------------------------------------------------------
CVPM02 Optimal 21C  -    2016/09/18 2021/05/08  05:40:46 
---------------------------------------------------------
```

查询Controller0 下虚拟磁盘0的信息

其实上面的命令输出已经包含了这些能容
```
[root@rhel6.4 ~]# storcli /c0 /v0 show
Controller = 0
Status = Success
Description = None
Virtual Drives :
==============
---------------------------------------------------------------
DG/VD TYPE  State Access Consist Cache Cac sCC      Size Name  
---------------------------------------------------------------
0/0   RAID5 Dgrd  RW     Yes     RWBD  -   ON  40.017 TB data1 
---------------------------------------------------------------
Cac=CacheCade|Rec=Recovery|OfLn=OffLine|Pdgd=Partially Degraded|Dgrd=Degraded
Optl=Optimal|RO=Read Only|RW=Read Write|HD=Hidden|TRANS=TransportReady|B=Blocked|
Consist=Consistent|R=Read Ahead Always|NR=No Read Ahead|WB=WriteBack|
AWB=Always WriteBack|WT=WriteThrough|C=Cached IO|D=Direct IO|sCC=Scheduled
Check Consistency
```

查看controller0 下所有物理磁盘
```
[root@rhel6.4 ~]# storcli /c0 /eall /sall show
Controller = 0
Status = Success
Description = Show Drive Information Succeeded.
Drive Information :
=================
--------------------------------------------------------------------------------
EID:Slt DID State  DG     Size Intf Med SED PI SeSz Model               Sp Type 
--------------------------------------------------------------------------------
0:0       2 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:1       8 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:2       7 Onln    0 3.637 TB SATA HDD N   N  512B ST4000NM0035-1V4107 U  -    
0:3      11 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:4       5 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:5       9 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:6       4 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:7       3 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:8       1 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:9      12 Failed  0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:10     10 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
0:11      6 Onln    0 3.637 TB SATA HDD N   N  512B HUS726040ALA610     U  -    
--------------------------------------------------------------------------------
EID-Enclosure Device ID|Slt-Slot No.|DID-Device ID|DG-DriveGroup
DHS-Dedicated Hot Spare|UGood-Unconfigured Good|GHS-Global Hotspare
UBad-Unconfigured Bad|Onln-Online|Offln-Offline|Intf-Interface
Med-Media Type|SED-Self Encryptive Drive|PI-Protection Info
SeSz-Sector Size|Sp-Spun|U-Up|D-Down|T-Transition|F-Foreign
UGUnsp-Unsupported|UGShld-UnConfigured shielded|HSPShld-Hotspare shielded
CFShld-Configured shielded|Cpybck-CopyBack|CBShld-Copyback Shielded
```

**帮助信息**
```
storcli -v 
storcli -h| -help| ? 
storcli -h| -help| ? legacy
storcli show 
storcli show all
storcli show ctrlcount
storcli show file=<filepath>
storcli /cx add vd r[0|1|5|6|00|10|50|60]
        [Size=<VD1_Sz>,<VD2_Sz>,..|all] [name=<VDNAME1>,..] 
        drives=e:s|e:s-x|e:s-x,y,e:s-x,y,z [PDperArray=x][SED]
        [pdcache=on|off|default][pi][DimmerSwitch(ds)=default|automatic(auto)|
        none|maximum(max)|MaximumWithoutCaching(maxnocache)][WT|WB|AWB][nora|ra]
        [direct|cached] [cachevd] [Strip=<8|16|32|64|128|256|512|1024>]
        [AfterVd=X] [EmulationType=0|1|2] [Spares = [e:]s|[e:]s-x|[e:]s-x,y]
        [force][ExclusiveAccess] [Cbsize=0|1|2 Cbmode=0|1|2|3|4|7] 
storcli /cx add vd each r0 [name=<VDNAME1>,..] [drives=e:s|e:s-x|e:s-x,y]
        [SED] [pdcache=on|off|default][pi] [DimmerSwitch(ds)=default|
        automatic(auto)|none|maximum(max)|MaximumWithoutCaching(maxnocache)] 
        [WT|WB|AWB] [nora|ra] [direct|cached] [EmulationType=0|1|2]
        [Strip=<8|16|32|64|128|256|512|1024>] [ExclusiveAccess]
        [Cbsize=0|1|2 Cbmode=0|1|2|3|4|7]
storcli /cx add VD cachecade|nytrocache r[aid][0,1,10, 1EC] 
        drives = [e:]s|[e:]s-x|[e:]s-x,y [WT|WB] [assignvds = 0,1,2] 
        [BOOTVOLSIZE=x]
storcli /cx add VD cachecade|nytrocache slice r[aid][0,1]
        size=<x> [name=<NytroCacheName>] drives= [e:]s|[e:]s-x|[e:]s-x,y
        [WT|WB][assignvds = 0,1,2]
        size=[<VD1_Sz>,<VD2_Sz>,..] [name=<VDNAME1>,..] [WT|WB] [nora|ra]
        [direct|cached] [CachedBadBBU|NoCachedBadBBU]
        [Strip=<8|16|32|64|128|256|512|1024>] [AfterVd=X]
        [Spares = [e:]s|[e:]s-x|[e:]s-x,y] [force]
storcli /cx add JBOD [drives=e:s|e:s-x|e:s-x,y]
storcli /cx/ex show 
storcli /cx/ex show all 
storcli /cx/ex show status [extended]
storcli /cx/ex show phyerrorcounters 
storcli /cx/vx del [cachecade] [discardcache] [force]
storcli /cx delete events
storcli /cx show events [[type= <sincereboot| sinceshutdown| includedeleted|latest=x| ccincon vd=<0,1,...>] filter=<[info],[warning],[critical],[fatal]> file=<filepath> [logfile[=filename]]
storcli /cx show eventloginfo
storcli /cx show health [all]
storcli /cx delete securitykey
storcli /cx set securitykey=xxxxxxxx {passphrase=xxxx} {keyid=xxx}
storcli /cx start Diag Duration=<Val> 
storcli /cx set securitykey keyid=xxx
storcli /cx compare securitykey=xxxxxxxxxx
storcli /cx set termlog[=on|off|offthisboot]
storcli /cx show termlog [type=config|contents] [logfile[=filename]] 
storcli /cx delete termlog
storcli /cx set securitykey=xxxxxxxx oldsecuritykey=xxxxxxxx {passphrase=xxxx} {keyid=xxx}
storcli /cx set sesmonitoring[=on|off]
storcli /cx show sesmonitoring 
storcli /cx set failpdonsmarterror[=on|off]
storcli /cx show failpdonsmarterror 
storcli /cx/dx show 
storcli /cx/dall show cachecade 
storcli /cx/dx show all 
storcli /cx/dall show mirror 
storcli /cx/dall split mirror 
storcli /cx/dall add mirror src=<val> [force] 
storcli /cx show freespace
storcli /cx/fall show [all] [securityKey = xxx]
storcli /cx/fall del|delete [securityKey = xxx]
storcli /cx/fall import [preview] [securityKey = xxx]
storcli /cx/vx set ssdcaching=on|off
storcli /cx/vx set hidden=on|off
storcli /cx/dx hideallvds
storcli /cx/dx unhideallvds
storcli /cx/dx set hidden=on|off
storcli /cx/dx set security=on
storcli /cx/vx show expansion
storcli /cx show fshinting
storcli /cx/vx set fshinting=<value>
storcli /cx/vx expand Size=<xx> [expandarray]
storcli /cx[/ex]/sx show 
storcli /cx[/ex]/sx show all
storcli /cx[/ex]/sx start rebuild 
storcli /cx[/ex]/sx stop rebuild 
storcli /cx[/ex]/sx pause rebuild 
storcli /cx[/ex]/sx resume rebuild 
storcli /cx[/ex]/sx show rebuild 
storcli /cx[/ex]/sx show health 
storcli /cx[/ex]/sx show poh 
storcli /cx[/ex]/sx show smart 
storcli /cx[/ex]/sx start copyback target=e:s 
storcli /cx[/ex]/sx stop copyback 
storcli /cx[/ex]/sx pause copyback 
storcli /cx[/ex]/sx resume copyback 
storcli /cx[/ex]/sx reset phyerrorcounters 
storcli /cx[/ex]/sx show copyback 
storcli /cx[/ex]/sx show patrolread 
storcli /cx[/ex]/sx show phyerrorcounters 
storcli /cx[/ex]/sx start initialization  
storcli /cx[/ex]/sx stop initialization  
storcli /cx[/ex]/sx show initialization  
storcli /cx[/ex]/sx start locate  
storcli /cx[/ex]/sx stop locate  
storcli /cx[/ex]/sx show securitykey keyid 
storcli /cx[/ex]/sx add hotsparedrive [DGs=<N|0,1,2...>] [enclaffinity] [nonrevertible]
storcli /cx[/ex]/sx delete hotsparedrive
storcli /cx[/ex]/sx spinup
storcli /cx[/ex]/sx spindown
storcli /cx[/ex]/sx set online 
storcli /cx[/ex]/sx set offline 
storcli /cx[/ex]/sx set missing 
storcli /cx[/ex]/sx set jbod 
storcli /cx[/ex]/sx set security=on 
storcli /cx[/ex]/sx set good [force]  
storcli /cx[/ex]/sx insert dg=A array=B row=C 
storcli /cx/vx set emulationType=0|1|2
storcli /cx/vx set cbsize=0|1|2 cbmode=0|1|2|3|4|7 
storcli /cx/vx set wrcache=WT|WB|AWB
storcli /cx/vx set rdcache=RA|NoRA
storcli /cx/vx set iopolicy=Cached|Direct
storcli /cx/vx set accesspolicy=RW|RO|Blocked|RmvBlkd
storcli /cx/vx set pdcache=On|Off|Default
storcli /cx/vx set name=<NameString>
storcli /cx/vx set HostAccess=ExclusiveAccess|SharedAccess
storcli /cx/vx set ds=Default|Auto|None|Max|MaxNoCache
storcli /cx/vx set autobgi=On|Off
storcli /cx/vx set pi=Off
storcli /cx/vx show
storcli /cx/vx show all [logfile[=filename]]
storcli /cx/vx show init
storcli /cx/vx show cc
storcli /cx/vx show erase
storcli /cx/vx show migrate
storcli /cx/vx show bgi
storcli /cx/vx show autobgi
storcli /cx/vx show trim
storcli /cx set consistencycheck|cc=[off|seq|conc] [delay=value] starttime=yyyy/mm/dd hh] [excludevd=x-y,z|none]
storcli /cx show cc|consistencycheck
storcli /cx show ocr 
storcli /cx set ocr=<on|off>
storcli /cx show sesmultipathcfg 
storcli /cx set sesmultipathcfg=<on|off>
storcli /cx/vx start init[Full][Force]
storcli /cx/vx start erase [simple|normal|thorough|standard][patternA=<val>] [patternB=<val>]
storcli /cx/vx start cc[Force]
storcli /cx/vx start migrate type=raidx [option=add|remove drives=[e:]s|[e:]s-x|[e:]s-x,y] [Force] 
storcli /cx/vx stop init
storcli /cx/vx stop erase
storcli /cx/vx stop cc
storcli /cx/vx stop bgi
storcli /cx/vx pause cc
storcli /cx/vx pause bgi
storcli /cx/vx resume cc
storcli /cx/vx resume bgi
storcli /cx show 
storcli /cx show all [logfile[=filename]]
storcli /cx show preservedcache 
storcli /cx/vx delete preservedcache[force] 
storcli /cx[/ex]/sx download src=<filepath> [satabridge] [mode= 5|7] [parallel] [force]
storcli /cx[/ex]/sx download status
storcli /cx/ex download src=<filepath> [forceActivate] 
storcli /cx[/ex]/sx download src=<filepath> mode= E offline [activatenow] [delay=<val>]
storcli /cx[/ex]/sx download  mode= F offline [delay=<val>]
storcli /cx[/ex]/sx secureerase [force]  
storcli /cx[/ex]/sx start erase [simple| normal| thorough | standard| threepass | crypto] [patternA=<val>] [patternB=<val>]
storcli /cx[/ex]/sx stop erase 
storcli /cx[/ex]/sx show erase 
storcli /cx[/ex]/sx show rawdata pageaddr=<pageaddress in hex> file=<filename> 
storcli /cx[/ex]/sx set bootdrive=<on|off> 
storcli /cx/vx set bootdrive=<on|off>
storcli /cx show bootdrive
storcli /cx show bootwithpinnedcache
storcli /cx set bootwithpinnedcache=<on|off>
storcli /cx show activityforlocate
storcli /cx set activityforlocate=<on|off>
storcli /cx show copyback
storcli /cx set copyback=<on|off> type=smartssd|smarthdd|all 
storcli /cx show jbod
storcli /cx set jbod=<on|off> [force]
storcli /cx set autorebuild=<on|off> 
storcli /cx set ldlimit=<default|max> 
storcli /cx show autorebuild
storcli /cx set autoconfig=<off|[on|sscr0]|r0|wbr0> [immediate]
storcli /cx show autoconfig
storcli /cx show cachebypass
storcli /cx set cachebypass=<on|off> 
storcli /cx show usefdeonlyencrypt
storcli /cx set usefdeonlyencrypt=<on|off>
storcli /cx show prcorrectunconfiguredareas
storcli /cx set prcorrectunconfiguredareas=<on|off> 
storcli /cx show batterywarning
storcli /cx set batterywarning=<on|off> 
storcli /cx show abortcconerror
storcli /cx set abortcconerror=<on|off> 
storcli /cx show ncq
storcli /cx show configautobalance 
storcli /cx set ncq=<on|off> 
storcli /cx set configautobalance=<on|off> 
storcli /cx show maintainpdfailhistory
storcli /cx set maintainpdfailhistory=<on|off> 
storcli /cx show restorehotspare
storcli /cx set restorehotspare=<on|off> 
storcli /cx set bios [state=<on|off>] [Mode=<SOE|PE|IE|SME>] [abs=<on|off>] [DeviceExposure=<value>]
storcli /cx show bios 
storcli /cx show alarm
storcli /cx set alarm=<on|off|silence> 
storcli /cx show foreignautoimport
storcli /cx set foreignautoimport=<on|off> 
storcli /cx show directpdmapping
storcli /cx set directpdmapping=<on|off> 
storcli /cx show rebuildrate
storcli /cx set rebuildrate=<value> 
storcli /cx show loadbalancemode
storcli /cx set loadbalancemode=<on|off> 
storcli /cx show eghs
storcli /cx set eghs [state=<on|off>] [eug=<on|off>] [smarter=<on|off>] 
storcli /cx show cacheflushint
storcli /cx set cacheflushint=<value>
storcli /cx show prrate
storcli /cx set prrate=<value> 
storcli /cx show ccrate
storcli /cx set ccrate=<value> 
storcli /cx show bgirate
storcli /cx set bgirate =<value> 
storcli /cx show dpm 
storcli /cx set dpm =<on|off> 
storcli /cx show sgpioforce 
storcli /cx set sgpioforce =<on|off> 
storcli /cx set supportssdpatrolread =<on|off> 
storcli /cx show migraterate
storcli /cx set migraterate=<value> 
storcli /cx show spinupdrivecoun
storcli /cx show wbsupport
storcli /cx set spinupdrivecount=<value> 
storcli /cx show spinupdelay
storcli /cx set spinupdelay=<value> 
storcli /cx show coercion
storcli /cx set coercion=<value> 
storcli /cx show limitMaxRateSATA
storcli /cx set limitMaxRateSATA=on|off 
storcli /cx show HDDThermalPollInterval
storcli /cx set HDDThermalPollInterval=<value> 
storcli /cx show SSDThermalPollInterval
storcli /cx set SSDThermalPollInterval=<value> 
storcli /cx show smartpollinterval
storcli /cx set smartpollinterval=<value> 
storcli /cx show eccbucketsize
storcli /cx set eccbucketsize=<value> 
storcli /cx show eccbucketleakrate
storcli /cx set eccbucketleakrate=<value> 
storcli /cx show backplane
storcli /cx set backplane mode=<value> expose=<on/off> 
storcli /cx show perfmode
storcli /cx set perfmode=<value> [maxflushlines=<value> numiostoorder=<value>]
storcli /cx show perfmodevalues
storcli /cx show pi
storcli /cx set pi [state=<on|off>] [import=<on|off>]
storcli /cx show time
storcli /cx set time=<yyyymmdd hh:mm:ss | systemtime> 
storcli /cx show ds
storcli /cx set ds=OFF type=1|2|3|4
storcli /cx set ds=ON type=1|2 [properties]
storcli /cx set ds=ON type=3|4 DefaultLdType=<val> [properties]
storcli /cx set ds [properties] 
storcli /cx show safeid
storcli /cx show rehostinfo
storcli /cx show pci
storcli /cx show ASO
storcli /cx set aso key=<key value> preview
storcli /cx set aso key=<key value>
storcli /cx set aso transfertovault
storcli /cx set aso rehostcomplete
storcli /cx set aso deactivatetrialkey
storcli /cx set factory defaults
storcli /cx download file=<filepath> [fwtype=<val>] [ResetNow] [nosigchk] [noverchk] [force]
storcli /cx flush|flushcache
storcli /cx [start] flush|flushcache [cachecade | nytrocache | ALL]
storcli /cx stop flush|flushcache cachecade|nytrocache
storcli /cx show flush|flushcache cachecade|nytrocache 
storcli /cx/px show 
storcli /cx/px show all
storcli /cx/px set linkspeed=0|1.5|3|6|12 
storcli /cx/bbu show 
storcli /cx/bbu show all 
storcli /cx/bbu show status 
storcli /cx/bbu show properties 
storcli /cx/bbu show learn 
storcli /cx/bbu show gasgauge Offset=xxxx Numbytes=n 
storcli /cx/bbu start learn 
storcli /cx/bbu show modes 
storcli /cx/bbu set [ learnDelayInterval=<val> | bbuMode=<val> |learnStartTime=[DDD HH | off] | autolearnmode=<val> |  powermode=sleep | writeaccess=sealed ] 
storcli /cx/cv set SCAPVPD file=<input file path> VPDPage=<SCapVPDFixed>
storcli /cx/cv show 
storcli /cx/cv show all 
storcli /cx/cv show status 
storcli /cx/cv show learn 
storcli /cx/cv show SCAPVPD file=<output file path> VPDPage=<SCapVPDFixed>
storcli /cx/cv start learn 
storcli /cx show securitykey keyid 
storcli /cx start patrolread
storcli /cx stop patrolread
storcli /cx pause patrolread
storcli /cx resume patrolread
storcli /cx show patrolRead
storcli /cx show powermonitoringinfo
storcli /cx show ldlimit
storcli /cx set patrolread = {{on mode=<auto|manual> }|{off}}
storcli /cx set patrolread [starttime=< yyyy/mm/dd hh>] [maxconcurrentpd =<value>] [includessds=<on|onlymixed|off>] [uncfgareas=on|off] 
storcli /cx set patrolread delay = <value>
storcli /cx[/ex]/sx show diag paniclog [Query] | [ExtractSlot=x] | [EraseSlot=x] [file=filepath]
storcli /cx[/ex]/sx show diag smartlog [file=filepath] 
storcli /cx[/ex]/sx show diag errorlog [file=filepath] 
storcli /cx del Nytrocache [force]
storcli /cx show badblocks
storcli /cx flasherase 
storcli /cx shutdown 
storcli /cx/mx set mode=<Internal | External | Auto> 
storcli /cx/mx show 
storcli /cx transform iMR 
storcli /cx restart 
storcli /cx/vx show BBMT
storcli /cx/vx delete BBMT
storcli /cx[/ex]/sx start format [thorough] 
storcli /cx show dequeuelog file=<filepath>
storcli /cx show maintenance
storcli /cx set maintenance mode=normal|nodevices 
storcli /cx show personality
storcli /cx set personality=RAID|HBA|JBOD 
storcli /cx set personality behavior=JBOD|None 
storcli /cx show jbodwritecache
storcli /cx set jbodwritecache=on|off|default 
storcli /cx show immediateio
storcli /cx show driveactivityled
storcli /cx set immediateio=<on|off>
storcli /cx show largeiosupport
storcli /cx set largeiosupport=<on|off>
storcli /cx set driveactivityled=<on|off>
storcli /cx show pdfailevents [lastoneday] [lastseqnum=<val>] [file=<filepath>] 
storcli /cx show pdfaileventoptions
storcli /cx set pdfaileventoptions [detectionType=<val>] [correctiveaction=<val>] [errorThreshold=<val>] 
storcli /cx/vx show vfmap
storcli /cx/vx set vfmap [VF=<val> | PF] access=RW|RO|Blocked|Hidden
storcli /cx show AliLog [logfile[=filename]]
storcli /cx get config file=<fileName>
storcli /cx set config file=<fileName>
storcli /cx get FRU
storcli /cx set FRU 
storcli delete FRU file=<fileName>
storcli show FRU
storcli /cx show flushwriteverify
storcli /cx set flushwriteverify=<on|off>
storcli /cx/dx set transport=on/off [EDHSP=on/off] [SDHSP=on/off]
storcli /cx show largeQD
storcli /cx set largeQD=<on|off>
storcli /cx set debug type=<value> option=<value> [level=<value in hex>]
storcli /cx set debug reset all
storcli /cx set personality behavior [sesmgmt=on/off] [securesed=on/off] [multipath=on/off] [multiinit=on/off]
storcli /cx show sriov
storcli /cx show VFQDMode
storcli /cx show QueueDepth VF=<val>
storcli /cx set sriov=on/off
storcli /cx set VFQDMode=<val>
storcli /cx set QueueDepth VF=<val> QDValue=<val>
storcli /cx delete config [force]
storcli /cx/jbodx del [discardcache] [force]
storcli /cx/jbodx show
storcli /cx/jbodx show init
storcli /cx/jbodx show erase
storcli /cx/jbodx start init[Full][Force]
storcli /cx/jbodx start erase [simple|normal|thorough|standard][patternA=<val>] [patternB=<val>]
storcli /cx/jbodx stop init
storcli /cx/jbodx stop erase
storcli /cx/jbodx set bootdrive=<on|off>
Note:Use 'page=[x]'as the last option in all the commands to set the page break.
X=lines per page. E.g. 'storcli help page=10
```

参考：
- https://www.broadcom.com/products/storage
- https://www.broadcom.com/products/storage/raid-controllers/megaraid-sas-9361-8i#downloads
- https://www.thomas-krenn.com/en/wiki/StorCLI\_commands
- https://www.broadcom.cn/support/knowledgebase/1211161499760/lsi-command-line-interface-cross-reference-megacli-vs-twcli-vs-s
- https://blog.csdn.net/github\_35588003/article/details/105426741
- https://blog.51cto.com/hsuehwee/1633515
- https://www.cnblogs.com/luxiaodai/p/9878747.html
- https://www.cnblogs.com/liuxing0007/p/10912444.html
