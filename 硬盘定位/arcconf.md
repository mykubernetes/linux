arcconf RAID 管理工具
===
Adaptec ARCCONF Command Line Utilityarcconf 是 Adaptec RAID 适配器管理工具

1、常用命令：#
```
arcconf LIST　　　　　　　　 　#查询整列卡信息
arcconf GETCONFIG 1 AD      # 查询 Controller #1 的适配器信息
arcconf GETCONFIG 1 LD      # 查询 Controller #1 的逻辑设备信息
arcconf GETCONFIG 1 PD      # 查询 Controller #1 的物理设备信息
arcconf GETCONFIG 1 AR      # 查询 Controller #1 的阵列信息
arcconf GETCONFIG 1 AL      # 查询 Controller #1 的所有信息
arcconf GETCONFIG 1 LD|grep 'Logical Device number'     # 查询 Controller #1 的所有逻辑设备编号
arcconf GETCONFIG 1 LD|grep 'Logical Device name'       # 查询 Controller #1 的所有逻辑设备名称
arcconf GETCONFIG 1 PD|grep 'Device #'                  # 查询 Controller #1 的所有物理设备编号
arcconf GETCONFIG 1 LD|grep -E 'Logical Device number|Device:|Slot:'                # 查询 Controller #1 的所有逻辑设备对应的物理设备
arcconf GETCONFIG 1 LD|grep -E 'Logical Device number|Device:|Slot:'                # 查询 Controller #1 的所有逻辑设备对应的物理设备
arcconf GETCONFIG 1 LD|grep -E 'Logical Device number|RAID level|Device:|Slot:'     # 查询 Controller #1 的所有逻辑设备的RAID level以及物理设备
arcconf GETCONFIG 1 LD|grep -E 'Logical Device number|Logical Device name|RAID level|Device:|Slot:'     # 查询 Controller #1 的所有逻辑设备的关键信息
```

2、初始化 (initialize)
```
arcconf TASK START 1 DEVICE 0 8 initialize              # 初始化阵列卡 Controller #1 下 Channel #0, Device #8 的硬盘
arcconf TASK START 1 DEVICE ALL initialize              # 初始化阵列卡 Controller #1 下的所有硬盘
```

3、去初始化 (uninitialize)
```
arcconf TASK START 1 DEVICE 0 8 uninitialize            # 去初始化阵列卡 Controller #1 下 Channel #0, Device #8 的硬盘
arcconf TASK START 1 DEVICE ALL uninitialize            # 去初始化阵列卡 Controller #1 下的所有硬盘
```

4、创建阵列 RAID 0
```
arcconf CREATE <Controller#> LOGICALDRIVE [Options] <Size> <RAID#> <Channel# ID#> [Channel# ID#] ... [noprompt] [nologs]
arcconf CREATE 1 LOGICALDRIVE MAX 0 0 1 noprompt                    # 在第1个控制器创建 RAID 0 使用硬盘 Channel #0, Device #1
arcconf CREATE 1 LOGICALDRIVE Name data1 MAX 0 0 1 noprompt         # 在第1个控制器创建 RAID 0 设置 Logical Device name: data1 使用硬盘 Channel #0, Device #1
arcconf CREATE 1 LOGICALDRIVE Name data2 MAX 0 0 2 0 3 noprompt     # 在第1个控制器创建 RAID 0 设置 Logical Device name: data2 使用硬盘 Channel #0, Device #2 & Channel #0, Device #3
arcconf CREATE 1 RAIDZEROARRAY ALL noprompt                         # 在第1个控制器自动创建所有未使用硬盘为单盘 RAID 0
arcconf CREATE 1 RAIDZEROARRAY 0 1 noprompt                         # 在第1个控制器创建单盘 RAID 0 使用硬盘 Channel #0, Device #1
```

5、创建阵列 RAID 1
```
arcconf CREATE 1 LOGICALDRIVE MAX 1 0 0 0 1 noprompt                # 在第1个控制器创建 RAID 1 使用硬盘 Channel #0, Device #0 & Channel #0, Device #1
arcconf CREATE 1 LOGICALDRIVE Name data2 MAX 1 0 0 0 1 noprompt     # 在第1个控制器创建 RAID 1 设置 Logical Device name: data2 使用硬盘 Channel #0, Device #0 & Channel #0, Device #1
```

