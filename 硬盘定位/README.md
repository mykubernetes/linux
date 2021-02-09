服务器硬盘定位方法
---

1、前提条件  
目前支持 LSI SAS2308 和 LSI SAS3008服务器。（Avago的卡）(Avago 收购了Broadcom, LSI  后来Avago又更名为Broadcom)  
可以使用以下方法确认HBA卡型号。  
命令1：
```
#cat /sys/class/scsi_host/host*/version_product
```
命令2：
```
#lspci | grep SAS
```

2、工具  
- 如果是 2308的卡使用：sas2ircu
- 如果是 3008的卡使用：sas3ircu  (用于LSI SAS3 Controllers)

其他卡可以用这两个工具试一下。
```
#./sas2ircu  list
或
#./sas3ircu  list
```

3、查看硬盘串号  
```
#如果找 sdf的串号，可以尝试以下三个命令。

# hdparm -I /dev/sdf | grep 'Serial Number' 
# smartctl -i /dev/sdf | grep 'Serial Number'
# ll /dev/disk/by-id/ | grep sdf
```

4、查看控制器编号
```
#./sas3ircu list
编号是0 （一般都是0）
```

5、查看槽位
```
#./sas3ircu 0 display | grep -B 10 -A 4 Z840Z1M1
Enclosure #        : 2
Slot #             ：2
······
Serial No          : Z840Z1M1
```

6、操作定位灯
```
开灯：
# ./sas3ircu  0 locate 2:2 on
其中的  2:2 来自上个命令找到的槽位号
```


MegaCli 安装及常用命令
---
1.安装
```
#rpm -ivh MegaCli-8.05.06-1.noarch.rpm  安装在/opt下
```
2.常用命令
```
# ./MegaCli64  -LDInfo -Lall -aALL 查raid级别
# ./MegaCli64 -AdpAllInfo -aALL 查raid卡信息
# ./MegaCli64 -PDList -aALL 查看硬盘信息
# ./MegaCli64 -AdpBbuCmd -aAll 查看电池信息
# ./MegaCli64 -FwTermLog -Dsply -aALL 查看raid卡日志
# ./MegaCli64 -adpCount 【显示适配器个数】
# ./MegaCli64 -AdpGetTime –aALL 【显示适配器时间】
# ./MegaCli64 -AdpAllInfo -aAll    【显示所有适配器信息】
# ./MegaCli64 -LDInfo -LALL -aAll    【显示所有逻辑磁盘组信息】
# ./MegaCli64 -PDList -aAll    【显示所有的物理信息】
# ./MegaCli64 -cfgdsply -aALL  【显示Raid卡型号，Raid设置，Disk相关信息】
```

LSI StorCLI64 工具安装和使用教程
---

https://www.cnblogs.com/chong93/p/10470032.html

https://www.cnblogs.com/luxiaodai/p/9878747.html

1、确认硬件类型

确认当前Raid卡是否可以通过 StorCLI64 来管理,先使用 lspci 查看当前设备的描述信息
```
lspci -k
01:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS-3 3108 [Invader] (rev 02)
        Subsystem: Super Micro Computer Inc Device 0809
        Kernel driver in use: megaraid_sas
        Kernel modules: megaraid_sas
```
可以看到使用硬件类型为 LSI Logic / Symbios Logic MegaRAID SAS-3 3108, 系统使用的内核驱动为 megaraid_sas

2、下载安装包
官网https://www.broadcom.com

联想官网https://download.lenovo.com/pccbbs/thinkservers/ul_avago_storcli_1.18.11_anyos.zip

```
cd /opt/MegaRAID/storcli/
./storcli64 /c0 show                                  #可查看Virtual Drives与Physical Drives
./storcli64 /c0/v0 show                               #获取信息
./storcli64 /c0/e58 show　                  　        #获取单个enclosure信息
./storcli64 /c0/e58 show all 　　                     #获取单个enclosure详细信息
./storcli64 /c0/e58 show status　　                   #获取enclosure下磁盘风扇等设备的状态
./storcli64 /call/vall show                           #所有获取信息
./storcli64 /call/eall/sall show all                  #查看所有控制器、所有背板、背板上的所有磁盘的详细信息
./storcli64 /cx/eall/sall show　　                    #显示物理磁盘信息
./storcli64 /c0/eall/sall show all | grep Error       #查看物理盘是否有异常
./storcli64 /c0 show freespace                        #剩余空间
./storcli64 /c0 show rebuildrate                  　　#获取rebuild速率
./storcli64 /c0 set rebuildrate=30　　                #设置rebuild速率
./storcli64 /c0 flushcache　　                        #清除raid卡、物理磁盘cache
```
- /c 控制器号 输出结果中的Controller 值
- /v  RAID号
- /e 背板号  输出结果EID值
- /f 外部配置
- /s 槽位号 输出结果的Slt值

```
# 磁盘状态设置
./storcli64 /c0/e36/s1 set good              #设置控制器 0 背板36 槽位号1的磁盘状态为good
./storcli64 /c0/e36/s1 set offline           #设置控制器 0 背板36 槽位号1的磁盘状态为offline
./storcli64 /c0/e36/s1 set online            #设置控制器 0 背板36 槽位号1的磁盘状态为online
./storcli64 /c0/e36/s1 set missing　　　　    #设置控制器 0 背板36 槽位号1的磁盘状态为掉线


#磁盘初始化
#磁盘在其他系统中使用过磁盘不干净的情况下需对磁盘进行初始化，初始化会清理掉磁盘上的所有数据
./storcli64 /cx/ex/sx show initialization      #查看正在初始化的磁盘
./storcli64 /cx/ex/sx start initialization     #磁盘开始初始化
./storcli64 /cx/ex/sx stop initialization      #停止磁盘的初始化

#RAID一致性校验
storcli64 /cx/vx show cc               #查看初始化
storcli64 /cx/vx start cc              #开启初始化
storcli64 /cx/vx stop cc               #停止初始化

# 磁盘点灯
./storcli64 /cx/ex/sx start locate
./storcli64 /cx/ex/sx stop locate


# 磁盘热备
./storcli64 /cx/ex/sx add hotsparedrive dgs=x　　设置模块磁盘为diskgroup x 的热备盘
storcli64 /cx/ex/sx delete hotsparedrive
 
# 磁盘rebuild
./storcli64 /cx/ex/sx show rebuild　　查看rebild
./storcli64 /cx/ex/sx start rebuild
./storcli64 /cx/ex/sx stop rebuild


##磁盘擦除
# 快速擦除：
./storcli64 /cx/ex/sx set good
./storcli64 /cx/fall del|delete [securityKey = xxx]

# 完全擦除：
./storcli /cx[/ex]/sx secureerase [force]
./storcli /cx[/ex]/sx start erase [simple| normal| thorough | standard| threepass | crypto]
./storcli /cx[/ex]/sx stop erase
./storcli /cx[/ex]/sx show erase

# 日志
./storcli64 /cx clear events                           #清除所有日志事件
./storcli64 /cx delete termlog                         #删除TTY（用于故障定位的固件输出信息） 日志 
./storcli64 /cx show events file=<absolute path>       #将日志信息保存到指定文件 
./storcli64 /cx show eventloginfo                      #查看产生日志文件的历史信息  
./storcli64 /cx show termlog type=config|contents      #查看term log 日志配置或者日志信息 

```
