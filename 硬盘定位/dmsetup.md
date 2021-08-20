dmsetup 命令
===

**Name** dmsetup - low level logical volume management

Synopsis
---
```
dmsetup clear device_name
dmsetup create device_name [-u uuid] [--notable|--table <table>| table_file] [{--addnodeoncreate|--addnodeonresume}] [--readahead [+]<sectors>|auto|none]
dmsetup deps [-o options] [device_name]
dmsetup help [-c|-C|--columns]
dmsetup info [device_name]
dmsetup info -c|-C|--columns [--noheadings] [--separator separator] [-o fields] [-O|--sort sort_fields] [device_name]
dmsetup load device_name [--table <table>|table_file]
dmsetup ls [--target target_type] [--exec command] [--tree] [-o options]
dmsetup message device_name sector message
dmsetup mknodes [device_name]
dmsetup mangle [device_name]
dmsetup reload device_name [--table <table>|table_file]
dmsetup wipe_table device_name
dmsetup remove [-f|--force] [--retry] device_name
dmsetup remove_all [-f|--force]
dmsetup rename device_name new_name
dmsetup rename device_name --setuuid uuid
dmsetup resume device_name [{--addnodeoncreate|--addnodeonresume}] [--readahead [+]<sectors>|auto|none]
dmsetup setgeometry device_name cyl head sect start
dmsetup splitname device_name [subsystem]
dmsetup status [--target target_type] [--noflush] [device_name]
dmsetup suspend [--nolockfs] [--noflush] device_name
dmsetup table [--target target_type] [--showkeys] [device_name]
dmsetup targets
dmsetup udevcomplete cookie
dmsetup udevcomplete_all [age_in_minutes]
dmsetup udevcookies
dmsetup udevcreatecookie
dmsetup udevflags cookie
dmsetup udevreleasecookie [cookie]
dmsetup version
dmsetup wait [--noflush] device_name [event_nr]
devmap_name major minor
devmap_name major:minor
```

描述
---
dmsetup 使用device-mapper驱动程序管理逻辑设备。设备是通过加载一个表来创建的，该表为逻辑设备中的每个扇区（512 字节）指定了一个目标。

dmsetup 的第一个参数是一个命令。第二个参数是逻辑设备名称或 uuid。

常用命令
---
显示当前devicemapper 的信息
```
dmsetup info             # 查询设备信息
dmsetup ls               # 列出所有逻辑设备
dmsetup status           # 列出所有逻辑设备的状态信息
dsetup remove            # 移除逻辑设备
dmsetup deps             # 显示设备依赖关系
```

dmsetup info 命令
---
dmsetup命令是用来与Device Mapper沟通的命令行封装器（wrapper）。可使用dmsetup命令的info，ls，status和deps查看LVM设备的常规信息，如以下小结所述

dmsetup info device 命令提供有段Device Mapper设备概述，如果没有指定设备名称，则输出所有目前配置的Device Mapper，如果指定了设备，那么这个命令只会生成该设备信息。

```
# dmsetup info
Name:              36001438005deddc80000400003340000p1
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      0
Major, minor:      253, 6
Number of targets: 1
UUID: part1-mpath-36001438005deddc80000400003340000

Name:              hdvg-swaplv
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      0
Major, minor:      253, 1
Number of targets: 1
UUID: LVM-HdEgjZIOBlqvg5UJrJiJZMrD8amxrnKuwZMowd50csflOe9XekfB4ohPBVFayV6U

Name:              vgdm-lvznff2
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        0
Event number:      0
Major, minor:      253, 10
Number of targets: 1
UUID: LVM-1xNOdw2IYIcdocFnxwQUNCIYjo2OUZdqcliq0OGmuWImwCPLhf2frdi9ge4RdNm3


Name:              hdvg-rootlv
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      0
Major, minor:      253, 0
Number of targets: 1
UUID: LVM-HdEgjZIOBlqvg5UJrJiJZMrD8amxrnKurdvdBAzDoZXbjVnQccm7Gk24F7or5Czw
```
- Name 设备名称。LVM 设备以用小横线分隔的卷组名称和逻辑卷名称表示。在源名称中小横线会转换为两个小横线。在标准 LVM 操作过程中，不应使用这种格式的 LVM 设备名称直接指定 LVM 设备，而是应该使用 vg/lv 指定。
- State 可能的设备状态是 SUSPENDED、ACTIVE 和 READ-ONLY。dmsetup suspend 命令将设备状态设定为 SUSPENDED。当挂起某个设备时，会停止对该设备的所有 I/O 操作。使用 dmsetup resume 命令可将设备状态恢复到 ACTIVE。
- Read Ahead 系统对正在进行读取操作的任意打开文件的预读数据块数目。默认情况下，内核会自动选择一个合适的值。可使用 dmsetup 命令的 --readahead 选项更改这个值。
- Tables present 这个类型的可能状态为 LIVE 和 INACTIVE。INACTIVE 状态表示已经载入了表格，且会在 dmsetup resume 命令将某个设备状态恢复为 ACTIVE 时进行切换，届时表格状态将为 LIVE。有关详情请参考 dmsetup man page。
- Open count 打开参考计数表示打开该设备的次数。mount 命令会打开一个设备。
- Event number 目前收到的事件数目。使用 dmsetup wait n 命令允许用户等待第 n 个事件，收到该事件前阻断该调用。
- Major, minor 主设备号码和副设备号码
- Number of targets 组成某个设备的片段数目。例如：一个跨三个磁盘的线性设备会有三个目标。线性设备由某个磁盘起始和结尾，而不是中间组成的线性设备有两个目标。
- UUID 该设备的 UUID。