6、创建阵列 RAID 5
```
arcconf CREATE 1 LOGICALDRIVE MAX 5 0 2 0 3 0 4 0 5 noprompt                # 在第1个控制器创建 RAID 5 使用硬盘 Channel #0, Device #2 & Channel #0, Device #3 & Channel #0, Device #4 & Channel #0, Device #5
arcconf CREATE 1 LOGICALDRIVE Name data2 MAX 5 0 2 0 3 0 4 0 5 noprompt     # 在第1个控制器创建 RAID 5 设置 Logical Device name: data2 使用硬盘 Channel #0, Device #2 & Channel #0, Device #3 & Channel #0, Device #4 & Channel #0, Device #5
```

7、创建阵列 RAID 10
```
arcconf CREATE 1 LOGICALDRIVE MAX 10 0 2 0 3 0 4 0 5 noprompt               # 在第1个控制器创建 RAID 10 使用硬盘 Channel #0, Device #2 & Channel #0, Device #3 & Channel #0, Device #4 & Channel #0, Device #5
arcconf CREATE 1 LOGICALDRIVE Name data2 MAX 10 0 2 0 3 0 4 0 5 noprompt    # 在第1个控制器创建 RAID 5 设置 Logical Device name: data2 使用硬盘 Channel #0, Device #2 & Channel #0, Device #3 & Channel #0, Device #4 & Channel #0, Device #5
```

8、删除逻辑盘
```
arcconf DELETE <Controller#> LOGICALDRIVE <ld#> [noprompt] [nologs]
arcconf GETCONFIG 1 LD                  # 查询 Controller #1 的逻辑设备信息
arcconf DELETE 1 LOGICALDRIVE 0         # 删除第1个控制器的第0个逻辑盘
arcconf DELETE 1 LOGICALDRIVE ALL       # 删除第1个控制器的所有逻辑盘
```

9、删除阵列
```
arcconf DELETE <Controller#> ARRAY <arr#> [noprompt] [nologs]
arcconf GETCONFIG 1 AR                  # 查询 Controller #1 的阵列信息
arcconf DELETE 1 ARRAY 0                # 删除第1个控制器的第0个阵列
arcconf DELETE 1 ARRAY ALL              # 删除第1个控制器的所有阵列
```

10、点亮硬盘灯
```
arcconf IDENTIFY <Controller#> ALL [TIME <BlinkTime>] [STOP] [nologs]
arcconf IDENTIFY 1 ALL                  # 点亮 Controller #1 下的所有硬盘灯
arcconf IDENTIFY 1 ALL TIME 60          # 点亮 Controller #1 下的所有硬盘灯，亮60秒
arcconf IDENTIFY 1 DEVICE 0 3           # 点亮 Controller #1 下的 Channel #0, Device #3 的硬盘灯
arcconf IDENTIFY 1 DEVICE 0 3 60        # 点亮 Controller #1 下的 Channel #0, Device #3 的硬盘灯，亮60秒
arcconf IDENTIFY 1 LOGICALDRIVE 0       # 点亮 Controller #1 下的 LOGICALDRIVE 0 中的所有硬盘灯
arcconf IDENTIFY 1 ARRAY 0              # 点亮 Controller #1 下的 ARRAY 0 中的所有硬盘灯
arcconf IDENTIFY 1 ALL STOP             # 停止点亮 Controller #1 下的所有的硬盘灯
```

服务器单盘RAID 0配置
```
arcconf GETCONFIG 1 LD|grep -E 'Logical Device number|Logical Device name|Device:|Slot:'
arcconf GETCONFIG 1 PD|grep 'Device #'
arcconf DELETE 1 LOGICALDRIVE 3
arcconf CREATE 1 LOGICALDRIVE Name data3 MAX 0 0 2
arcconf RESCAN 1
```

参考：
- https://www.thomas-krenn.com/en/wiki/Adaptec_arcconf_CLI_Commands
- https://support.huawei.com/enterprise/zh/doc/EDOC1000004345/b4d43c54
- https://server-support.co/sysadmin/adaptec-raid-arcconf-creating-array-from-linux-command-line
- https://www.ibm.com/docs/en/power9/0009-ESS?topic=cpsifi529292s-drive-commands-5104-22c-9006-12p-9006-22c-9006-22p
- https://storage.microsemi.com/en-us/speed/raid/storage_manager/arcconf_v3_03_23668_zip.php
- https://www.cnblogs.com/zhangxinglong/p/10530945.html
- https://blog.csdn.net/qing_ping/article/details/88643894
- https://storage.microsemi.com/en-us/support/infocenter/release-2016-1/index.jsp?topic=/adaptec_cli.xml/Topics/arcconf_setstate.html
- https://blog.51cto.com/u_1130739/1771506