dmsetup ls 命令
---
可以使用dmsetup ls命令列出映射的设备的设备名称列表。可以使用dmsetup ls --target target_type 命令列出至少有一个指定类型目标的设备。

```
# dmsetup ls
36001438005deddc80000400003340000p1     (253, 6)
36001438005deddc80000400003340000       (253, 2)
fenxi-2T        (253, 5)
fenxi-lvfenxi   (253, 8)
DMdisk03-1T     (253, 4)
hdvg-swaplv     (253, 1)
vgdm-lvznff2    (253, 10)
hdvg-rootlv     (253, 0)
vg_settlement-lv_settlement     (253, 7)
DMdisk02-2T     (253, 3)
vgdm-lvznff     (253, 9)
```

在多路径或者其他device mapper装置中堆叠的LVM配置文件可能过于复杂。dmsetup ls命令提供了一个--tree选项，可以树形形式显示设备间的相依性，这对梳理各逻辑设备和物理设备的关系很有帮助
```
# dmsetup ls --tree
fenxi-lvfenxi (253:8)
 └─fenxi-2T (253:5)
    ├─ (65:80)
    ├─ (65:64)
    ├─ (65:48)
    └─ (65:32)
hdvg-swaplv (253:1)
 └─ (104:2)
vgdm-lvznff2 (253:10)
 └─DMdisk02-2T (253:3)
    ├─ (8:240)
    ├─ (8:224)
    ├─ (8:80)
    ├─ (8:16)
    ├─ (8:144)
    └─ (8:96)
hdvg-rootlv (253:0)
 └─ (104:2)
vg_settlement-lv_settlement (253:7)
 └─36001438005deddc80000400003340000p1 (253:6)
    └─36001438005deddc80000400003340000 (253:2)
       ├─ (8:208)
       ├─ (8:192)
       ├─ (8:64)
       ├─ (8:0)
       ├─ (8:128)
       └─ (8:48)
vgdm-lvznff (253:9)
 ├─DMdisk03-1T (253:4)
 │  ├─ (65:16)
 │  ├─ (65:0)
 │  ├─ (8:112)
 │  ├─ (8:32)
 │  ├─ (8:176)
 │  └─ (8:160)
 └─DMdisk02-2T (253:3)
    ├─ (8:240)
    ├─ (8:224)
    ├─ (8:80)
    ├─ (8:16)
    ├─ (8:144)
    └─ (8:96)
```

dmsetup status 命令
---
dmsetup status device 命令提供指定设备中每个目标的状态信息。如果没有指定设备名称，输出结果是所有目前配置的设备映射器设备信息。可以使用 dmsetup status --targettarget_type 命令列出那些至少有一个指定类型目标的设备。

```
# dmsetup status
36001438005deddc80000400003340000p1: 0 4194298332 linear 
36001438005deddc80000400003340000: 0 4194304000 multipath 2 0 0 0 2 1 A 0 2 0 8:48 A 0 8:128 A 0 E 0 4 0 8:0 A 0 8:64 A 0 8:192 A 0 8:208 A 0 
fenxi-2T: 0 4194304000 multipath 2 0 0 0 2 1 A 0 2 0 65:32 A 0 65:48 A 0 E 0 2 0 65:64 A 0 65:80 A 0 
fenxi-lvfenxi: 0 3774873600 linear 
DMdisk03-1T: 0 2097152000 multipath 2 0 0 0 2 1 A 0 2 0 8:160 A 0 8:176 A 0 E 0 4 0 8:32 A 0 8:112 A 0 65:0 A 0 65:16 A 0 
hdvg-swaplv: 0 4063232 linear 
vgdm-lvznff2: 0 2097152000 linear 
hdvg-rootlv: 0 62914560 linear 
vg_settlement-lv_settlement: 0 4128768000 linear 
DMdisk02-2T: 0 4194304000 multipath 2 0 0 0 2 1 A 0 2 0 8:96 A 0 8:144 A 0 E 0 4 0 8:16 A 0 8:80 A 0 8:224 A 0 8:240 A 0 
vgdm-lvznff: 0 2096103424 linear 
vgdm-lvznff: 2096103424 1048576 linear 
```

dmsetup deps 命令
---
dmsetup deps device 命令为指定设备的映射列表参考的设备提供（major，minor）对列表。如果没有指定设备名称，则输出所有目前配置的设备映射器设备信息。

```
# dmsetup deps
36001438005deddc80000400003340000p1: 1 dependencies     : (253, 2)
36001438005deddc80000400003340000: 6 dependencies       : (8, 208) (8, 192) (8, 64) (8, 0) (8, 128) (8, 48)
fenxi-2T: 4 dependencies        : (65, 80) (65, 64) (65, 48) (65, 32)
fenxi-lvfenxi: 1 dependencies   : (253, 5)
DMdisk03-1T: 6 dependencies     : (65, 16) (65, 0) (8, 112) (8, 32) (8, 176) (8, 160)
hdvg-swaplv: 1 dependencies     : (104, 2)
vgdm-lvznff2: 1 dependencies    : (253, 3)
hdvg-rootlv: 1 dependencies     : (104, 2)
vg_settlement-lv_settlement: 1 dependencies     : (253, 6)
DMdisk02-2T: 6 dependencies     : (8, 240) (8, 224) (8, 80) (8, 16) (8, 144) (8, 96)
vgdm-lvznff: 2 dependencies     : (253, 4) (253, 3)
```

https://linux.die.net/man/8/dmsetup
